//
//  DevelopEnvironment.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "DevelopEnvironment.h"

@implementation DevelopEnvironment
//主服务器地址 测试环境
- (NSString*)mainServerUrl
{
    return @"http://parknfly.com.cn";
}

//获取Secret
- (NSString *)secretStr
{
    return @"a19e9af4a3cc5c6556729770367927ac";
}
@end
