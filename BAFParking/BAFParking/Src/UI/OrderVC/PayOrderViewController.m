//
//  PayOrderViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/3.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PayOrderViewController.h"
#import "PayOrderTableViewCell.h"
#import "HRLPersonalCenterRequest.h"
#import "HRLPersonalCenterInterface.h"
#import "HRLogicManager.h"
#import "BAFUserModelManger.h"
#import "PopViewController.h"
#import "BAFTcCardInfo.h"
#import "HRLOrderInterface.h"
#import "CouponViewController.h"
#import "WXApi.h"
#import "SuccessViewController.h"
#import "CommentViewController.h"

#define PayOrderTableViewCellIdentifier  @"PayOrderTableViewCellIdentifier"
#define PayOrderTcCard  @"PayOrderTcCard"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexRightsListRequest,
    kRequestNumberIndexCheckCardRequest,//计算腾讯权益卡费用
    kRequestNumberIndexOrderFeeRequest,
    kRequestNumberIndexOrderDetail,
    kRequestNumberIndexOrderPaymentSet,//设置支付明细
    kRequestNumberIndexRechargeSign,
};

@interface PayOrderViewController ()<UITableViewDelegate, UITableViewDataSource,PopViewControllerDelegate,PayOrderTableViewCellDelegate,WXApiDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderFeeLabel;
@property (weak, nonatomic) IBOutlet  UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet  UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet  UIButton *confirmPayBtn;
@property (weak, nonatomic) IBOutlet  UIButton *moneyPayBtn;
@property (strong, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (strong, nonatomic) NSArray *payListArr;
@property (strong, nonatomic) NSMutableArray *tcCard;

@property (strong, nonatomic) BAFCouponInfo *selectCouponinfo;//选择优惠券
@property (strong, nonatomic) NSString *tcCardFee;//选择权益卡
@property (strong, nonatomic) NSString *selectTcCardNo;//权益卡号
@property (assign, nonatomic) BOOL selectAccount;//选择余额
@property (assign, nonatomic) NSInteger accountAmountShow;//个人账户余额减去的金额

@property (strong, nonatomic) NSMutableDictionary *tcRequestDic;//算权益余额的请求参数

@property (strong, nonatomic) NSMutableDictionary *dicDataSource;//PayOrderTcCard
@property (strong, nonatomic) NSDictionary      *feeDic;
@property (strong, nonatomic) NSMutableArray    *serviceArr;
@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payListArr = @[@"权益账户",@"优惠券",@"个人账户"];
    self.tcCard = [NSMutableArray  array];
    self.dicDataSource = [NSMutableDictionary dictionary];
    self.feeDic = [NSDictionary dictionary];
    self.tcRequestDic = [NSMutableDictionary dictionary];
    
    self.selectCouponinfo = nil;
    self.tcCardFee = nil;
    self.selectAccount = NO;
    
    BAFUserInfo *userinfo = [[BAFUserModelManger sharedInstance] userInfo];
    self.accountAmountShow = userinfo.account.integerValue;
    
    CGSize size = [self.detailBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.detailBtn.titleLabel.font}];
    self.detailBtn.imageEdgeInsets = UIEdgeInsetsMake(0, size.width+10-10, 0, -size.width-10+10);
    self.detailBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -5-10, 0, 5+10);
    
    [self configOrderDic:self.orderDic];
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
    [self setNavigationTitle:@"订单支付"];
    
    [self orderDetailRequest];
    [self orderFeeRequest];
    
    self.confirmPayBtn.hidden = YES;
    self.weixinBtn.hidden = NO;
    self.moneyPayBtn.hidden = NO;
    
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
    CommentViewController  *vc = [[CommentViewController alloc]init];
    vc.orderDic = self.orderDic;
    vc.type = kCommentViewControllerTypePayComment;
//    vc.commentfinishHandler = ^(void){
//        //微信支付成功，评价完成，并不改变任何状态。
//    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)payfailure
{
    NSLog(@"支付失败");
}


- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configOrderDic:(NSDictionary *)dic
{
    self.orderNo.text = [dic objectForKey:@"order_no"];
    self.detailLabel.text = [NSString stringWithFormat:@"%@     %@      %@",[dic objectForKey:@"contact_name"],[dic objectForKey:@"contact_phone"],[dic objectForKey:@"car_license_no"]];
    self.parkLabel.text = [dic objectForKey:@"park_name"];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *datepark = nil;
    datepark =[dateFormat dateFromString:[dic objectForKey:@"actual_park_time"]];
    if (!datepark) {
        datepark =[dateFormat dateFromString:[dic objectForKey:@"plan_park_time"]];
    }
    NSString *strpark = [dateFormat1 stringFromDate:datepark];
    
    self.parkTimeLabel.text = strpark;
}

- (void)popTcCard
{
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    popView.delegate = self;
    [popView configViewWithData:self.tcCard type:kPopViewControllerTypeTcCard];
    [self presentViewController:popView animated:NO completion:nil];
}

- (IBAction)detailAction:(id)sender {
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    [popView configViewWithData:[self configTotoalfee] type:kPopViewControllerTypeTipsshow];
    [self presentViewController:popView animated:NO completion:nil];
}

- (IBAction)paymentConfirmWithSender:(UIButton *)sender
{
    [self paysuccess];
    return;
    
    //支付方式:cash.现金支付;confirm. 确认支付;wechat.微信支付
    NSString *paymode;
    if ([sender.titleLabel.text isEqualToString:@"现金支付"]) {
        paymode = @"cash";
    }else if([sender.titleLabel.text isEqualToString:@"确认支付"]){
        paymode = @"confirm";
    }else{
        paymode = @"wechat";
    }
    //    order/order_payment_set
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:paymode forKey:@"paymode"];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [param setObject:userInfo.clientid forKey:@"client_id"];//客户 id
    [param setObject:[self.orderDic objectForKey:@"id"] forKey:@"order_id"];//订单 id
    
    if (self.selectCouponinfo) {
        [param setObject:self.selectCouponinfo.number forKey:@"coupon_code"];//优惠码
        [param setObject:[NSString stringWithFormat:@"%.0f",self.selectCouponinfo.price.integerValue/100.0f] forKey:@"coupon_pay_money"];//优惠券抵扣金额(以元为单位)
    }
    
    if (self.tcCardFee) {
        [param setObject:self.selectTcCardNo forKey:@"activity_code"];//权益卡号
        [param setObject:[NSString stringWithFormat:@"%.0f",self.tcCardFee.integerValue/100.0f] forKey:@"activity_pay_money"];//权益账户抵扣金额
    }
    
    if (self.selectAccount) {
        [param setObject:[NSString stringWithFormat:@"%.0f",self.accountAmountShow/100.0f] forKey:@"account_pay_money"];//个人账户余额支付部分
    }
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.totalFeeLabel.text];
    [param setObject:[str stringByReplacingOccurrencesOfString:@"¥" withString:@""] forKey:@"actual_pay_money"];//微信支付或现金支付部分

    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [orderReq orderPaymentSetWithNumberIndex:kRequestNumberIndexOrderPaymentSet delegte:self param:param];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PayOrderTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PayOrderTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PayOrderTableViewCell" owner:nil options:nil] firstObject];
        cell.delegate = self;
    }
    cell.titleLabel.text = [self.payListArr objectAtIndex:indexPath.row];
    if (![self canbeSelectedInCurrentIndexPath:indexPath]){
        cell.titleLabel.textColor = [UIColor colorWithHex:0x969696];
        cell.userInteractionEnabled = NO;
    }else{
        cell.titleLabel.textColor = [UIColor colorWithHex:0x323232];
        cell.userInteractionEnabled = YES;
    }

    if (indexPath.row == 0) {
        if ([self.dicDataSource objectForKey:PayOrderTcCard]) {
            NSString *moneyStr = [NSString stringWithFormat:@"%@ -¥%.0f",[self.dicDataSource objectForKey:PayOrderTcCard],self.tcCardFee.integerValue/100.0f];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[moneyStr rangeOfString:[NSString stringWithFormat:@"-¥%.0f",self.tcCardFee.integerValue/100.0f]]];
            cell.moneyLabel.attributedText = mutStr;
            [cell setShow:YES];
        }else{
            [cell setShow:NO];
        }
    }else if (indexPath.row == 1){
        if (self.selectCouponinfo) {
            NSString *moneyStr = [NSString stringWithFormat:@"-¥%.0f",self.selectCouponinfo.price.integerValue/100.0f];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[moneyStr rangeOfString:[NSString stringWithFormat:@"-¥%.0f",self.selectCouponinfo.price.integerValue/100.0f]]];
            cell.moneyLabel.attributedText = mutStr;
            [cell setShow:YES];
        }else{
            cell.moneyLabel.text = @"";
            [cell setShow:NO];
        }
    }else if (indexPath.row == 2){
        cell.detailImg.hidden = YES;
        BAFUserInfo *userinfo = [[BAFUserModelManger sharedInstance] userInfo];
        if (self.selectAccount) {
            NSString *moneyStr = [NSString stringWithFormat:@"-¥%.0f",self.accountAmountShow/100.0f];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[moneyStr rangeOfString:[NSString stringWithFormat:@"-¥%.0f",self.accountAmountShow/100.0f]]];
            cell.moneyLabel.attributedText = mutStr;
            [cell setShow: YES];
        }else{
            NSString *moneyStr = [NSString stringWithFormat:@"余额¥%.0f",userinfo.account.integerValue/100.0f];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[moneyStr rangeOfString:[NSString stringWithFormat:@"余额¥%.0f",userinfo.account.integerValue/100.0f]]];
            cell.moneyLabel.attributedText = mutStr;
            [cell setShow:NO];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![self canbeSelectedInCurrentIndexPath:indexPath]) {
        return;
    }
    
    if (indexPath.row == 0) {
        if (self.tcCard.count == 0) {
            [self showTipsInView:self.view message:@"当前未绑定权益卡" offset:self.view.center.x+100];
            return;
        }
        [self popTcCard];
    }else if (indexPath.row == 1) {
        [self jumpToCouponVC];
    }
}

#pragma mark - PayOrderTableViewCellDelegate
- (void)selectBtnDelegate:(PayOrderTableViewCell *)cell
{
    if ([cell.titleLabel.text isEqualToString:@"权益账户"]) {
        cell.show = !cell.show;
        if (!cell.show) {
            self.tcCardFee = nil;
            if ([self.dicDataSource objectForKey:PayOrderTcCard]) {
                [self.dicDataSource removeObjectForKey:PayOrderTcCard];
            }
            [self orderPaymentSet];
        }else{
            if (self.tcCard.count == 0) {
                [self showTipsInView:self.view message:@"当前未绑定权益卡" offset:self.view.center.x+100];
                cell.show = NO;
                return;
            }
            [self popTcCard];
        }
    }else if ([cell.titleLabel.text isEqualToString:@"优惠券"]) {
        cell.show = !cell.show;
        if (cell.show == YES) {
            //跳转
            [self jumpToCouponVC];
        }else{
            self.selectCouponinfo = nil;
            [self orderPaymentSet];
        }
    }else if ([cell.titleLabel.text isEqualToString:@"个人账户"]) {
        cell.show = !cell.show;
        if (cell.show == YES) {
            self.selectAccount = YES;
        }else{
            self.selectAccount = NO;
        }
        [self orderPaymentSet];
    }
}

- (void)jumpToCouponVC
{
    CouponViewController  *vc = [[CouponViewController alloc]init];
    vc.type = kCouponViewControllerTypeUse;
    vc.handler = ^(BAFCouponInfo *couponinfo){
        self.selectCouponinfo = couponinfo;
        [self orderPaymentSet];
    };
    if (self.selectCouponinfo) {
        vc.selectCouponInfo = self.selectCouponinfo;
    }
    vc.orderId = [self.orderDic objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - PopViewControllerDelegate
- (void)popviewConfirmButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview
{
    switch (type) {
        case kPopViewControllerTypeTcCard:
        {
            BAFTcCardInfo *tcCardInfo = ((BAFTcCardInfo *)[self.tcCard objectAtIndex:popview.selectedIndex.row]);
            [self.dicDataSource removeObjectForKey:PayOrderTcCard];
            [self.dicDataSource setObject:tcCardInfo.type_name forKey:PayOrderTcCard];
            
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.tcRequestDic];
            [muDic setObject:tcCardInfo.card_no forKey:@"card_no"];
            self.selectTcCardNo = tcCardInfo.card_no;
            [self checktCarReqeustWithParam:muDic];
        }
            break;
        default:
            break;
    }
}

- (void)popviewDismissButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview
{
    switch (type) {
        case kPopViewControllerTypeTcCard:
        {
            [self orderPaymentSet];
        }
            break;
        default:
            break;
    }
}

#pragma mark - request
- (void)tcCardRequest
{
    id <HRLPersonalCenterInterface> personReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personReq tcCardRequestWithNumberIndex:kRequestNumberIndexRightsListRequest delegte:self phone:userInfo.ctel];
}

- (void)checktCarReqeustWithParam:(NSDictionary *)param
{
    id <HRLPersonalCenterInterface> personReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personReq checkTcCardRequestWithNumberIndex:kRequestNumberIndexCheckCardRequest delegte:self param:param];
}

- (void)orderFeeRequest
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [orderReq orderFeeRequestWithNumberIndex:kRequestNumberIndexOrderFeeRequest delegte:self order_id:[self.orderDic objectForKey:@"id"]];
}

- (BOOL)canbeSelectedInCurrentIndexPath:(NSIndexPath *)indexpath
{
    NSInteger chargeAmount = [[[self.feeDic objectForKey:@"order_price"]objectForKey:@"before_discount_total_price"] integerValue];
    BAFUserInfo *userinfo = [[BAFUserModelManger sharedInstance] userInfo];
    NSInteger accountAmount = userinfo.account.integerValue;//账户余额
    
    if (self.tcCardFee) {
        //优惠券不能点
        if (indexpath.row == 1) {
            return NO;
        }
    }
    else if (self.selectCouponinfo) {
        //权益账户不能点
        if (indexpath.row == 0) {
            return NO;
        }
    }else if (self.tcCardFee && self.selectAccount){
        //优惠券不能点
        if (indexpath.row == 1) {
            return NO;
        }
    }else if (self.selectCouponinfo && self.selectAccount){
        //权益卡不能点
        if (indexpath.row == 0) {
            return NO;
        }
    }else if (self.selectCouponinfo && (self.selectCouponinfo.price.integerValue>= chargeAmount)){
        //权益卡和余额不能点
        if (indexpath.row == 0) {
            return NO;
        }
        if (indexpath.row == 2) {
            return NO;
        }
    }else if (self.selectAccount && (accountAmount >= chargeAmount)){
        //权益卡和优惠券不能点
        if (indexpath.row == 0) {
            return NO;
        }
        if (indexpath.row == 1) {
            return NO;
        }
    }else if (self.tcCardFee && (self.tcCardFee.integerValue >= chargeAmount)){
        if (indexpath.row == 2) {
            return NO;
        }
        if (indexpath.row == 1) {
            return NO;
        }
    }
    return YES;
}

- (void)orderPaymentSet
{
    NSInteger chargeAmount = [[[self.feeDic objectForKey:@"order_price"]objectForKey:@"before_discount_total_price"] integerValue];
    NSInteger totalFee = [[[self.feeDic objectForKey:@"order_price"]objectForKey:@"after_discount_total_price"] integerValue];
    BAFUserInfo *userinfo = [[BAFUserModelManger sharedInstance] userInfo];
    self.accountAmountShow = userinfo.account.integerValue;//账户余额
    
    if (self.tcCardFee && self.selectCouponinfo) {
        //余额不能点
        totalFee = totalFee - self.tcCardFee.integerValue - self.selectCouponinfo.price.integerValue;
    }else if (self.tcCardFee && self.selectAccount){
        //优惠券不能点
        totalFee = totalFee - self.tcCardFee.integerValue - self.accountAmountShow;
    }else if (self.selectCouponinfo && self.selectAccount){
        //权益卡不能点
        totalFee = totalFee - self.selectCouponinfo.price.integerValue - self.accountAmountShow;
    }else if (self.selectCouponinfo && (self.selectCouponinfo.price.integerValue>= chargeAmount)){
        //权益卡和余额不能点
        totalFee = totalFee - self.selectCouponinfo.price.integerValue;
    }else if (self.selectAccount && (self.accountAmountShow >= chargeAmount)){
        //权益卡和优惠券不能点
        totalFee = totalFee - self.accountAmountShow;
    }else if (self.tcCardFee && (self.tcCardFee.integerValue >=chargeAmount)){
        //优惠券和余额不能点
        totalFee = totalFee - self.tcCardFee.integerValue;
    }
    else if (self.selectCouponinfo){
        //权益卡和余额不能点
        totalFee = totalFee - self.selectCouponinfo.price.integerValue;
    }else if (self.selectAccount){
        //权益卡和优惠券不能点
        totalFee = totalFee - self.accountAmountShow;
    }else if (self.tcCardFee){
        //优惠券和余额不能点
        totalFee = totalFee - self.tcCardFee.integerValue;
    }
    
    
    if (totalFee<=0) {
        totalFee = 0;
    }
    
    if (self.selectAccount) {
        if (totalFee == 0) {
            NSInteger after_discount_total_price = [[[self.feeDic objectForKey:@"order_price"]objectForKey:@"after_discount_total_price"] integerValue];
            self.accountAmountShow = (after_discount_total_price - self.tcCardFee.integerValue - self.selectCouponinfo.price.integerValue);
        }
    }
    if (self.accountAmountShow<=0) {
        self.accountAmountShow = 0;
    }
    
    [self changeTotalFee:totalFee];
    [self.mytableview reloadData];
}

- (void)changeTotalFee:(NSInteger)totalfee
{
    if(totalfee<=0){
        self.weixinBtn.hidden = YES;
        self.moneyPayBtn.hidden = YES;
        self.confirmPayBtn.hidden = NO;
    }else{
        self.weixinBtn.hidden = NO;
        self.moneyPayBtn.hidden = NO;
        self.confirmPayBtn.hidden = YES;
    }
    NSString *totalFeeText = [NSString stringWithFormat:@"¥%ld",totalfee/100];
    self.totalFeeLabel.text = totalFeeText;
    
}

#pragma mark request
- (void)orderDetailRequest
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [mutDic setObject:userInfo.clientid forKey:@"client_id"];
    [orderReq orderDetailRequestWithNumberIndex:kRequestNumberIndexOrderDetail delegte:self order_id:[self.orderDic objectForKey:@"id"]];
}

- (void)createSignWithParam:(NSDictionary *)dic
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq rechargeSignRequestWithNumberIndex:kRequestNumberIndexRechargeSign delegte:self param:dic];
}

#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexRightsListRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self.tcCard removeAllObjects];
            self.tcCard = [BAFTcCardInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
        }else{
            [self.tcCard removeAllObjects];
        }
    }
    
    
    if (aRequestID == kRequestNumberIndexCheckCardRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //计算腾讯权益卡费用成功
            self.tcCardFee = [obj objectForKey:@"data"];
            [self orderPaymentSet];
        }else{
           
        }
    }
    
    if (aRequestID == kRequestNumberIndexOrderPaymentSet) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            NSString *payMethod = [[obj objectForKey:@"data"] objectForKey:@"pay_method"];
            //确认支付和微信支付调转页面相同 恭喜你支付成功（不用传金额）
            if ([payMethod isEqualToString:@"confirm"]){
                //确认支付 支付成功页面
                [self paysuccess];
            }else if ([payMethod isEqualToString:@"cash"]){
                //现金支付 跳转到订单提交成功页面 温馨提示请将待支付金额到现场交给客户经理结算（要传金额）
                SuccessViewController *successVC = [[SuccessViewController alloc]init];
                successVC.type = kSuccessViewControllerTypePay;
                successVC.orderId = [obj objectForKey:@"data"];
//                NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.totalFeeLabel.text];
//                NSString *str1 = [str stringByReplacingOccurrencesOfString:@"¥" withString:@""];
//                successVC.rechargeMoneyStr = [NSString stringWithFormat:@"%ld",str1.integerValue];
                successVC.rechargeMoneyStr = self.totalFeeLabel.text;
                [self.navigationController pushViewController:successVC animated:YES];
                
            }else if ([payMethod isEqualToString:@"wechat"]) {
                //微信支付
                NSString *orderID = [[obj objectForKey:@"data"] objectForKey:@"trade_no"];
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:[NSString stringWithFormat:@"%@",orderID] forKey:@"out_trade_no"];
                NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.totalFeeLabel.text];
                NSString *str1 = [str stringByReplacingOccurrencesOfString:@"¥" withString:@""];
                [param setObject:[NSString stringWithFormat:@"%ld",str1.integerValue*100] forKey:@"total_fee"];
                [param setObject:@"payment" forKey:@"pay_type"];
                [self createSignWithParam:param];
            }
            
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
    
    if (aRequestID == kRequestNumberIndexOrderFeeRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.feeDic = [obj objectForKey:@"data"];
            NSUInteger basicTotalFee = [[[[obj objectForKey:@"data"]objectForKey:@"order_price"]objectForKey:@"before_discount_total_price"] integerValue];
            NSString *feeText = [NSString stringWithFormat:@"订单费用：¥%ld",basicTotalFee/100];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:feeText];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xfb694b],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:[feeText rangeOfString:[NSString stringWithFormat:@"¥%ld",basicTotalFee/100]]];
            self.orderFeeLabel.attributedText = mutStr;
            
            [self orderPaymentSet];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexOrderDetail) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.orderDic = [NSDictionary dictionaryWithDictionary:[obj objectForKey:@"data"]];
            NSDictionary *orderFeeDetail = [self.orderDic objectForKey:@"order_fee_detail"];
            NSDictionary *orderPrice =[orderFeeDetail objectForKey:@"order_price"];
            NSDictionary *basicDic = [[orderPrice objectForKey:@"basic"] objectForKey:@"101"];

            [self.tcRequestDic removeAllObjects];
            BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
            [self.tcRequestDic setObject:userInfo.ctel forKey:@"phone"];
            [self.tcRequestDic setObject:userInfo.clientid forKey:@"client_id"];
            [self.tcRequestDic setObject:[basicDic objectForKey:@"first_day_price"] forKey:@"first_day_price"];
            [self.tcRequestDic setObject:[basicDic objectForKey:@"strike_price"] forKey:@"day_price"];
            [self.tcRequestDic setObject:[[self.orderDic objectForKey:@"order_fee_detail"] objectForKey:@"park_day"] forKey:@"park_day"];
            
            NSInteger totalFee = 0;
            NSInteger firstdayfee = [[basicDic objectForKey:@"first_day_price"] integerValue];
            NSInteger dayfee = [[basicDic objectForKey:@"strike_price"] integerValue];
            NSInteger days = -1;
            if ([orderFeeDetail objectForKey:@"park_day"]) {
                days = [[orderFeeDetail objectForKey:@"park_day"] integerValue];
            }
            if (days>1) {
                totalFee = firstdayfee + dayfee*(days-1);
            }else{
                totalFee = firstdayfee;
            }
            [self.tcRequestDic setObject:[NSNumber numberWithDouble:totalFee] forKey:@"park_fee"];
            [self tcCardRequest];
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}


- (NSArray *)configTotoalfee
{
    [self configOrderDicService:self.orderDic];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    NSInteger totalFee = 0;
    NSDictionary *orderFeeDetail = [self.orderDic objectForKey:@"order_fee_detail"];
    NSDictionary *orderPrice =[orderFeeDetail objectForKey:@"order_price"];
    NSDictionary *basicDic = [[orderPrice objectForKey:@"basic"] objectForKey:@"101"];
    NSInteger firstdayfee = [[basicDic objectForKey:@"first_day_price"] integerValue];
    NSInteger dayfee = [[basicDic objectForKey:@"strike_price"] integerValue];//market_price
    NSInteger days = -1;
    
    BOOL willHaveParkFee = NO;
    if ([[self.orderDic objectForKey:@"actual_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]) {
        if ([[self.orderDic objectForKey:@"plan_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]){
            willHaveParkFee = NO;
        }else{
            willHaveParkFee = YES;
        }
    }else {
        willHaveParkFee = YES;
    }

    if (willHaveParkFee) {
        if ([orderFeeDetail objectForKey:@"park_day"]) {
            days = [[orderFeeDetail objectForKey:@"park_day"] integerValue];
        }
        days = days-1;
        if (days>=0) {
            totalFee = firstdayfee + dayfee*days;
        }else{
            totalFee = firstdayfee;
        }
    }
    
    if ([orderPrice objectForKey:@"single"]) {
        for (NSString *str in self.serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"&"];
            if ([str containsString:@"自行往返"]) {
                totalFee -= [detailArr[1] integerValue];
            }else{
                totalFee += [detailArr[1] integerValue];
            }
        }
    }
    [mutArr addObject:[NSArray arrayWithObjects:[self orderFeeStr],[NSString stringWithFormat:@"¥%ld",totalFee/100], nil]];
    
    if (willHaveParkFee) {
        if (days>0) {
            [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元+%ld元*%ld天)",firstdayfee/100,dayfee/100,days],[NSString stringWithFormat:@"¥%ld",(firstdayfee + dayfee*days)/100], nil]];
        }else{
            [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元)",firstdayfee/100],[NSString stringWithFormat:@"¥%ld",firstdayfee/100], nil]];
        }
    }
    
    if (self.serviceArr.count>0) {
        for (NSString *str in self.serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"&"];
            if ([str containsString:@"自行往返"]) {
                [mutArr addObject:[NSArray arrayWithObjects:detailArr[0],[NSString stringWithFormat:@"-¥%ld",[detailArr[1] integerValue]/100], nil]];
            }else{
                [mutArr addObject:[NSArray arrayWithObjects:detailArr[0],[NSString stringWithFormat:@"¥%ld",[detailArr[1] integerValue]/100], nil]];
            }
            
        }
    }
    
    
//    if ([[self orderFeeStr] isEqualToString:@"预计费用"]) {
//        //应支付
//        [mutArr addObject:[NSArray arrayWithObjects:@"应支付",[NSString stringWithFormat:@"¥%ld",totalFee/100], nil]];
//    }else{
        //支付方式
        [mutArr addObject:[NSArray arrayWithObjects:@"支付方式",@"", nil]];
        NSString *payStr;
        NSString *payMoney = nil;
        if (self.selectCouponinfo) {
            payStr = @"优惠码";
            payMoney = [NSString stringWithFormat:@"-¥%.0f",self.selectCouponinfo.price.integerValue/100.0f];
            [mutArr addObject:[NSArray arrayWithObjects:payStr,payMoney, nil]];
        }
        if (self.selectAccount) {
            payStr = @"个人账户支付";
            payMoney = [NSString stringWithFormat:@"-¥%.0f",self.accountAmountShow/100.0f];
            [mutArr addObject:[NSArray arrayWithObjects:payStr,payMoney, nil]];
        }
        if (self.tcCardFee) {
            payStr = @"权益账户";
            payMoney = [NSString stringWithFormat:@"-¥%.0f",self.tcCardFee.integerValue/100.0f];
            [mutArr addObject:[NSArray arrayWithObjects:payStr,payMoney, nil]];
        }
//    }

//    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",self.totalFeeLabel.text];
//    NSString *feeStr =[str stringByReplacingOccurrencesOfString:@"¥" withString:@""];//微信支付或现金支付部分
    [mutArr addObject:[NSArray arrayWithObjects:@"应支付",self.totalFeeLabel.text, nil]];
    
    return mutArr;
}

- (void)configOrderDicService:(NSDictionary *)dic
{
    NSMutableDictionary *mutDic;
    if ([[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"]&&(![[[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"] isEqual:[NSNull null]])) {
        mutDic = [NSMutableDictionary dictionaryWithDictionary:[[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"]];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in mutDic) {
        NSDictionary *dic = [mutDic objectForKey:key];
        NSString *string = [NSString stringWithFormat:@"%@&%@",[dic objectForKey:@"title"],[dic objectForKey:@"strike_price"]];
        [arr addObject:string];
    }
    self.serviceArr = [NSMutableArray arrayWithArray:arr];
}

- (NSString *)orderFeeStr
{
    NSString *orderStatus = [self.orderDic objectForKey:@"order_status"];
    if ([orderStatus isEqualToString:@"park_appoint"]||
        [orderStatus isEqualToString:@"approve"]) {
        return @"预计费用";//预约泊车成功
    }else if([orderStatus isEqualToString:@"park"]){
        return @"预计费用";//泊车成功
    }else if ([orderStatus isEqualToString:@"pick_appoint"]){
        return @"预计费用";//待取车
    }else if ([orderStatus isEqualToString:@"finish"]){
        return @"订单总费用";//服务结束
    }else if ([orderStatus isEqualToString:@"payment_sure"]){
        return @"订单总费用";//已支付待确认
    }else if ([orderStatus isEqualToString:@"pick_sure"]){
        return @"订单总费用";//已确认取车
    }
    return nil;
}

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
