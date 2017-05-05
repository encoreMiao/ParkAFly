//
//  BaseEnvironment.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BaseEnvironment.h"

@implementation BaseEnvironment

#pragma mark -- 线上、测试、开发环境地址不同
//主服务器地址
- (NSString *)mainServerUrl
{
    return @"";
}

//获取Secret
- (NSString *)secretStr
{
    return @"";
}
@end
