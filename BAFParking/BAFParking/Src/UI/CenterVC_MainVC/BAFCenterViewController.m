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
#import "BAFOrderViewController.h"
#import "BAFWebViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "ParkListViewController.h"

@interface BAFCenterViewController ()<BAFCenterOrderViewDelegate,BMKLocationServiceDelegate>{
    BMKLocationService *_locService;
}
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
    [self locationService];
}

-(void)locationService
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _locService.delegate = self;
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
//    BAFLoginViewController  *loginVC = [[BAFLoginViewController alloc]init];
//    [self.navigationController pushViewController:loginVC animated:YES];
    
    BAFWebViewController  *webview = [[BAFWebViewController alloc]init];
    [self.navigationController pushViewController:webview animated:YES];
    [webview loadTargetURL:[NSURL URLWithString:@"http://parknfly.cn/Wap/Index/app_price"] title:@"价格说明"];
    
}

- (IBAction)showOrderListNotFromNav:(id)sender
{
    DLog(@"显示订单列表");
}

- (IBAction)orderParkCar:(id)sender
{
    DLog(@"预约停车");
    BAFOrderViewController  *orderVC = [[BAFOrderViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)parkingIntroduction:(id)sender
{
    DLog(@"车场介绍");
    //跳转到停车场选择
    ParkListViewController  *parklistVC = [[ParkListViewController alloc]init];
    parklistVC.type = kParkListViewControllerTypeShow;
    [self.navigationController pushViewController:parklistVC animated:YES];
}

#pragma mark - BAFCenterOrderViewDelegate
- (void)showOrderDetail:(id)sender
{
    DLog(@"查看正在进行的订单详细信息");
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: userLocation.location completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            if (placemark != nil) {
                NSString *city = placemark.locality;
                NSLog(@"当前城市名称------%@",city);
                //找到了当前位置城市后就关闭服务
                [_locService stopUserLocationService];
            }
        }
        
    }];
}
@end
