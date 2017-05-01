//
//  NLRequestMessageManager.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
// Description：请求消息类 的管理类
//

#import <Foundation/Foundation.h>
#import "NLReqestMessage.h"

#define ADDREQMSG(msg, reqTask)    [[NLRequestMessageManager sharedInstance] addReqMSG:msg task:reqTask]
#define REMOVEREQMSG(msg)       [[NLRequestMessageManager sharedInstance] removeReqMsg:msg]
#define CANCELREQMSGOBC(object) [[NLRequestMessageManager sharedInstance] cancelReqMsgWithObject:object]

@interface NLRequestMessageManager : NSObject

+ (NLRequestMessageManager*)sharedInstance;
//添加请求消息
- (void)addReqMSG:(NLReqestMessage*)msg task:(NSURLSessionTask*)task;
//移除请求消息
- (BOOL)removeReqMsg:(NLReqestMessage*)msg;

//取消整个回调对象上的请求
- (BOOL)cancelReqMsgWithObject:(id)object;
@end
