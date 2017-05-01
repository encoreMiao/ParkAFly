//
//  NetStatusModel.m
//  SohuHouse
//
//  Created by sohu on 16/4/20.
//  Copyright © 2016年 focus.cn. All rights reserved.
//

#import "NetStatusModel.h"
#import "SHNetNotificationCenter.h"
#import "AFNetworking.h"

@implementation NetStatusModel

+ (id)shareInstance
{
    static NetStatusModel *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NetStatusModel alloc] init];
    });
    
    return _instance;
}

#pragma mark - 设置网络状态监听
- (void)setNetworkStatusMonitor
{
    //创建网络监听管理者对象
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //设置监听
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //取得网络状态
        [[SHNetNotificationCenter defaultCenter] updateState:(SHNetworkStatus)status];
    }];
    
    //开始监听
    [manager startMonitoring];
}


@end
