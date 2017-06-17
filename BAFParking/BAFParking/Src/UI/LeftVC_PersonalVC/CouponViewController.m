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
    [self setNavigationTitle:@"优惠券"];
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
