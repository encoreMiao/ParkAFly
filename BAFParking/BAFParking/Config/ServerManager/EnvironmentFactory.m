//
//  EnvironmentFactory.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "EnvironmentFactory.h"
#import "DevelopEnvironment.h"
#import "DistributedEnvironment.h"

@implementation EnvironmentFactory

+ (EnvironmentFactory *)sharedInstance
{
    static EnvironmentFactory * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[EnvironmentFactory alloc] init];
    });
    
    return _instance;
}

- (BaseEnvironment *)createEnvironment:(BAFServerEnvironment)environment
{
    BaseEnvironment *environmentObject = nil;
    switch (environment) {
        case kBAFServerDevelop:
        {
            environmentObject = [[DevelopEnvironment alloc] init];
        }
            break;
        case kBAFServerDistributed:
        {
            environmentObject = [[DistributedEnvironment alloc] init];
        }
            break;
    }
    return environmentObject;
}
@end
