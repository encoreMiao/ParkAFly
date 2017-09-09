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
#import "HCCycleView.h"

typedef NS_ENUM(NSInteger, BAFCenterViewControllerRequestType)
{
    kRequestNumberLatestOrder,
    kRequestNumberAppPhoto,
    kRequestNumberIndexVersion,//检测版本号
};

@interface BAFCenterViewController ()<BAFCenterOrderViewDelegate,BMKLocationServiceDelegate>{
    BMKLocationService *_locService;
    HCCycleView      *_rollingBannerVC;
}
@property (nonatomic, weak) IBOutlet UIButton           *showPersonalCenterButton;
@property (nonatomic, weak) IBOutlet UIButton           *showOrderListButton;
@property (nonatomic, weak) IBOutlet UIView             *headerScrollerView;
@property (nonatomic, weak) IBOutlet BAFCenterOrderView *orderView;
@property (nonatomic, strong) NSString *appstoreStr;
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
    
    static BOOL needCheck = YES;
    if (needCheck) {
        [self checkVersion];
        needCheck = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [_rollingBannerVC stopRolling];
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
    _rollingBannerVC = [HCCycleView cycleViewWithFrame:CGRectMake(0, 0, screenWidth, CGRectGetHeight(self.headerScrollerView.frame)) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner3"]];
//    [_rollingBannerVC.view setFrame:CGRectMake(0, 0, screenWidth, CGRectGetHeight(self.headerScrollerView.frame))];
//    _rollingBannerVC.rollingImages = @[[UIImage imageNamed:@"home_banner3"]
//                                       ,[UIImage imageNamed:@"home_banner4"]
//                                       ];
//    
//    // Set the placeholder image (optional, the default place holder is nil)
//    _rollingBannerVC.placeHolderImage = [UIImage imageNamed:@"home_banner3"];
//    [_rollingBannerVC setRemoteImageLoadingBlock:^(UIImageView *imageView, NSString *imageUrlStr, UIImage *placeHolderImage) {
//        [imageView sd_cancelCurrentImageLoad];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:placeHolderImage options:SDWebImageProgressiveDownload];
//    }];
//    // Add a handler when a tap event occours (optional, default do noting)
//    [_rollingBannerVC addBannerTapHandler:^(NSInteger whichIndex) {
//        NSLog(@"banner tapped, index = %@", @(whichIndex));
//    }];
//    
//    _rollingBannerVC.rollingInterval = 3;
    
    [self.headerScrollerView addSubview:_rollingBannerVC];
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
- (void)checkVersion
{
    id <HRLLoginInterface> loginReq = [[HRLogicManager sharedInstance] getLoginReqest];
    [loginReq checkVersionRequestWithNumberIndex:kRequestNumberIndexVersion delegte:self version:@"1.0.1"];
}

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
            __block NSMutableArray *urlArr = [NSMutableArray array];
            __block NSMutableArray *titleArr = [NSMutableArray array];
            for (id object in [obj objectForKey:@"data"]) {
                [mutArr addObject:[object objectForKey:@"img_url"]];
                [urlArr addObject:[object objectForKey:@"detail_url"]];
                [titleArr addObject:[object objectForKey:@"title"]];
            }
//            _rollingBannerVC.rollingImages = mutArr;
//            [_rollingBannerVC startRolling];
            
            WS(weakself);
            _rollingBannerVC.imageArrays = mutArr;
            _rollingBannerVC.didClickPicture = ^(NSInteger index){
                NSString *urlstr = [urlArr objectAtIndex:index];
                NSString *titleStr = [titleArr objectAtIndex:index];
                if ([urlstr isEqualToString:@""]||[urlstr isEqual:[NSNull null]]||!urlstr){
                    titleStr = nil;
                }
                if ([urlstr isEqualToString:@""]||[urlstr isEqual:[NSNull null]]||!urlstr) {
                    
                }else{
                    BAFWebViewController  *webview = [[BAFWebViewController alloc]init];
                    if (!titleStr) {
                        webview.useWebTitle = YES;
                    }
                    [weakself.navigationController pushViewController:webview animated:YES];
                    [webview loadTargetURL:[NSURL URLWithString:urlstr] title:titleStr];
                }
            };
        }
    }
    
    if (aRequestID == kRequestNumberIndexVersion) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]==1000) {
            //提示更新"message": "版本 述", "data": 下载地址
            id message = [obj objectForKey:@"message"];
            if (!message ||[message isEqual:[NSNull null]]||[message isEqualToString:@""]) {
                
            }else{
                self.appstoreStr = [obj objectForKey:@"data"];
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需要更新" delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新",nil];
                [alertView show];
            }
        }else{
            
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        if (!self.appstoreStr ||[self.appstoreStr isEqual:[NSNull null]]||[self.appstoreStr isEqualToString:@""]) {
            
        }else{
            //跳转
//            self.appstoreStr = @"https://itunes.apple.com/cn/app/%E5%BE%AE%E4%BF%A1/id414478124?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appstoreStr]];
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
