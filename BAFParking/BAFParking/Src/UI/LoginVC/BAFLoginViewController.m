//
//  BAFLoginViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFLoginViewController.h"
#import <IQKeyboardManager.h>
#import "IUCallBackInterface.h"
#import "HRLogicManager.h"
#import "HRLLoginInterface.h"
#import "NetStatusModel.h"
#import "NSString+Null.h"
typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexMsgCode,
    kRequestNumberIndexLogin,
};

@interface BAFLoginViewController ()<IUICallbackInterface,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@end

@implementation BAFLoginViewController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;//点击背景收回键盘
    [self.phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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

#pragma mark - Request
- (void)loginRequestWithPhoneNumber:(NSString *)phoneNumber codeNumber:(NSString *)codeNumber
{
    id <HRLLoginInterface> loginReq = [[HRLogicManager sharedInstance] getLoginReqest];
    [loginReq loginRequestWithNumberIndex:kRequestNumberIndexLogin delegte:self phone:@"18511833913" msgCode:@"436845"];
}

- (void)getCodeRequestWithPhoneNumber:(NSString *)phoneNumber
{
    id <HRLLoginInterface> loginReq = [[HRLogicManager sharedInstance] getLoginReqest];
    [loginReq msgCodeRequestWithNumberIndex:kRequestNumberIndexMsgCode delegte:self phone:@"18511833913"];
}

- (IBAction)getCode:(id)sender {
    if ([[NetStatusModel shareInstance] checkNetwork]) {
        [self showTipsInView:self.view message:@"当前无网络，请稍后再试" offset:self.view.center.x+100];
        return;
    }
    [self verifyCode];
}

- (void)verifyCode
{
    NSUInteger phoneLength = [self.phoneTF.text length];
//    NSUInteger passCodeLength = [self.codeTF.text length];
    if (phoneLength<11) {
        NSString *info = @"请输入正确的手机号码";
        [self showTipsInView:self.view message:info offset:self.view.center.x+100];
    }
//    else if (passCodeLength==0) {
//        NSString *info = @"请输入密码";
//        [self showTipsInView:self.view message:info offset:self.view.center.x+100];
//    }
    else
    {
        [self loginRequestWithPhoneNumber:self.phoneTF.text codeNumber:self.codeTF.text];
    }
}

#pragma mark - UIControlEventEditingChangedMethods
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneTF) {
        if (textField.text.length > 11) {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    
}



//- (void)onCountDownTimeAction:(id)sender
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self showCountDownViewWithSeconds:sender];
//    });
//}
//
//- (void)showCountDownViewWithSeconds:(id)sender
//{
//    if (countDownSeconds<=0) {
//        [self resetVerifyBtn];
//    }else{
//        [_verifyBtn setTitle:[NSString stringWithFormat:@"%d %@",(int)countDownSeconds,NSLocalizedString(@"common_second", nil)] forState:UIControlStateDisabled];
//        countDownSeconds--;
//    }
//}


@end
