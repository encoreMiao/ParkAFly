//
//  SHFGuideViewController.m
//  FocusLive
//
//  Created by sunxh on 16/12/27.
//  Copyright © 2016年 sohu. All rights reserved.
//

#import "SHFGuideViewController.h"

@interface SHFGuideViewController () <UIScrollViewDelegate>
{
    UIButton *buttonClose;
}

@property (strong, nonatomic) UIImageView *mobile1ImageView;
@property (strong, nonatomic) UIImageView *mobile2ImageView;
@property (strong, nonatomic) UIImageView *mobile3ImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@end

@implementation SHFGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mScrollView.frame = CGRectMake(0, 0, screenWidth,screenHeight);
    [self.mScrollView setBackgroundColor:[UIColor clearColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.mobile1ImageView = [[UIImageView alloc]init];
    self.mobile2ImageView = [[UIImageView alloc]init];
    self.mobile3ImageView = [[UIImageView alloc]init];
    
    
    [self.mScrollView addSubview:self.mobile1ImageView];
    [self.mScrollView addSubview:self.mobile2ImageView];
    [self.mScrollView addSubview:self.mobile3ImageView];
    
    
    buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonClose addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonClose.frame = CGRectMake(0, 0, 80, 80);
    [buttonClose setImage:[UIImage imageNamed:@"pay_cancel"] forState:UIControlStateNormal];
    [self.view addSubview:buttonClose];
    
    _mobile1ImageView.userInteractionEnabled = YES;
    _mobile2ImageView.userInteractionEnabled = YES;
    _mobile3ImageView.userInteractionEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void) initUI
{
    _mobile1ImageView.frame = CGRectMake(screenWidth * 0, 0, screenWidth, screenHeight);
    _mobile2ImageView.frame = CGRectMake(screenWidth * 1, 0, screenWidth, screenHeight);
    _mobile3ImageView.frame = CGRectMake(screenWidth * 2, 0, screenWidth, screenHeight);
    
    [self.mScrollView setContentSize:CGSizeMake(screenWidth * 3, screenHeight)];

    if (iPhone6plus) {
        _mobile1ImageView.image = [UIImage imageNamed:@"Guide_image1_640"];
        _mobile2ImageView.image = [UIImage imageNamed:@"Guide_image2_640"];
        _mobile3ImageView.image = [UIImage imageNamed:@"Guide_image3_640"];
    }else if(iPhone6){
        _mobile1ImageView.image = [UIImage imageNamed:@"Guide_image1_750"];
        _mobile2ImageView.image = [UIImage imageNamed:@"Guide_image2_750"];
        _mobile3ImageView.image = [UIImage imageNamed:@"Guide_image3_750"];
    }else{
        _mobile1ImageView.image = [UIImage imageNamed:@"Guide_image1_1242"];
        _mobile2ImageView.image = [UIImage imageNamed:@"Guide_image2_1242"];
        _mobile3ImageView.image = [UIImage imageNamed:@"Guide_image3_1242"];
    }

}

#pragma mark - UserAction
- (void)btnClick:(id)sender {
    [self.view removeFromSuperview];
}

@end
