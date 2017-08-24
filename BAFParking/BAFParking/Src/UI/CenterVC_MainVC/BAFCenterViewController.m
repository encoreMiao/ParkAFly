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
#import "OrderListViewController.h"
#import "BAFUserModelManger.h"
#import "HRLOrderRequest.h"
#import "HRLOrderInterface.h"
#import "HRLogicManager.h"
#import "UIView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "OrderDetailViewController.h"

typedef NS_ENUM(NSInteger, BAFCenterViewControllerRequestType)
{
    kRequestNumberLatestOrder,
    kRequestNumberAppPhoto,
};

@interface BAFCenterViewController ()<BAFCenterOrderViewDelegate,BMKLocationServiceDelegate>{
    BMKLocationService *_locService;
    DYMRollingBannerVC      *_rollingBannerVC;
}
@property (nonatomic, weak) IBOutlet UIButton           *showPersonalCenterButton;
@property (nonatomic, weak) IBOutlet UIButton           *showOrderListButton;
@property (nonatomic, weak) IBOutlet UIView             *headerScrollerView;
@property (nonatomic, weak) IBOutlet BAFCenterOrderView *orderView;
@end


@implementation BAFCenterViewController
#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self locationService];
}

- (void)locationService
{
    _locService = [[BMKLocationService alloc]init];//初始化BMKLocationService
    [_locService startUserLocationService];//启动LocationService
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getADPhoto];
    _locService.delegate = self;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    self.orderView.type = kBAFCenterOrderViewTypeNone;
    if (userInfo.clientid) {
        [self latestOrderWithClientId:userInfo.clientid];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_rollingBannerVC stopRolling];
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
}

- (void)setupScrollView
{
    _rollingBannerVC = [DYMRollingBannerVC new];
    [_rollingBannerVC.view setFrame:CGRectMake(0, 0, screenWidth, CGRectGetHeight(self.headerScrollerView.frame))];
    _rollingBannerVC.rollingImages = @[[UIImage imageNamed:@"home_banner3"]
                                       ,[UIImage imageNamed:@"home_banner4"]
                                       ];
    
    // Set the placeholder image (optional, the default place holder is nil)
    _rollingBannerVC.placeHolderImage = [UIImage imageNamed:@"home_banner3"];
    [_rollingBannerVC setRemoteImageLoadingBlock:^(UIImageView *imageView, NSString *imageUrlStr, UIImage *placeHolderImage) {
        [imageView sd_cancelCurrentImageLoad];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:placeHolderImage options:SDWebImageProgressiveDownload];
    }];
    // Add a handler when a tap event occours (optional, default do noting)
    [_rollingBannerVC addBannerTapHandler:^(NSInteger whichIndex) {
        NSLog(@"banner tapped, index = %@", @(whichIndex));
    }];
    
    _rollingBannerVC.rollingInterval = 3;
    
    [self addChildViewController:_rollingBannerVC];
    [self.headerScrollerView addSubview:_rollingBannerVC.view];
    [_rollingBannerVC didMoveToParentViewController:self];
}

#pragma mark - Button Handlers
- (void)leftDrawerButtonPress:(id)sender{
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    if (userInfo.clientid) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }else{
        BAFLoginViewController  *loginVC = [[BAFLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (IBAction)showOrderList:(id)sender
{
    BAFWebViewController  *webview = [[BAFWebViewController alloc]init];
    [self.navigationController pushViewController:webview animated:YES];
    [webview loadTargetURL:[NSURL URLWithString:@"http://parknfly.cn/Wap/Index/app_price"] title:@"价格说明"];
}

- (IBAction)showOrderListNotFromNav:(id)sender
{
    DLog(@"显示订单列表");
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    if (userInfo.clientid) {
        OrderListViewController  *orderlistVC = [[OrderListViewController alloc]init];
        [self.navigationController pushViewController:orderlistVC animated:YES];
    }else{
        BAFLoginViewController  *loginVC = [[BAFLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (IBAction)orderParkCar:(id)sender
{
    DLog(@"预约停车");
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    if (userInfo.clientid) {
        BAFOrderViewController  *orderVC = [[BAFOrderViewController alloc]init];
        orderVC.type = kBAFOrderViewControllerTypeOrder;
        [self.navigationController pushViewController:orderVC animated:YES];
    }else{
        BAFLoginViewController  *loginVC = [[BAFLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
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
    OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
    vc.orderIdStr = [self.orderView.orderDic objectForKey:@"id"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Request
- (void)latestOrderWithClientId:(NSString *)clientId
{
    id <HRLOrderInterface> loginReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [loginReq latestOrderRequestWithNumberIndex:kRequestNumberLatestOrder delegte:self client_id:clientId];
}

- (void)getADPhoto
{
    id <HRLOrderInterface> loginReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [loginReq getappphotoRequestWithNumberIndex:kRequestNumberAppPhoto delegte:self];
}

-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if(aRequestID ==  kRequestNumberLatestOrder){
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]==200) {
            self.orderView.delegate = self;
            [self.orderView setType:kBAFCenterOrderViewTypeGoing];
            self.orderView.orderDic = [obj objectForKey:@"data"];
        }
    }
    
    if (aRequestID == kRequestNumberAppPhoto) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]==200) {
            NSMutableArray *mutArr = [NSMutableArray array];
            for (id object in [obj objectForKey:@"data"]) {
                [mutArr addObject:[object objectForKey:@"img_url"]];
            }
            _rollingBannerVC.rollingImages = mutArr;
            [_rollingBannerVC startRolling];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
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

//
@end
