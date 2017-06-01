//
//  NetStatusModel.h
//  SohuHouse
//
//  Created by sohu on 16/4/20.
//  Copyright © 2016年 focus.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetStatusModel : NSObject

+ (id)shareInstance;
//设置网络状态监听
- (void)setNetworkStatusMonitor;
- (BOOL)checkNetwork;
@end
