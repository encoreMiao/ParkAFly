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
#import "SHFGuideViewController.h"
#import "ParkListTableViewCell.h"

#import "THLevelDB.h"

@interface AppDelegate ()<UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, strong) SHFGuideViewController *guideVC;
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
    
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.window setRootViewController:self.drawerController];
    
    [WXApi registerApp:@"wxd9b4c7082b53f5b3"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLaunch"] == nil){
        [self showGuideVC];
        [[NSUserDefaults standardUserDefaults] setObject:@"launched" forKey:@"FirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

//    //初始化数据库
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *pageDBPath = [docPath stringByAppendingPathComponent:@"my_leveldb.ldb"];
//    THLevelDB *myLevelDB = [THLevelDB levelDBWithPath:pageDBPath];
//    
//    [myLevelDB setString:@"hello world" forKey:@"username"];
//    
//    NSString *str = [myLevelDB stringForKey:@"username"];
//    NSLog(@"%@",str);
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
        if (resp.errCode == WXSuccess) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
            NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
    //只支持这一个方向(正常的方向)
}

- (void)showGuideVC
{
    self.guideVC = [[SHFGuideViewController alloc] init];
    [self.guideVC.view setFrame:[UIScreen mainScreen].bounds];
    [self.drawerController.view addSubview:self.guideVC.view];
}

@end
