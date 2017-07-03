//
//  CouponViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CouponViewController.h"
#import "BAFCenterViewController.h"

@interface CouponViewController ()
@property (weak, nonatomic) IBOutlet UIView *SelectView;
@property (weak, nonatomic) IBOutlet UIButton *useBtn;//可用
@property (weak, nonatomic) IBOutlet UIButton *notUseBtn;;//不可用

@property (weak, nonatomic) IBOutlet UIView *CheckCouponView;
@property (weak, nonatomic) IBOutlet UIButton *unuseBtn;//未使用
@property (weak, nonatomic) IBOutlet UIButton *overdueBtn;//已过期
@property (weak, nonatomic) IBOutlet UIButton *usedBtn;//已使用

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
    
    switch (self.type) {
        case kCouponViewControllerTypeCommon://查看优惠券
            self.SelectView.hidden = YES;
            self.CheckCouponView.hidden = NO;
            [self setNavigationTitle:@"优惠券"];
            break;
        case kCouponViewControllerTypeUse://使用优惠券
            self.SelectView.hidden = NO;
            self.CheckCouponView.hidden = YES;
            [self setNavigationTitle:@"使用优惠券"];
            break;
        default:
            break;
    }
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

@end
