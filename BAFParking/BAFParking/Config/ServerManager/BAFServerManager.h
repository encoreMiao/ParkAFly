//
//  BAFServerManager.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnvironmentFactory.h"

#define ServerManager  [BAFServerManager sharedInstance]

@interface BAFServerManager : NSObject
+ (BAFServerManager *)sharedInstance;
- (void)buildEnvironment:(BAFServerEnvironment)environment;
//主服务器地址
- (NSString*)mainServerUrl;
//获取Secret
- (NSString *)secretStr;

@end
