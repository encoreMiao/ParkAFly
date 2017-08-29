//
//  PersonalAccountViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalAccountViewController.h"
#import "BAFCenterViewController.h"
#import "WechatCollectionViewCell.h"
#import "CardRechargeCollectionViewCell.h"
#import "ChargeFooterCollectionReusableView.h"
#import "AccountDetailViewController.h"
#import "BAFChargeInfo.h"
#import "WXApi.h"
#import "BAFChargePageInfo.h"
#import "SuccessViewController.h"
#import "WXApi.h"


#define WechatCollectionViewCellIdentifier        @"WechatCollectionViewCellIdentifier"
#define CardRechargeCollectionViewCellIdentifier  @"CardRechargeCollectionViewCellIdentifier"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexPersonalAccount,//账户充值列表
    kRequestNumberIndexRechargeCard,//卡密充值
    kRequestNumberIndexRechargeCreate,//获取个人账户微信充值订单编号
    kRequestNumberIndexClientInfo,//获取个人信息
    kRequestNumberIndexRechargeSign,//订单签名
};

typedef NS_ENUM(NSInteger,PersonalAccountViewControllerType)
{
    kPersonalAccountViewControllerTypeWechat,//微信充值
    kPersonalAccountViewControllerTypeCard,//卡密充值
};


@interface PersonalAccountViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ChargeFooterCollectionReusableViewDelegate,WXApiDelegate>
@property (weak, nonatomic)     IBOutlet UILabel    *balanceTable;//账户余额
@property (weak, nonatomic)     IBOutlet UIButton   *cardChargeButton;
@property (weak, nonatomic)     IBOutlet UIButton   *wechatChargeButton;
@property (strong, nonatomic)   IBOutlet UIView     *headerView;

@property (strong, nonatomic) UICollectionView              *mycollectionview;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layoutForWechatType;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layoutForCardType;
@property (nonatomic, assign) PersonalAccountViewControllerType type;

@property (nonatomic, strong) NSMutableArray *rechargeList;//账户余额充值列表
@property (nonatomic, strong) BAFChargeInfo *currentChargeInfo;//当前选择的微信充值info
@property (nonatomic, strong) NSIndexPath  *selectedIndexpath;//选择的充值方式
@property (nonatomic, strong) NSString *orderID;

@property (nonatomic, strong) NSMutableArray *activityList;//活动列表
@end



@implementation PersonalAccountViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerView.frame = CGRectMake(0, 0, screenWidth, 170);
    [self.view addSubview:self.headerView];
    
    [self chargeSelectedAction:self.wechatChargeButton];
    
    self.mycollectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layoutForWechatType];
    _mycollectionview.scrollEnabled = NO;
    _mycollectionview.backgroundColor = [UIColor clearColor];
    [_mycollectionview registerNib:[UINib nibWithNibName:@"WechatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WechatCollectionViewCellIdentifier];
    [_mycollectionview registerNib:[UINib nibWithNibName:@"CardRechargeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CardRechargeCollectionViewCellIdentifier];
    self.mycollectionview.delegate = self;
    self.mycollectionview.dataSource = self;
    [self.view addSubview:self.mycollectionview];
    
    [self.mycollectionview registerNib:[UINib nibWithNibName:@"ChargeFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    
    self.rechargeList = [NSMutableArray array];
    self.activityList = [NSMutableArray array];
    
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    self.balanceTable.text = [NSString stringWithFormat:@"%.0f元",userInfo.account.integerValue/100.0f];
    
    self.selectedIndexpath = nil;
    
    self.wechatChargeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    self.cardChargeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"账户余额"];
    [self setNavigationRightButtonWithText:@"明细" method:@selector(rightBtnClicked:)];
    
    self.mycollectionview.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screenWidth, screenHeight-170);
    
    [self wechatReqeust];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paysuccess) name:PaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payfailure) name:PayFailureNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:PayFailureNotification object:nil];
}

- (void)paysuccess
{
    NSLog(@"hh支付成功");
    [self getAccountInfo];
}

- (void)payfailure
{
    NSLog(@"hh支付失败");
}

- (void)backMethod:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender
{
    AccountDetailViewController  *accountDetailVC = [[AccountDetailViewController alloc]init];
    [self.navigationController pushViewController:accountDetailVC animated:YES];
}



- (IBAction)chargeSelectedAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"微信充值"]) {
        self.wechatChargeButton.selected = YES;
        self.cardChargeButton.selected = NO;
         [self.mycollectionview setCollectionViewLayout:self.layoutForWechatType];
        self.type = kPersonalAccountViewControllerTypeWechat;
        self.layoutForWechatType.footerReferenceSize = CGSizeMake(screenWidth, 200);
    }else{
        self.wechatChargeButton.selected = NO;
        self.cardChargeButton.selected = YES;
        [self.mycollectionview setCollectionViewLayout:self.layoutForCardType];
        self.type = kPersonalAccountViewControllerTypeCard;
        self.layoutForCardType.footerReferenceSize = CGSizeMake(screenWidth, 200);
    }
    [self.mycollectionview reloadData];
}

- (UICollectionViewFlowLayout *)layoutForCardType
{
    if (!_layoutForCardType) {
        CGFloat itemTotolWidth = screenWidth-30;
        CGFloat itemWidth = itemTotolWidth;
        CGFloat itemHeight  = 42.0f;
        _layoutForCardType = [[UICollectionViewFlowLayout alloc] init];
        _layoutForCardType.minimumLineSpacing = 15;
        _layoutForCardType.minimumInteritemSpacing = 0;
        _layoutForCardType.itemSize = CGSizeMake(itemWidth, itemHeight);
        _layoutForCardType.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _layoutForCardType;
}


- (UICollectionViewFlowLayout *)layoutForWechatType
{
    if (!_layoutForWechatType) {
        CGFloat itemTotolWidth = screenWidth-30-30;
        CGFloat itemWidth = itemTotolWidth/3.0f;
        CGFloat itemHeight  = 62.0f;
        _layoutForWechatType = [[UICollectionViewFlowLayout alloc] init];
        _layoutForWechatType.minimumLineSpacing = 18;
        _layoutForWechatType.minimumInteritemSpacing = 15;
        _layoutForWechatType.itemSize = CGSizeMake(itemWidth, itemHeight);
        _layoutForWechatType.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _layoutForWechatType;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.type == kPersonalAccountViewControllerTypeWechat) {
        return self.rechargeList.count;
    }else{
        return 2;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == kPersonalAccountViewControllerTypeWechat) {
        WechatCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WechatCollectionViewCellIdentifier forIndexPath:indexPath];
        BAFChargeInfo *chargeInfo = self.rechargeList[indexPath.row];
        BOOL isAcitvity = NO;
        if (self.activityList.count >0) {
            for (BAFChargePageActivityInfo *obj in self.activityList) {
                if ([obj.id isEqualToString:chargeInfo.activityid]) {
                    isAcitvity = YES;
                }
            }
        }
        if (isAcitvity) {
            cell.type = kWechatCollectionViewCellTypeActivity;
        }else{
            cell.type = kWechatCollectionViewCellTypeCommon;
        }
        [cell setChargeInfo:chargeInfo];
        
        if (self.selectedIndexpath&&self.selectedIndexpath == indexPath) {
            [cell setCollectionSelected:YES];
        }else{
            [cell setCollectionSelected:NO];
        }
        
        return cell;
    }else{
        CardRechargeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CardRechargeCollectionViewCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.inputTF.text = @"";
            cell.inputTF.placeholder = @"请输入卡号";
        }else{
            cell.inputTF.text = @"";
            cell.inputTF.placeholder = @"请输入密码";
        }
        return cell;
    }
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter)
    {
        ChargeFooterCollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        NSMutableString *str = [[NSMutableString alloc]init];
        if (self.activityList.count>0) {
            BAFChargePageActivityInfo *activityInfo = self.activityList[0];
            NSString *s = activityInfo.descriptionOfActivity;
            if (s) {
                [str appendFormat:@"说明\n%@",s];
            }else{
                [str appendString:@"说明\n1.用户将金额充值到泊安飞账户，当时充值当时到账。\n2.进行充值后，余额会显示在“个人中心-账户”中，用于泊安飞下单时使用。\n3.充值送现金活动即将推出，敬请期待。"];
            }
        }
        else{
            [str appendString:@"说明\n1.用户将金额充值到泊安飞账户，当时充值当时到账。\n2.进行充值后，余额会显示在“个人中心-账户”中，用于泊安飞下单时使用。\n3.充值送现金活动即将推出，敬请期待。"];
        }
        NSMutableAttributedString *mutattr = [[NSMutableAttributedString alloc]initWithString:str];
        [mutattr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9]} range:[str rangeOfString:@"说明"]];
        footerview.label.attributedText = mutattr;
        footerview.delegate = self;
        reusableView = footerview;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == kPersonalAccountViewControllerTypeWechat) {
        WechatCollectionViewCell *cell = (WechatCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (self.selectedIndexpath) {
            WechatCollectionViewCell *cell1 = (WechatCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.selectedIndexpath];
            [cell1 setCollectionSelected:NO];
        }
        self.selectedIndexpath = indexPath;
        [cell setCollectionSelected:YES];
        self.currentChargeInfo = cell.chargeInfo;
    }
}
#pragma mark - ChargeFooterCollectionReusableViewDelegate
- (void)chargeActionDelegate:(ChargeFooterCollectionReusableView *)footerView
{
    if (self.type == kPersonalAccountViewControllerTypeWechat) {
        //先进行为空的判断
        if (!self.selectedIndexpath) {
            [self showTipsInView:self.view message:@"请选择充值金额" offset:self.view.center.x+100];
            return;
        }
        //充money赠送giftmoney支付金额pay_money
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
        [param setObject:userInfo.clientid forKey:@"client_id"];
        [param setObject:self.currentChargeInfo.money forKey:@"recharge_money"];
        [param setObject:self.currentChargeInfo.giftmoney forKey:@"gift_money"];
        [param setObject:self.currentChargeInfo.id forKey:@"rechargeid"];
        [param setObject:self.currentChargeInfo.activityid forKey:@"activityid"];
        [param setObject:self.currentChargeInfo.discount forKey:@"recharge_discount"];
        [self createWeChatOderWithParam:param];
        
    }else{
        NSIndexPath *indexpath1 = [NSIndexPath indexPathForItem:0 inSection:0];
        NSIndexPath *indexpath2 = [NSIndexPath indexPathForItem:1 inSection:0];
        CardRechargeCollectionViewCell *cell1 = (CardRechargeCollectionViewCell *)[self.mycollectionview cellForItemAtIndexPath:indexpath1];
        CardRechargeCollectionViewCell *cell2 = (CardRechargeCollectionViewCell *)[self.mycollectionview cellForItemAtIndexPath:indexpath2];
        if (cell1.inputTF.text.length<=0) {
            [self showTipsInView:self.view message:@"请输入卡号" offset:self.view.center.x+100];
        }else if (cell2.inputTF.text.length<=0){
            [self showTipsInView:self.view message:@"请输入密码" offset:self.view.center.x+100];
        }else{
            [self rechargeCarRequestWithCardNumber:cell1.inputTF.text cardPassword:cell2.inputTF.text];
        }
    }
}


#pragma mark - REQUEST
- (void)rechargeCarRequestWithCardNumber:(NSString *)cardNum cardPassword:(NSString *)cardPass
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personCenterReq rechargeCardRequestWithNumberIndex:kRequestNumberIndexRechargeCard delegte:self client_id:userInfo.clientid card_no:cardNum  card_password:cardPass];
    
}
- (void)wechatReqeust
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personCenterReq personalAccountRequestWithNumberIndex:kRequestNumberIndexPersonalAccount delegte:self client_id:userInfo.clientid];
}
- (void)createWeChatOderWithParam:(NSDictionary *)dic
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq rechargeOrderRequestWithNumberIndex:kRequestNumberIndexRechargeCreate delegte:self param:dic];
}

- (void)getAccountInfo
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personCenterReq clientInfoRequestWithNumberIndex:kRequestNumberIndexClientInfo delegte:self client_id:userInfo.clientid];
}

- (void)createSignWithParam:(NSDictionary *)dic
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq rechargeSignRequestWithNumberIndex:kRequestNumberIndexRechargeSign delegte:self param:dic];
}

-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexPersonalAccount) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //账户余额充值页面 BAFChargePageInfo
            //data->activity BAFChargePageActivityInfo
            //data->rechargelist BAFChargePageRechargeInfo
            if (self.rechargeList) {
                [self.rechargeList removeAllObjects];
            }
            self.activityList = [NSMutableArray arrayWithArray:[BAFChargePageActivityInfo mj_objectArrayWithKeyValuesArray:[[obj objectForKey:@"data"] objectForKey:@"activity"]]];
            
            self.rechargeList = [NSMutableArray arrayWithArray:[BAFChargeInfo mj_objectArrayWithKeyValuesArray:[[obj objectForKey:@"data"] objectForKey:@"rechargelist"]]];
            [self.mycollectionview reloadData];
        }else{
            
        }
    }
    
    
    if (aRequestID == kRequestNumberIndexRechargeCard) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self showTipsInView:self.view message:@"充值成功" offset:self.view.center.x+100];
            [self.mycollectionview reloadData];//清空之前的充值数据。
            [self getAccountInfo];
        }else{
            NSUInteger failureCode =[[obj objectForKey:@"code"] integerValue];
            NSString *failureStr = nil;
            switch (failureCode) {
                case 1:
                    failureStr = @"卡号格式错误";
                    break;
                case 2:
                    failureStr = @"卡密格式错误";
                    break;
                case 3:
                    failureStr = @"缺少参数";
                    break;
                case 4:
                    failureStr = @"充值卡不存在";
                    break;
                case 5:
                    failureStr = @"充值卡已使用";
                    break;
                case 6:
                    failureStr = @"充值卡无效";
                    break;
                case 7:
                    failureStr = @"充值卡未售出";
                    break;
                case 8:
                    failureStr = @"充值失败";
                    break;
                default:
                    break;
            }
            if (failureStr) {
                [self showTipsInView:self.view message:failureStr offset:self.view.center.x+100];
            }
            [self getAccountInfo];
        }
    }
    
    if (aRequestID == kRequestNumberIndexRechargeCreate) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.orderID = [obj objectForKey:@"data"];
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:[NSString stringWithFormat:@"%@",self.orderID] forKey:@"out_trade_no"];
            [param setObject:self.currentChargeInfo.pay_money forKey:@"total_fee"];
            [param setObject:@"recharge" forKey:@"pay_type"];
            [self createSignWithParam:param];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexClientInfo) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            BAFUserInfo *userInfo = [BAFUserInfo mj_objectWithKeyValues:[obj objectForKey:@"data"]];
            [[BAFUserModelManger sharedInstance]saveUserInfo:userInfo];
            self.balanceTable.text = [NSString stringWithFormat:@"%.0f元",userInfo.account.integerValue/100.0f];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexRechargeSign) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self getwechatpay:[obj objectForKey:@"data"]];
        }else{
            NSUInteger failureCode =[[obj objectForKey:@"code"] integerValue];
            NSString *failureStr = nil;
            switch (failureCode) {
                case 1:
                    failureStr = @"缺少参数";
                    break;
                case 0:
                    failureStr = @"缺少参数";
                    break;
                default:
                    break;
            }
            if (failureStr) {
                [self showTipsInView:self.view message:failureStr offset:self.view.center.x+100];
            }
        
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

//- (void)rechargeSuccess
//{
//    SuccessViewController *successVC = [[SuccessViewController alloc]init];
//    successVC.type = kSuccessViewControllerTypeRechargeSuccess;
//    [self.navigationController pushViewController:successVC animated:YES];
//    //充值金额和充值时间
//}


- (void)getwechatpay:(NSDictionary *)dict
{
    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];//stamp.intValue
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"sign"];
    [WXApi sendReq:req];
    //日志输出
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
}
@end
