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

#define WechatCollectionViewCellIdentifier        @"WechatCollectionViewCellIdentifier"
#define CardRechargeCollectionViewCellIdentifier  @"CardRechargeCollectionViewCellIdentifier"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexPersonalAccount,//账户充值列表
    kRequestNumberIndexRechargeCard,//卡密充值
    kRequestNumberIndexRechargeCreate,//获取个人账户微信充值订单编号
};

typedef NS_ENUM(NSInteger,PersonalAccountViewControllerType)
{
    kPersonalAccountViewControllerTypeWechat,//微信充值
    kPersonalAccountViewControllerTypeCard,//卡密充值
};


@interface PersonalAccountViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ChargeFooterCollectionReusableViewDelegate>
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
    [self setNavigationRightButtonWithText:@"充值明细" method:@selector(rightBtnClicked:)];
    
    self.mycollectionview.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screenWidth, screenHeight-170);
    
    [self wechatReqeust];
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES] ;
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
        if (indexPath.row == 0) {
            cell.type = kWechatCollectionViewCellTypeActivity;
        }else{
            cell.type = kWechatCollectionViewCellTypeCommon;
        }
        [cell setChargeInfo:self.rechargeList[indexPath.row]];
//        id item = [self itemAtIndexPath:indexPath];
//        BOOL isCollected = [self isCollectedItemAtIndexPath:indexPath];
//        self.configureCellBlock(cell, item, isCollected);
        return cell;
    }else{
        CardRechargeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CardRechargeCollectionViewCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.type = kCardRechargeCollectionViewCellTypeCardNumber;
        }else{
            cell.type = kCardRechargeCollectionViewCellTypeCode;
        }
//        id item = [self itemAtIndexPath:indexPath];
//        BOOL isCollected = [self isCollectedItemAtIndexPath:indexPath];
//        self.configureCellBlock(cell, item, isCollected);
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
//        footerview.backgroundColor = [UIColor purpleColor];
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
        [cell setCollectionSelected:YES];
        self.currentChargeInfo = cell.chargeInfo;
    }
    
    
    
//    //    if (collectionV.cellIndexPath.section == 0) {
//    MBKStickerItemModel *model = [(MBKCollectionDataSource *)collectionV.dataSource itemAtIndexPath:indexPath];
//    NSString *sticker = [model.imgUrl urlencode]; //贴纸图片链接
//    NSString *stickerName = [model.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//贴纸名称
//    NSString *amount = model.collectedNum;
//    BOOL own = [(MBKCollectionDataSource *)collectionV.dataSource isCollectedItemAtIndexPath:indexPath];//是否获得(true false)
//    //        NSString *h5host = @"https://integration-m.mobike.com";
//    NSString *h5host = ((configs *)[[MBKSettingStore sharedInstance]getConfigInfo]).h5BaseUrl;
//    NSString *urlStr = [NSString stringWithFormat:@"%@/app/pages/treasure_hunt_sticker/index.html?sticker=%@&stickerName=%@&amount=%@&own=%@",h5host,sticker,stickerName,amount,own?@"true":@"false"];
//    MBKWebViewController *webView = [[MBKWebViewController alloc] initWithUrlString:urlStr andTitle:nil];
//    webView.view.backgroundColor = [[UIColor colorWithHex:0x262930] colorWithAlphaComponent:1];
//    webView.myWebView.mj_h = screenHeight;
//    webView.myWebView.mj_y = -64;
//    [self pushViewControllerA:webView animated:YES];
//    //    }
}
#pragma mark - ChargeFooterCollectionReusableViewDelegate
- (void)chargeActionDelegate:(ChargeFooterCollectionReusableView *)footerView
{
    if (self.type == kPersonalAccountViewControllerTypeWechat) {
        //先进行为空的判断
        
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
        [self rechargeCarRequestWithCardNumber:@"" cardPassword:@""];
    }
}


#pragma mark - REQUEST
- (void)rechargeCarRequestWithCardNumber:(NSString *)cardNum cardPassword:(NSString *)cardPass
{
    //    /pay/recharge_card
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
//    rechargeOrderRequestWithNumberIndex
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq rechargeOrderRequestWithNumberIndex:kRequestNumberIndexRechargeCreate delegte:self param:dic];
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
            self.rechargeList = [NSMutableArray arrayWithArray:[BAFChargeInfo mj_objectArrayWithKeyValuesArray:[[obj objectForKey:@"data"] objectForKey:@"rechargelist"]]];
            [self.mycollectionview reloadData];

        }else{
            //
        }
    }
    
    
    if (aRequestID == kRequestNumberIndexRechargeCard) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexRechargeCreate) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //订单编号是 data = 011201707090042751;
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}





+ (NSString *)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";//服务端的接口
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
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
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}


@end
