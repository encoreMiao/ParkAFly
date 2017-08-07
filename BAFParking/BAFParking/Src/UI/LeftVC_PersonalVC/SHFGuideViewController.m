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
    
    
    self.mobile3ImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
    [self.mobile3ImageView addGestureRecognizer:gesture];
    
    buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonClose addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    buttonClose.frame = CGRectMake(screenWidth-80, screenHeight-80, 80, 80);
    [buttonClose setTitleColor:[UIColor colorWithHex:0x3492e9] forState:UIControlStateNormal];
    [buttonClose setTitle:@"跳过" forState:UIControlStateNormal];
    buttonClose.titleLabel.font = [UIFont systemFontOfSize:15.0f];
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
        _mobile1ImageView.image = [UIImage imageNamed:@"Guide_image1_1242"];
        _mobile2ImageView.image = [UIImage imageNamed:@"Guide_image2_1242"];
        _mobile3ImageView.image = [UIImage imageNamed:@"Guide_image3_1242"];
    }else if(iPhone4){
        _mobile1ImageView.image = [UIImage imageNamed:@"Guide_image1_640*960"];
        _mobile2ImageView.image = [UIImage imageNamed:@"Guide_image2_640*960"];
        _mobile3ImageView.image = [UIImage imageNamed:@"Guide_image3_640*960"];
    }
    else if(iPhone5){
        _mobile1ImageView.image = [UIImage imageNamed:@"Guide_image1_640"];//640*1136
        _mobile2ImageView.image = [UIImage imageNamed:@"Guide_image2_640"];
        _mobile3ImageView.image = [UIImage imageNamed:@"Guide_image3_640"];
    }
    else{
        _mobile1ImageView.image = [UIImage imageNamed:@"Guide_image1_750"];
        _mobile2ImageView.image = [UIImage imageNamed:@"Guide_image2_750"];
        _mobile3ImageView.image = [UIImage imageNamed:@"Guide_image3_750"];
        
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x > screenWidth * 1)
    {
        buttonClose.hidden = YES;
    }else{
        buttonClose.hidden = NO;
    }
}


#pragma mark - UserAction
- (void)btnClick:(id)sender {
    [self.view removeFromSuperview];
}

@end
