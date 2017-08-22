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
#import "BAFUserModelManger.h"
#import "BAFWebViewController.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexMsgCode,
    kRequestNumberIndexLogin,
};

@interface BAFLoginViewController ()<IUICallbackInterface,UITextFieldDelegate>
{
    NSInteger   countDownSeconds;
    NSTimer     *timer;
}
@property (weak, nonatomic) IBOutlet UIButton       *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField    *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField    *codeTF;
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
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
    [loginReq loginRequestWithNumberIndex:kRequestNumberIndexLogin delegte:self phone:phoneNumber msgCode:codeNumber];
}

- (void)getCodeRequestWithPhoneNumber:(NSString *)phoneNumber
{
    id <HRLLoginInterface> loginReq = [[HRLogicManager sharedInstance] getLoginReqest];
    [loginReq msgCodeRequestWithNumberIndex:kRequestNumberIndexMsgCode delegte:self phone:phoneNumber];
}

- (IBAction)getCode:(id)sender {
    if ([[NetStatusModel shareInstance] checkNetwork]) {
        [self showTipsInView:self.view message:@"当前无网络，请稍后再试" offset:self.view.center.x+100];
        return;
    }
    [self verifyPhone];
}

- (IBAction)login:(id)sender {
    if ([[NetStatusModel shareInstance] checkNetwork]) {
        [self showTipsInView:self.view message:@"当前无网络，请稍后再试" offset:self.view.center.x+100];
        return;
    }
    [self verifyCode];
}

- (void)verifyPhone
{
    NSUInteger phoneLength = [self.phoneTF.text length];
    if (phoneLength<11) {
        NSString *info = @"请输入正确的手机号码";
        [self showTipsInView:self.view message:info offset:self.view.center.x+100];
    }
    else
    {
        [self getCodeRequestWithPhoneNumber:self.phoneTF.text];
    }
}

- (void)verifyCode
{
    NSUInteger phoneLength = [self.phoneTF.text length];
    NSUInteger codeLength = [self.codeTF.text length];
    if (phoneLength<11) {
        NSString *info = @"请输入正确的手机号码";
        [self showTipsInView:self.view message:info offset:self.view.center.x+100];
    }
    else if (codeLength == 0)
    {
        NSString *info = @"请输入验证码";
        [self showTipsInView:self.view message:info offset:self.view.center.x+100];
    }
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

#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if(aRequestID ==  kRequestNumberIndexMsgCode){
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]==200) {
            //获取验证码成功
            [self showTipsInView:self.view message:@"获取验证码成功" offset:self.view.center.x+100];
            
            self.codeBtn.enabled = NO;
            countDownSeconds = 120;
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(onCountDownTimeAction:) userInfo:nil repeats:YES];
            [timer fire];
            
        }
        else{
//            1.手机号格式错误;2.随机数格式错误;3.密钥错误;4.频繁请求
            NSUInteger failureCode =[[obj objectForKey:@"code"] integerValue];
            NSString *failureStr = nil;
            switch (failureCode) {
                case 1:
                    failureStr = @"手机号格式错误";
                    break;
                case 2:
                    failureStr = @"随机数格式错误";
                    break;
                case 3:
                    failureStr = @"密钥错误";
                    break;
                case 4:
                    failureStr = @"频繁请求";
                    break;
                default:
                    break;
            }
            if (failureStr) {
                [self showTipsInView:self.view message:failureStr offset:self.view.center.x+100];
            }
        }
    }
    
    if (aRequestID == kRequestNumberIndexLogin) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue] ==200) {
            //登录成功
            //个人信息：data->client
            [self resetVerifyBtn];
            [self showTipsInView:self.view message:@"登录成功" offset:self.view.center.x+100];
            
            BAFUserInfo *userInfo = [BAFUserInfo mj_objectWithKeyValues:[[obj objectForKey:@"data"] objectForKey:@"client"]];
            [[BAFUserModelManger sharedInstance]saveUserInfo:userInfo];
            //userInfo.caddr 和 userInfo.cityname
            
            NSString *token = [(NSDictionary *)obj objectForKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            NSUInteger failureCode =[[obj objectForKey:@"code"] integerValue];
            NSString *failureStr = nil;
            switch (failureCode) {
                case 1:
                    failureStr = @"手机号格式错误";
                    break;
                case 2:
                    failureStr = @"短信验证码错误";
                    break;
                case 3:
                    failureStr = @"短信验证码失效";
                    break;
                case 4:
                    failureStr = @"缺少手机设备号参数";
                    break;
                default:
                    break;
            }
            if (failureStr) {
                [self showTipsInView:self.view message:failureStr offset:self.view.center.x+100];
            }
        }
    }
    
    
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}


- (void)onCountDownTimeAction:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showCountDownViewWithSeconds:sender];
    });
}

- (void)showCountDownViewWithSeconds:(id)sender
{
    if (countDownSeconds<=0) {
        [self resetVerifyBtn];
    }else{
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%d s",(int)countDownSeconds] forState:UIControlStateDisabled];
        countDownSeconds--;
    }
}

- (void)resetVerifyBtn {
    [timer invalidate];
    timer = nil;
    countDownSeconds = 120;
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateDisabled];
    [self.codeBtn setEnabled:YES];
}

- (IBAction)boanfeiProtocal:(id)sender {
    DLog(@"泊安飞服务协议");
    BAFWebViewController  *webview = [[BAFWebViewController alloc]init];
    [self.navigationController pushViewController:webview animated:YES];
    [webview loadTargetURL:[NSURL URLWithString:@"http://www.parknfly.cn/Wap/Index/baf_agreement"] title:@"泊安飞服务协议"];
}

@end
