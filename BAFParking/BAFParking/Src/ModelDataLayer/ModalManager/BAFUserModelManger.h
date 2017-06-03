//
//  BAFUserModelManger.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/3.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAFUserInfo.h"

@interface BAFUserModelManger : NSObject
+ (BAFUserModelManger *)sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;

- (void)saveUserInfo:(BAFUserInfo *)userInfo;
- (BAFUserInfo *)userInfo;
- (void)removeUserInfo;
@end
