//
//  CouponViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CouponViewController.h"
#import "BAFCenterViewController.h"
#import "HRLPersonalCenterInterface.h"
#import "HRLogicManager.h"
#import "CouponTableViewCell.h"
#import "BAFUserModelManger.h"
#import "BAFCouponInfo.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCouponListRequest,
    kRequestNumberIndexPayCouponRequest,
    kRequestNumberIndexBindCouponRequest,
};

#define CouponTableViewCellIdentifier   @"CouponTableViewCellIdentifier"

@interface CouponViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *SelectView;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;//可用
@property (weak, nonatomic) IBOutlet UIButton *notUseBtn;;//不可用

@property (weak, nonatomic) IBOutlet UIView *CheckCouponView;
@property (weak, nonatomic) IBOutlet UIButton *unuseBtn;//未使用
@property (weak, nonatomic) IBOutlet UIButton *overdueBtn;//已过期
@property (weak, nonatomic) IBOutlet UIButton *usedBtn;//已使用


@property (weak, nonatomic) IBOutlet UITableView *myTableview;
@property (weak, nonatomic) IBOutlet UITextField *couponExchangeTF;

@property (strong, nonatomic) NSMutableArray *couponArr;
@property (strong, nonatomic) UIView *buttonView;

@property (assign, nonatomic) CouponTableViewCellType cellType;
@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.buttonView];
    self.couponArr = [NSMutableArray array];
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
    self.myTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    switch (self.type) {
        case kCouponViewControllerTypeCommon://查看优惠券
            self.SelectView.hidden = YES;
            self.CheckCouponView.hidden = NO;
            [self setNavigationTitle:@"优惠券"];
            self.unuseBtn.selected = YES;
            self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.unuseBtn.frame), screenWidth/3, 2);
            self.cellType = kCouponTableViewCellTypeCommonCell1;
            [self couponRequestWithStatus:@"1"];//    1.未使用;2.已使用;3. 已过期
            break;
        case kCouponViewControllerTypeUse://使用优惠券
            self.SelectView.hidden = NO;
            self.CheckCouponView.hidden = YES;
            [self setNavigationTitle:@"使用优惠券"];
            self.useBtn.selected = YES;
            self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.useBtn.frame), screenWidth/2, 2);
            self.cellType = kCouponViewControllerTypeUseCell1;
            [self paycouponRequest];
            break;
        default:
            break;
    }
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)exchangeCouponBtn:(id)sender {
    if (self.couponExchangeTF.text.length <=0) {
        [self showTipsInView:self.view message:@"请输入电子码" offset:self.view.center.x+100];
        return;
    }
    [self.couponExchangeTF resignFirstResponder];
    [self bindCouponRequestWithCouponCode:self.couponExchangeTF.text];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.couponArr.count;
//    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:CouponTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CouponTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
    }
    cell.type = self.cellType;
//    switch (self.type) {
//        case kCouponViewControllerTypeCommon:
//            //查看
//            
//            break;
//        case kCouponViewControllerTypeUse:
//            //使用
//            break;
//        default:
//            break;
//    }
    
    
//    cell.titleLabel.text = [self.payListArr objectAtIndex:indexPath.row];
//    if (indexPath.row == 0) {
//        if ([self.dicDataSource objectForKey:PayOrderTcCard]) {
//            cell.moneyLabel.text = [self.dicDataSource objectForKey:PayOrderTcCard];
//            [cell setShow:YES];
//        }
//    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"优惠券选择");
//    if (indexPath.row == 0) {
//        if (self.tcCard.count == 0) {
//            [self showTipsInView:self.view message:@"当前未绑定权益卡" offset:self.view.center.x+100];
//            return;
//        }
//        [self popTcCard];
//    }
//    
//    if (indexPath.row == 1) {
//        CouponViewController  *vc = [[CouponViewController alloc]init];
//        vc.type = kCouponViewControllerTypeUse;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - action
- (IBAction)segementSelect:(id)sender {
    UIButton *button = (UIButton *)sender;
    switch (self.type) {
        case kCouponViewControllerTypeCommon://查看优惠券
        {
            if ([button.titleLabel.text isEqualToString:@"未使用"]) {
                [self couponRequestWithStatus:@"1"];
                self.cellType = kCouponTableViewCellTypeCommonCell1;
                self.unuseBtn.selected = YES;
                self.overdueBtn.selected = NO;
                self.usedBtn.selected = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.unuseBtn.frame), screenWidth/3, 2);
                } completion:^(BOOL finished) {
                    if (finished) {
                    }
                }];
                
            }else if ([button.titleLabel.text isEqualToString:@"已使用"]) {
                [self couponRequestWithStatus:@"2"];
                self.cellType = kCouponTableViewCellTypeCommonCell2;
                self.unuseBtn.selected = NO;
                self.overdueBtn.selected = NO;
                self.usedBtn.selected = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    self.buttonView.frame = CGRectMake(screenWidth/3,CGRectGetMaxY(self.unuseBtn.frame), screenWidth/3, 2);
                } completion:^(BOOL finished) {
                    if (finished) {
                    }
                }];
                
            }else{
                [self couponRequestWithStatus:@"3"];
                self.cellType = kCouponTableViewCellTypeCommonCell3;
                self.unuseBtn.selected = NO;
                self.overdueBtn.selected = YES;
                self.usedBtn.selected = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.buttonView.frame = CGRectMake((screenWidth*2)/3,CGRectGetMaxY(self.unuseBtn.frame), screenWidth/3, 2);
                } completion:^(BOOL finished) {
                }];
            }
        }
            break;
        case kCouponViewControllerTypeUse://使用优惠券
        {
            if ([button.titleLabel.text containsString:@"不可用"]) {
                self.cellType = kCouponViewControllerTypeUseCell2;
                [self paycouponRequest];
                self.notUseBtn.selected = YES;
                self.useBtn.selected = NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.buttonView.frame = CGRectMake(screenWidth/2,CGRectGetMaxY(self.unuseBtn.frame), screenWidth/2, 2);
                } completion:^(BOOL finished) {
                    if (finished) {
                    }
                }];
                  
            }else{
                self.cellType = kCouponViewControllerTypeUseCell1;
                [self paycouponRequest];
                self.notUseBtn.selected = NO;
                self.useBtn.selected = YES;
                [UIView animateWithDuration:0.5 animations:^{
                    self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.unuseBtn.frame), screenWidth/2, 2);
                } completion:^(BOOL finished) {
                }];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - setter&getter
- (UIView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
        [_buttonView setBackgroundColor:[UIColor colorWithHex:0x3492e9]];
        _buttonView.userInteractionEnabled = YES;
    }
    return _buttonView;
}

#pragma mark - REQUEST
- (void)couponRequestWithStatus:(NSString *)status
{
//    1.未使用;2.已使用;3. 已过期
    id <HRLPersonalCenterInterface> personReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personReq couponListRequestWithNumberIndex:kRequestNumberIndexCouponListRequest delegte:self client_id:userInfo.clientid status:status];
}
- (void)paycouponRequest
{
    //  coupon_list    disable_coupons_list
    id <HRLPersonalCenterInterface> personReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personReq getMyCouponRequestWithNumberIndex:kRequestNumberIndexPayCouponRequest delegte:self client_id:userInfo.clientid order_id:self.orderId];
}

- (void)bindCouponRequestWithCouponCode:(NSString *)coponCode
{
    id <HRLPersonalCenterInterface> personReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personReq bindCouponRequestWithNumberIndex:kRequestNumberIndexBindCouponRequest delegte:self client_id:userInfo.clientid coupon_code:coponCode];
}

-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexCouponListRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self.couponArr removeAllObjects];
            self.couponArr = [NSMutableArray arrayWithArray:[BAFCouponInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]]];
        }else{
            [self.couponArr removeAllObjects];
            if ([[obj objectForKey:@"code"] integerValue] == 3) {
                 [self showTipsInView:self.view message:@"当前没有优惠券" offset:self.view.center.x+100];
            }
        }
        [self.myTableview  reloadData];
    }
    
    if (aRequestID == kRequestNumberIndexPayCouponRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self.couponArr removeAllObjects];
            if (self.cellType == kCouponViewControllerTypeUseCell1) {
                self.couponArr = [NSMutableArray arrayWithArray:[[obj objectForKey:@"data"] objectForKey:@"coupon_list"]];
            }else{
                self.couponArr = [NSMutableArray arrayWithArray:[[obj objectForKey:@"data"] objectForKey:@"disable_coupons_list"]];
            }
        }else{
            [self.couponArr removeAllObjects];
            [self showTipsInView:self.view message:@"当前没有优惠券" offset:self.view.center.x+100];
        }
        [self.myTableview  reloadData];
    }
    
    if (aRequestID == kRequestNumberIndexBindCouponRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.couponExchangeTF.text = @"";
            switch (self.type) {
                case kCouponViewControllerTypeCommon://查看优惠券
                    [self segementSelect:self.unuseBtn];
                    break;
                case kCouponViewControllerTypeUse://使用优惠券
                    [self segementSelect:self.useBtn];
                    break;
                default:
                    break;
            }
        }else{
            [self showTipsInView:self.view message:[obj objectForKey:@"message"] offset:self.view.center.x+100];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}
@end
