//
//  FeedBackViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "FeedBackViewController.h"
#import "BAFCenterViewController.h"
#import "GCPlaceholderTextView.h"
#import "MBProgressHUD.h"
#import <IQKeyboardManager.h>
#import "UIImage+Color.h"
#import "HRLPersonalCenterInterface.h"
#import "HRLogicManager.h"
#import "BAFUserModelManger.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexFeedBack,
};

@interface FeedBackViewController ()<UITextViewDelegate, UIAlertViewDelegate>
{
    MBProgressHUD *HUD;
}
@property (nonatomic,strong)    GCPlaceholderTextView *fTextView;
@property (nonatomic, assign)   BOOL isSending;
@property (nonatomic, strong)   UIButton *confirmButton;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    UIView *feedBackImageView = nil;
    feedBackImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, screenWidth-40, 120)];
    feedBackImageView.backgroundColor = HexRGB(0xf5f5f5);
    [self.view addSubview:feedBackImageView];
    
    _fTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(25,15+15 ,screenWidth-50,120-15)];
    _fTextView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    _fTextView.delegate = self;
    _fTextView.font = [UIFont systemFontOfSize:14.0f];
    _fTextView.placeholder = @"请留下您的意见或建议，以便我们更好的为您提供服务！如意见被采纳，工作人员将联系您并赠送一张50元停车券";
    _fTextView.placeholderColor = [UIColor colorWithHex:0xb0b0b0];
    [self.view addSubview:_fTextView];
//    [_fTextView setMaxtextLength:1000];
    [self.view addSubview:self.confirmButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"意见反馈"];
    
    self.confirmButton.frame = CGRectMake(20, CGRectGetMaxY(self.fTextView.frame)+30, screenWidth-40, 40);
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)sendMethod
{
    NSString *temp = [self.fTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.fTextView.text = temp;
    if (self.fTextView.text.length == 0) {
        [self showTipsInView:self.view message:@"反馈内容不能为空!" offset:self.view.center.x+100];
    }else{
        if (self.isSending) {
            return;
        }
        self.isSending = YES;
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.removeFromSuperViewOnHide = YES;
        [HUD show:YES];

        [self feedbackRequest];
    }
}

#pragma mark - Request
- (void)feedbackRequest
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personCenterReq feedBackRequestWithNumberIndex:kRequestNumberIndexFeedBack delegte:self client_id:userInfo.clientid  content:self.fTextView.text];
}
#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    [HUD hide:YES];
    self.isSending = NO;

    if (aRequestID == kRequestNumberIndexFeedBack) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
            if ([[obj objectForKey:@"code"] integerValue]==200) {
                [self showTipsInView:self.view message:@"发表成功，谢谢您的评价" offset:self.view.center.x+100];
                [self performSelector:@selector(backMethod:) withObject:nil afterDelay:3.0f];
            }
            else{
                [self showTipsInView:self.view message:@"提交失败" offset:self.view.center.x+100];
            }
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_confirmButton setTitle:@"提交意见" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
//        [_confirmButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xd7d7d7]] forState:UIControlStateDisabled];
        [_confirmButton setBackgroundImage:[UIImage createImageWithColor:HexRGB(kBAFCommonColor)] forState:UIControlStateNormal];
//        [_confirmButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xcc4d3d]] forState:UIControlStateHighlighted];
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_confirmButton setBackgroundColor:[UIColor clearColor]];
        [_confirmButton addTarget:self action:@selector(sendMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
