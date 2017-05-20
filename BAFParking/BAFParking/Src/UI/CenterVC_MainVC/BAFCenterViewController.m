//
//  BAFCenterViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFCenterViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "DYMRollingBannerVC.h"
#import "BAFCenterOrderView.h"
#import "BAFLoginViewController.h"

@interface BAFCenterViewController ()<BAFCenterOrderViewDelegate>
@property (nonatomic, weak) IBOutlet UIButton *showPersonalCenterButton;
@property (nonatomic, weak) IBOutlet UIButton *showOrderListButton;
@property (nonatomic, weak) IBOutlet UIView *headerScrollerView;

@property (nonatomic, weak) IBOutlet BAFCenterOrderView *orderView;

@end


@implementation BAFCenterViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showLeftVC:(id)sender {
    [self leftDrawerButtonPress:sender];
}

#pragma mark - SetupView
- (void)setupView
{
    [self setupScrollView];
    [self.headerScrollerView bringSubviewToFront:self.showPersonalCenterButton];
    [self.headerScrollerView bringSubviewToFront:self.showOrderListButton];
    
    self.orderView.delegate = self;
    [self.orderView setType:kBAFCenterOrderViewTypeGoing];
}

- (void)setupScrollView
{
    DYMRollingBannerVC      *_rollingBannerVC;
    _rollingBannerVC = [DYMRollingBannerVC new];
    [_rollingBannerVC.view setFrame:CGRectMake(0, 0, screenWidth, CGRectGetHeight(self.headerScrollerView.frame))];
    _rollingBannerVC.rollingImages = @[[UIImage imageNamed:@"home_banner3"]
                                       ,[UIImage imageNamed:@"home_banner4"]
                                       ];
    
    // Start auto rolling (optional, default does not auto roll)
    _rollingBannerVC.rollingInterval = 3;
    [_rollingBannerVC startRolling];
    // Add a handler when a tap event occours (optional, default do noting)
    [_rollingBannerVC addBannerTapHandler:^(NSInteger whichIndex) {
        NSLog(@"banner tapped, index = %@", @(whichIndex));
    }];
    
    
    [self addChildViewController:_rollingBannerVC];
    [self.headerScrollerView addSubview:_rollingBannerVC.view];
    [_rollingBannerVC didMoveToParentViewController:self];
}

#pragma mark - Button Handlers
- (void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)showPersonalCenter:(id)sender
{
    //nav显示个人中心
    DLog(@"显示个人中心");
}

- (IBAction)showOrderList:(id)sender
{
    //nav显示订单列表？还是价格说明？
    DLog(@"nav显示订单列表？还是价格说明？");
}

- (IBAction)showOrderListNotFromNav:(id)sender
{
    //显示订单列表
    DLog(@"显示订单列表");
}

- (IBAction)orderParkCar:(id)sender
{
    //预约停车
    DLog(@"预约停车");
    BAFLoginViewController  *loginVC = [[BAFLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)parkingIntroduction:(id)sender
{
    //车场介绍
    DLog(@"车场介绍");
}

#pragma mark - BAFCenterOrderViewDelegate
- (void)showOrderDetail:(id)sender
{
    //查看正在进行的订单详细信息
    DLog(@"查看正在进行的订单详细信息");
}
@end
