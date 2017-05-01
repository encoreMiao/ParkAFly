//
//  INetStatusInterface.h
//  SohuHouse
//
//  Created by sohu on 16/4/20.
//  Copyright © 2016年 focus.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SHNetworkStatus)
{
    SHNetworkStatusUnknown          = -1,
    SHNetworkStatusNotReachable     = 0,
    SHNetworkStatusReachableViaWWAN = 1,
    SHNetworkStatusReachableViaWiFi = 2,
};

@protocol INetStatusInterface <NSObject>
@optional
- (void)netReachabilityStatusChange:(SHNetworkStatus)status;
@end
