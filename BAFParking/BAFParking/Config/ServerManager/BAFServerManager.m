//
//  BAFServerManager.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFServerManager.h"

@interface BAFServerManager ()
@property (nonatomic, strong) BaseEnvironment * environmentObject;
@end

@implementation BAFServerManager

+ (BAFServerManager*)sharedInstance
{
    static BAFServerManager * _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BAFServerManager alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    if (self = [super init]) {
        [self ConfigServerEnvironment];
    }
    
    return self;
}

- (void)ConfigServerEnvironment
{
    
#ifdef PUBLISHCONFIG
    //发布环境
    [self buildEnvironment:kBAFServerDistributed];
//#elif (defined QASERVER)
//    [self buildEnvironment:SEQATest];
#else
    //测试环境
    [self buildEnvironment:kBAFServerDevelop];
#endif
    
}

- (void)buildEnvironment:(BAFServerEnvironment)environment
{
    _environmentObject = [[EnvironmentFactory sharedInstance] createEnvironment:environment];
}


//主服务器地址
- (NSString*)mainServerUrl
{
    return [_environmentObject mainServerUrl];
}

//获取Secret
- (NSString *)secretStr
{
    return [_environmentObject secretStr];
}

@end
