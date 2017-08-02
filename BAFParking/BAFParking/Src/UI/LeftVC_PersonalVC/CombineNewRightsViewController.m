//
//  CombineNewRightsViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CombineNewRightsViewController.h"
#import "RightsViewController.h"
#import "UIImage+Color.h"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberAccountBind,
};

@interface CombineNewRightsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *cardTF;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (nonatomic, strong)   UIButton *confirmButton;
@end

@implementation CombineNewRightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.confirmButton];

    self.codeView.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.codeView.layer.borderWidth = 0.5f;
    
    self.cardView.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.cardView.layer.borderWidth = 0.5f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithHex:0xffffff];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"绑定新卡"];
    
    self.confirmButton.frame = CGRectMake(20, CGRectGetMaxY(self.codeView.frame)+30, screenWidth-40, 40);

}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)combineMethod
{
    if (self.cardTF.text.length <=0) {
        [self showTipsInView:self.view message:@"请输入卡号" offset:self.view.center.x+100];
    }else if (self.codeTF.text.length<=0){
        [self showTipsInView:self.view message:@"请输入密码" offset:self.view.center.x+100];
    }else{
        [self bindAccountRequestWithCardNo:self.cardTF.text password:self.codeTF.text];
    }
    
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_confirmButton setTitle:@"绑定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage createImageWithColor:HexRGB(kBAFCommonColor)] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_confirmButton setBackgroundColor:[UIColor clearColor]];
        [_confirmButton addTarget:self action:@selector(combineMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


#pragma mark - REQUEST
- (void)bindAccountRequestWithCardNo:(NSString *)cardno password:(NSString *)password
{
    id <HRLPersonalCenterInterface> equityAccountbind = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [equityAccountbind equityAccountBindingRequestWithNumberIndex:kRequestNumberAccountBind delegte:self card_no:cardno password:password bind_phone:userInfo.ctel];
}

-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberAccountBind) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self showTipsInView:self.view message:@"输入的卡号无效" offset:self.view.center.x+100];
            [self performSelector:@selector(backMethod:) withObject:nil afterDelay:3.0f];
        }else{
             [self showTipsInView:self.view message:@"绑定成功" offset:self.view.center.x+100];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
