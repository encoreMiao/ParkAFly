//
//  DistributedEnvironment.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "DistributedEnvironment.h"

@implementation DistributedEnvironment
//主服务器地址 生产环境
- (NSString*)mainServerUrl
{
    return @"http://parknfly.cn";
}

//获取Secret
- (NSString *)secretStr
{
    return @"67e9e377a2ee0f25a274754836fc1f05";
}
@end
