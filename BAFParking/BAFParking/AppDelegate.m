//
//  AppDelegate.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/7.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "AppDelegate.h"
#import "DCIntrospect.h"

#import "BAFCenterViewController.h"
#import "BAFLeftViewController.h"
#import "MMDrawerController.h"

#import "BAFBaseNavigationViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <IQKeyboardManager.h>

@interface AppDelegate ()<UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (nonatomic, strong) MMDrawerController *drawerController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //视图内省
    [[DCIntrospect sharedIntrospector] start];
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"GGtH5TSSSQgbZ2uPCa9ITh49RbhA28aN"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    //抽屉框
    BAFLeftViewController *leftDrawerVC = [[BAFLeftViewController alloc]init];
    BAFCenterViewController *centerVC = [[BAFCenterViewController alloc]init];
    
    BAFBaseNavigationViewController *leftNav = [[BAFBaseNavigationViewController alloc]initWithRootViewController:leftDrawerVC];
    BAFBaseNavigationViewController *centerNav = [[BAFBaseNavigationViewController alloc]initWithRootViewController:centerVC];
    
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNav leftDrawerViewController:leftNav];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:250.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    self.drawerController.centerHiddenInteractionMode = MMDrawerOpenCenterInteractionModeNavigationBarOnly;
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.window setRootViewController:self.drawerController];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
