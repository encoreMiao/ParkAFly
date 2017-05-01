//
//  SHNetNotificationCenter.h
//  SohuHouse
//
//  Created by sohu on 16/4/20.
//  Copyright © 2016年 focus.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INetStatusInterface.h"

@interface SHNetNotificationCenter : NSObject
+ (SHNetNotificationCenter*)defaultCenter;

- (void)addObserver:(id<INetStatusInterface>)observer;
- (void)removeObserver:(id<INetStatusInterface>)observer;
- (void)removeAllObserver;

//更新网络状态
- (void)updateState:(SHNetworkStatus)status;

@end
