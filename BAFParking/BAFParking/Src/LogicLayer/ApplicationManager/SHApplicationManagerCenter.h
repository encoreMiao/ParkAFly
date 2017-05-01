//
//  SHApplicationManagerCenter.h
//  SohuHouse
//
//  Created by sohu on 16/4/21.
//  Copyright © 2016年 focus.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IApplicationInterface.h"

@interface SHApplicationManagerCenter : NSObject

+ (SHApplicationManagerCenter*)defaultCenter;

//添加监听
- (void)addObserver:(id<IApplicationInterface>)observer;
- (void)removeObserver:(id<IApplicationInterface>)observer;
- (void)removeAllObserver;

//相应事件
- (void)applicationDidBecomeActive;
- (void)applicationWillResignActive;
- (void)applicationDidEnterBackground;
- (void)applicationWillEnterForeground;
- (void)applicationWillTerminate;

@end
