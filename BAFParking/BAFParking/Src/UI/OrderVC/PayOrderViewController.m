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

#define PayOrderTableViewCellIdentifier  @"PayOrderTableViewCellIdentifier"
#define PayOrderTcCard  @"PayOrderTcCard"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexRightsListRequest,
    kRequestNumberIndexCheckCardRequest,//计算腾讯权益卡费用
    kRequestNumberIndexOrderFeeRequest,
    kRequestNumberIndexOrderDetail,
};

@interface PayOrderViewController ()<UITableViewDelegate, UITableViewDataSource,PopViewControllerDelegate,PayOrderTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (strong, nonatomic) NSArray *payListArr;
@property (strong, nonatomic) NSMutableArray *tcCard;
@property (strong, nonatomic) NSMutableDictionary *dicDataSource;

@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderFeeLabel;

@property (strong, nonatomic) NSDictionary *feeDic;
@property (strong, nonatomic) IBOutlet UILabel *totalFeeLabel;

@property (strong, nonatomic) BAFCouponInfo *selectCouponinfo;
@property (strong, nonatomic) NSString *tcCardFee;
@property (strong, nonatomic) NSMutableDictionary *tcRequestDic;

@property (assign, nonatomic) BOOL selectAccount;//选择余额

@property (weak, nonatomic) IBOutlet  UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet  UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet  UIButton *confirmPayBtn;
@property (weak, nonatomic) IBOutlet  UIButton *moneyPayBtn;
@property (strong, nonatomic) NSMutableArray *serviceArr;
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
    
    [self configOrderDic:self.orderDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self orderDetailRequest];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"订单支付"];
    
    [self orderFeeRequest];
    
    self.confirmPayBtn.hidden = YES;
    self.weixinBtn.hidden = NO;
    self.moneyPayBtn.hidden = NO;
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
    self.parkTimeLabel.text = [dic objectForKey:@"plan_park_time"];
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
            NSString *moneyStr = [NSString stringWithFormat:@"-¥%.0f",userinfo.account.integerValue/100.0f];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[moneyStr rangeOfString:[NSString stringWithFormat:@"-¥%.0f",userinfo.account.integerValue/100.0f]]];
            cell.moneyLabel.attributedText = mutStr;
            [cell setShow: YES];
        }else{
            NSString *moneyStr = [NSString stringWithFormat:@"¥%.0f",userinfo.account.integerValue/100.0f];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:moneyStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[moneyStr rangeOfString:[NSString stringWithFormat:@"¥%.0f",userinfo.account.integerValue/100.0f]]];
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
            if ([self.dicDataSource objectForKey:PayOrderTcCard]) {
                [self.dicDataSource removeObjectForKey:PayOrderTcCard];
                [self.mytableview reloadData];
            }
            
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
            [self.mytableview  reloadData];
        }
    }else if ([cell.titleLabel.text isEqualToString:@"个人账户"]) {
        cell.show = !cell.show;
        if (cell.show == YES) {
            self.selectAccount = YES;
        }else{
            self.selectAccount = NO;
        }
        [self.mytableview  reloadData];
    }

}

- (void)jumpToCouponVC
{
    CouponViewController  *vc = [[CouponViewController alloc]init];
    vc.type = kCouponViewControllerTypeUse;
    vc.handler = ^(BAFCouponInfo *couponinfo){
        self.selectCouponinfo = couponinfo;
        [self.mytableview  reloadData];
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
//            [self.mytableview  reloadData];
            
            NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:self.tcRequestDic];
            [muDic setObject:tcCardInfo.card_no forKey:@"card_no"];
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
            [self.mytableview reloadData];
        }
            break;
        default:
            break;
    }
}

- (void)configTotalFee
{
    
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

- (void)orderPaymentSet
{
//    order/order_payment_set
    NSInteger totalFee = [[[self.orderDic objectForKey:@"order_price"]objectForKey:@"after_discount_total_price"] integerValue];
    NSString *totalFeeText = [NSString stringWithFormat:@"¥%ld",totalFee/100];
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
            [self.mytableview  reloadData];
        }else{
           
        }
    }
    
    if (aRequestID == kRequestNumberIndexOrderFeeRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.feeDic = [obj objectForKey:@"data"];
            NSUInteger basicTotalFee = [[[[obj objectForKey:@"data"]objectForKey:@"order_price"]objectForKey:@"before_discount_total_price"] integerValue];
            NSString *feeText = [NSString stringWithFormat:@"预计费用：¥%ld",basicTotalFee/100];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:feeText];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xfb694b],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:[feeText rangeOfString:[NSString stringWithFormat:@"¥%ld",basicTotalFee/100]]];
            self.orderFeeLabel.attributedText = mutStr;
            
            NSInteger totalFee = [[[[obj objectForKey:@"data"]objectForKey:@"order_price"]objectForKey:@"after_discount_total_price"] integerValue];
            NSString *totalFeeText = [NSString stringWithFormat:@"¥%ld",totalFee/100];
            self.totalFeeLabel.text = totalFeeText;
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
            [self.tcRequestDic setObject:[basicDic objectForKey:@"market_price"] forKey:@"day_price"];
            [self.tcRequestDic setObject:[[self.orderDic objectForKey:@"order_fee_detail"] objectForKey:@"park_day"] forKey:@"park_day"];
            
            NSInteger totalFee = 0;
            NSInteger firstdayfee = [[basicDic objectForKey:@"first_day_price"] integerValue];
            NSInteger dayfee = [[basicDic objectForKey:@"market_price"] integerValue];
            NSInteger days = -1;
            if ([orderFeeDetail objectForKey:@"park_day"]) {
                days = [[orderFeeDetail objectForKey:@"park_day"] integerValue];
            }
            if (days>=0) {
                totalFee = firstdayfee + dayfee*days;
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
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
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
    NSInteger dayfee = [[basicDic objectForKey:@"market_price"] integerValue];
    NSInteger days = -1;
    if ([orderFeeDetail objectForKey:@"park_day"]) {
        days = [[orderFeeDetail objectForKey:@"park_day"] integerValue];
    }
    if (days>=0) {
        totalFee = firstdayfee + dayfee*days;
    }else{
        totalFee = firstdayfee;
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
    
    if (days>0) {
        [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元+%ld元*%ld天)",firstdayfee/100,dayfee/100,days],[NSString stringWithFormat:@"¥%ld",(firstdayfee + dayfee*days)/100], nil]];
    }else{
        [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元)",firstdayfee/100],[NSString stringWithFormat:@"¥%ld",firstdayfee/100], nil]];
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
//        //支付方式
//        [mutArr addObject:[NSArray arrayWithObjects:@"支付方式",@"", nil]];
//        NSArray *payment_detailArr = [orderFeeDetail objectForKey:@"payment_detail"];
//        NSArray *discount_price = [orderFeeDetail objectForKey:@"discount_price"];
//        if (![discount_price isEqual:[NSNull null]]&&discount_price!=nil) {
//            if (discount_price.count>0) {
//                for (NSDictionary *dic in discount_price) {
//                    [mutArr addObject:[NSArray arrayWithObjects:@"vip抵扣",[NSString stringWithFormat:@"-¥%ld",[[dic objectForKey:@"discount_total"] integerValue]/100], nil]];
//                }
//            }
//        }
//        
//        if (![payment_detailArr isEqual:[NSNull null]]&&payment_detailArr!=nil) {
//            if (payment_detailArr.count>0) {
//                for (NSDictionary *dic in payment_detailArr) {
//                    NSString *payStr = @"";
//                    NSString *pay_method = [dic objectForKey:@"pay_method"];
//                    if ([pay_method isEqualToString:@"cash"]) {
//                        payStr = @"现金支付";
//                    }
//                    if ([pay_method isEqualToString:@"wechat"]) {
//                        payStr = @"微信支付";
//                    }
//                    if ([pay_method isEqualToString:@"alipay"]) {
//                        payStr = @"支付宝支付";
//                    }
//                    if ([pay_method isEqualToString:@"personal_account"]) {
//                        payStr = @"个人账户支付";
//                    }
//                    if ([pay_method isEqualToString:@"company_account"]) {
//                        payStr = @"集团账户支付";
//                    }
//                    if ([pay_method isEqualToString:@"coupon_code"]) {
//                        payStr = @"优惠码";
//                    }
//                    if ([pay_method isEqualToString:@"activity_code"]) {
//                        payStr = @"权益账户";
//                    }
//                    [mutArr addObject:[NSArray arrayWithObjects:payStr,[NSString stringWithFormat:@"-¥%ld",[[dic objectForKey:@"pay_amount"] integerValue]/100], nil]];
//                }
//            }
//        }
//    }
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
        if ([key isEqualToString:@"202"]) {
            //            [arr addObject:@"代泊服务"];
        }
        if ([key isEqualToString:@"206"]) {
            //            [arr addObject:@"自行往返航站楼"];
        }
        if ([key isEqualToString:@"205"]) {
            //            [arr addObject:@"洗车服务"];
        }
        if ([key isEqualToString:@"204"]) {
            //            [arr addObject:@"代加油"];
        }
    }
    self.serviceArr = [NSMutableArray arrayWithArray:arr];
}

- (NSString *)orderFeeStr
{
    NSString *orderStatus = [self.orderDic objectForKey:@"order_status"];
    if ([orderStatus isEqualToString:@"park_appoint"]||
        [orderStatus isEqualToString:@"approve"]) {
        //预约泊车成功
        return @"预计费用";
    }else if([orderStatus isEqualToString:@"park"]){
        //泊车成功
        return @"预计费用";
    }else if ([orderStatus isEqualToString:@"pick_appoint"]){
        //待取车
        return @"预计费用";
    }else if ([orderStatus isEqualToString:@"finish"]){
        //服务结束
        return @"订单总费用";
    }
    else if ([orderStatus isEqualToString:@"payment_sure"]){
        //已支付待确认
        return @"订单总费用";
    }
    else if ([orderStatus isEqualToString:@"pick_sure"]){
        //已确认取车
        return @"预计费用";
    }
    return nil;
}

@end
