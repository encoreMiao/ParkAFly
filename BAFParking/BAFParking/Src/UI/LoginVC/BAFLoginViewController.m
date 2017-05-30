//
//  BAFLoginViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFLoginViewController.h"
#import <IQKeyboardManager.h>

@interface BAFLoginViewController ()

@end

@implementation BAFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;//点击背景收回键盘
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavigationTitle:@"登录"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backMethod:(id)sender
{
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (void)rightButtonMehotd:(id)sender{
    
}

@end
