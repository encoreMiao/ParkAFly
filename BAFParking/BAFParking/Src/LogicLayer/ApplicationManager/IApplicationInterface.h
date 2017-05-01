//
//  IApplicationInterface.h
//  SohuHouse
//
//  Created by sohu on 16/4/21.
//  Copyright © 2016年 focus.cn. All rights reserved.
//


@protocol IApplicationInterface <NSObject>

@optional
- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;

- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;

- (void)applicationWillTerminate;
@end
