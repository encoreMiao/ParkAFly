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
    [self setNavigationTitle:@"绑定新卡"];
    
    self.confirmButton.frame = CGRectMake(20, CGRectGetMaxY(self.codeView.frame)+30, screenWidth-40, 40);

}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[RightsViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (void)combineMethod
{
    
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_confirmButton setTitle:@"绑定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        //        [_confirmButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xd7d7d7]] forState:UIControlStateDisabled];
        [_confirmButton setBackgroundImage:[UIImage createImageWithColor:HexRGB(kBAFCommonColor)] forState:UIControlStateNormal];
        //        [_confirmButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xcc4d3d]] forState:UIControlStateHighlighted];
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_confirmButton setBackgroundColor:[UIColor clearColor]];
        [_confirmButton addTarget:self action:@selector(combineMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
