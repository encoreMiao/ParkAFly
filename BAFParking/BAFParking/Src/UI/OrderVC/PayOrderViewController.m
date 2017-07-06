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
    kRequestNumberIndexCheckCardRequest,
    kRequestNumberIndexOrderFeeRequest,
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

@end

@implementation PayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payListArr = @[@"权益账户",@"优惠券",@"个人账户"];
    self.tcCard = [NSMutableArray  array];
    self.dicDataSource = [NSMutableDictionary dictionary];
    self.feeDic = [NSDictionary dictionary];
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
    
    [self configOrderDic:self.orderDic];
    
    [self tcCardRequest];
    [self orderFeeRequest];
}

- (void)backMethod:(id)sender
{
//    for (UIViewController *tempVC in self.navigationController.viewControllers) {
//        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
//            [self.navigationController popToViewController:tempVC animated:YES];
//        }
//    }
    [self.navigationController popToRootViewControllerAnimated:YES];
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
            cell.moneyLabel.text = [self.dicDataSource objectForKey:PayOrderTcCard];
            [cell setShow:YES];
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
    }
    
    if (indexPath.row == 1) {
        CouponViewController  *vc = [[CouponViewController alloc]init];
        vc.type = kCouponViewControllerTypeUse;
        vc.orderId = [self.orderDic objectForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - PayOrderTableViewCellDelegate
- (void)selectBtnDelegate:(PayOrderTableViewCell *)cell
{
    NSLog(@"点击点击点击");
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
        return;
    }
    
//    if ([cell.titleLabel.text isEqualToString:@"优惠券"]) {
//        cell.show = !cell.show;
//    }
    
    if ([cell.titleLabel.text isEqualToString:@"个人账户"]) {
        cell.show = !cell.show;
    }

}

#pragma mark - PopViewControllerDelegate
- (void)popviewConfirmButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview
{
    switch (type) {
        case kPopViewControllerTypeTcCard:
        {
            
            BAFTcCardInfo *tcCardInfo = ((BAFTcCardInfo *)[self.tcCard objectAtIndex:popview.selectedIndex.row]);
            NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
            //去哪找？check_tc_card
//            [muDic setObject:<#(nonnull id)#> forKey:@"phone"];
//            [muDic setObject:<#(nonnull id)#> forKey:@"card_no"];
//            [muDic setObject:<#(nonnull id)#> forKey:@"client_id"];
//            [muDic setObject:<#(nonnull id)#> forKey:@"first_day_price"];
//            [muDic setObject:<#(nonnull id)#> forKey:@"day_price"];
//            [muDic setObject:<#(nonnull id)#> forKey:@"park_day"];
//            [muDic setObject:<#(nonnull id)#> forKey:@"park_fee"];
//            [self checktCarReqeustWithParam:muDic];
            [self.dicDataSource setObject:tcCardInfo.type_name forKey:PayOrderTcCard];
            [self.mytableview  reloadData];
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
//            [self.dicDataSource setObject:tcCardInfo.type_name forKey:PayOrderTcCard];
//            [self.mytableview  reloadData];
        }else{
           
        }
    }
    
    if (aRequestID == kRequestNumberIndexOrderFeeRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.feeDic = [obj objectForKey:@"data"];
            NSInteger basicTotalFee = [[[[obj objectForKey:@"data"]objectForKey:@"order_price"]objectForKey:@"basic_total_price"] integerValue];
            self.orderFeeLabel.text = [NSString stringWithFormat:@"预计费用：¥%ld元",basicTotalFee/100];
        }else{
            
        }
    }
    
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
