//
//  SuccessViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/30.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "SuccessViewController.h"
#import "BAFCenterViewController.h"

@interface SuccessViewController ()
@property (nonatomic, strong) IBOutlet UIView *successView;
@property (nonatomic, strong) IBOutlet UIView *failureView;
@property (nonatomic, strong) IBOutlet UIView *payView;

@property (nonatomic, strong) IBOutlet UIView *buttonView;
@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)contactClicked:(id)sender {
    [self callPhoneNumber:@"4008138666"];
}
- (IBAction)checkOrder:(id)sender {
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationRightButtonWithText:@"完成" method:@selector(rightBtnClicked:)];
    
    
    switch (self.type) {
        case kSuccessViewControllerTypePay:
        {
            [self setNavigationTitle:@"现金支付"];
            self.successView.hidden = YES;
            self.failureView.hidden = YES;
            self.payView.hidden = NO;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.payView.frame), screenWidth, 100)];
        }
            break;
        case kSuccessViewControllerTypeFailure:
        {
            [self setNavigationTitle:@"预约失败"];
            self.successView.hidden = YES;
            self.failureView.hidden = NO;
            self.payView.hidden = YES;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.failureView.frame), screenWidth, 100)];
        }
            break;
        case kSuccessViewControllerTypeSuccess:
        {
            [self setNavigationTitle:@"预约成功"];
            self.successView.hidden = NO;
            self.failureView.hidden = YES;
            self.payView.hidden = YES;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.successView.frame), screenWidth, 100)];
        }
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

- (void)rightBtnClicked:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setType:(SuccessViewControllerType)type
{
    _type  =  type;
}


- (void)callPhoneNumber:(NSString *)phoneNumber {
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:callWebview];
}
- (void)callPhoneNumberWithOutAlert:(NSString *)phoneNumber{
    NSURL * telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [[UIApplication sharedApplication] openURL:telUrl];
}

@end
