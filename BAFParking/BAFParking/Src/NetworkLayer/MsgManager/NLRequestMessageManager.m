//
//  NLRequestMessageManager.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NLRequestMessageManager.h"

@interface NLRequestMessageManager ()
@property (nonatomic, strong) NSMutableDictionary *mDict;//存储消息 ，每个代理对象都有一个请求消息的列表。
@end

@implementation NLRequestMessageManager

+ (NLRequestMessageManager*)sharedInstance
{
    static NLRequestMessageManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NLRequestMessageManager alloc] init];
    });
    return _instance;
}

- (id)init
{
    if (self = [super init]) {
        _mDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark
//添加请求消息
- (void)addReqMSG:(NLReqestMessage*)msg task:(NSURLSessionTask*)task
{
    [msg setTask:task];
    [self add:msg];
}
//移除请求消息
- (BOOL)removeReqMsg:(NLReqestMessage*)msg
{
    if (!msg) {
        return NO;
    }
    NSString *key = [NSString stringWithFormat:@"%p", msg.object];
    NSMutableArray *msgList = [_mDict objectForKey:key];
    if (msgList && (msgList.count !=0)) {
        [msgList removeObject:msg];
        if (msgList.count == 0) {
            [_mDict removeObjectForKey:key];
        }
    }
    return YES;
}

//取消整个回调对象上的请求
- (BOOL)cancelReqMsgWithObject:(id)object
{
    if (!object) {
        return NO;
    }
    NSString *key = [NSString stringWithFormat:@"%p", object];
    NSMutableArray *msgList = [_mDict objectForKey:key];
    if (msgList && (msgList.count !=0))
    {
        for (NLReqestMessage *msg in msgList) {
            msg.isCancel = YES;
            [msg cancelMsgTask];
        }
        
        [msgList removeAllObjects];
        [_mDict removeObjectForKey:key];
    }
    return YES;
}

#pragma mark - PrivateMethods
//添加请求消息
- (BOOL)add:(NLReqestMessage *)msg
{
    if (!msg) {
        return NO;
    }
    BOOL isHasReq = [self isHasReqMsg:msg];
    if (isHasReq) {
        if (msg.style == kNLRequestStyleCancelOld) {
            //取消已存在的请求
            [self cancelHasReqMsg:msg];
            [self addReqMsg:msg];
        }
        else if(msg.style == kNLRequestStyleCancelNew)
        {
            //取消当前新请求信息，其实就是不必将当前请求信息加到请求队列中
            //- (BOOL)cancelReqMsg:(NLReqestMessage*)msg
            msg.isCancel = YES;
            [msg cancelMsgTask];
        }
        else
        {
            [self addReqMsg:msg];
        }
    }
    else
    {
        [self addReqMsg:msg];
    }
    return YES;
}

//添加请求消息
- (BOOL)addReqMsg:(NLReqestMessage*)msg
{
    if (!msg) {
        return NO;
    }
    NSString *key = [NSString stringWithFormat:@"%p", msg.object];
    NSMutableArray *msgList = [_mDict objectForKey:key];
    if (msgList && (msgList.count !=0)) {
        [msgList addObject:msg];
    }
    else
    {
        NSMutableArray *newMsgList = [[NSMutableArray alloc] init];
        [newMsgList addObject:msg];
        [_mDict setObject:newMsgList forKey:key];
    }
    return YES;
}
//是否有相同的请求在请求队列中
- (BOOL)isHasReqMsg:(NLReqestMessage*)msg
{
    if (!msg) {
        return NO;
    }
    NSString *key = [NSString stringWithFormat:@"%p", msg.object];
    NSMutableArray *msgList = [_mDict objectForKey:key];
    if (msgList && (msgList.count !=0))
    {
        for (NSInteger i=0; i< msgList.count; i++) {
            NLReqestMessage *subMsg = msgList[i];
            if ([subMsg.url isEqualToString:msg.url]) {
                return YES;
            }
        }
        
    }
    return NO;
}

//取消已存在队列中的请求
- (BOOL)cancelHasReqMsg:(NLReqestMessage*)msg
{
    if (!msg) {
        return NO;
    }
    NSString *key = [NSString stringWithFormat:@"%p", msg.object];
    NSMutableArray *msgList = [_mDict objectForKey:key];
    NSMutableArray *cancelList = [[NSMutableArray alloc] init];
    if (msgList && (msgList.count !=0))
    {
        for (NSInteger i=0; i< msgList.count; i++) {
            
            NLReqestMessage *subMsg = msgList[i];
            if ([subMsg.url isEqualToString:msg.url]) {
                subMsg.isCancel = YES;
                [subMsg cancelMsgTask];
                [cancelList addObject:subMsg];
                
            }
        }
        [msgList removeObjectsInArray:cancelList];
    }
    return YES;
}

//取消当前请求消息
- (BOOL)cancelReqMsg:(NLReqestMessage*)msg
{
    if (!msg) {
        return NO;
    }
    NSString *key = [NSString stringWithFormat:@"%p", msg.object];
    NSMutableArray *msgList = [_mDict objectForKey:key];
    if (msgList && (msgList.count !=0))
    {
        [msgList removeObject:msg];
        msg.isCancel = YES;
        [msg cancelMsgTask];
    }
    return YES;
}
@end
