//
//  BAFBaseViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"
#import "UIImage+Color.h"

@interface BAFBaseViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation BAFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = HexRGB(kBAFBackgroundGrayColor);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HexRGB(kBAFBackgroundGrayColor)] forBarMetrics:(UIBarMetricsDefault)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark PublicMethods
- (void)setNavigationBackButtonWithText:(NSString *)text method:(SEL)method{
    [self.backButton setTitle:text forState:UIControlStateNormal];
    [_backButton addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backButton]];
}

- (void)setNavigationBackButtonWithImage:(UIImage *)image method:(SEL)method{
    [self.backButton setImage:image forState:UIControlStateNormal];
    [self.backButton addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backButton]];
}

- (void)setNavigationRightButtonWithText:(NSString *)text method:(SEL)method{
    [self.rightButton setTitle:text forState:UIControlStateNormal];
    [_rightButton addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.rightButton]];
}
- (void)setNavigationRightButtonWithImage:(UIImage *)image method:(SEL)method{
    [self.rightButton setImage:image forState:UIControlStateNormal];
    [_rightButton addTarget:self action:method forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.rightButton]];
}
- (void)setNavigationTitle:(NSString *)title{
    self.navigationItem.titleView = self.titleLabel;
    [self.titleLabel setText:title];
}

#pragma mark Getter&Setter
- (UILabel *)titleLabel
{
    if (!_titleLabel){
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        self.titleLabel.font = [UIFont systemFontOfSize:kBAFFontSizeForTitle];
        self.titleLabel.textColor = HexRGB(kBAFColorForTitle);
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)backButton
{
    if (!_backButton){
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setFrame:CGRectMake(0, 0, 68, 44)];
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(12, -5, 12, 58);
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _backButton;
}

- (UIButton *)rightButton{
    if(!_rightButton){
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setFrame:CGRectMake(0, 0, 68, 44)];
        _rightButton.contentEdgeInsets = UIEdgeInsetsMake(12, -5, 12, 58);
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _rightButton;
}

@end
