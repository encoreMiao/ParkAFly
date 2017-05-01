//
//  EnvironmentFactory.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEnvironment.h"

typedef NS_ENUM(NSInteger,BAFServerEnvironment) {
    kBAFServerDevelop = 0,
    kBAFServerDistributed,
//    kBAFServerTest,
};

@interface EnvironmentFactory : NSObject

+ (EnvironmentFactory *)sharedInstance;

- (BaseEnvironment *)createEnvironment:(BAFServerEnvironment)environment;

@end
