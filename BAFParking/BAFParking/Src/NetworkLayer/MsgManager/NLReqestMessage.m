//
//  NLReqestMessage.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/25.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NLReqestMessage.h"
#import "NSString+URL.h"

@interface NLReqestMessage()
@property (nonatomic, assign) NSInteger msgId;
@property (nonatomic, strong) NSURLSessionTask *task;
@end


@implementation NLReqestMessage

- (id)init{
    if (self = [super init]) {
        _msgId = 0;
        _task = nil;
        _url =  nil;
        _isCancel = NO;
        _parameters = nil;
        _headerFields = nil;
        _body = nil;
        _style = kNLRequestStyleDefault;
        _timeOut = 30;
    }
    return self;
}

+ (NLReqestMessage*)createReqMsg:(NSString*)url
                      parameters:(NSDictionary*)param
                    headerFields:(NSDictionary*)headerFields
                          object:(id)object
                           style:(NSInteger)style
{
    static NSInteger mID = 0;
    
    NLReqestMessage *msg = [[NLReqestMessage alloc] init];
    msg.msgId = ++mID;
    msg.url = url;
    msg.parameters = param;
    msg.headerFields = headerFields;
    msg.style = style;
    msg.object = object;
    
    return msg;
}

+ (NLReqestMessage*)createReqMsg:(NSString*)url
                      parameters:(NSDictionary*)param
                    headerFields:(NSDictionary*)headerFields
                            body:(id)body
                          object:(id)object
                           style:(NSInteger)style
{
    static NSInteger mID = 0;
    
    NLReqestMessage *msg = [[NLReqestMessage alloc] init];
    msg.msgId = ++mID;
    msg.url = url;
    msg.parameters = param;
    msg.headerFields = headerFields;
    msg.body = body;
    msg.style = style;
    msg.object = object;
    
    return msg;
}

- (void)setTask:(NSURLSessionTask *)task
{
    _task = task;
}
- (void)cancelMsgTask
{
    if (_task) {
        [_task cancel];
    }
}
//获取请求链接url(get请求)
- (NSString *)getRequestUrl
{
    NSString *reqUrl = [NSString mm_encodeUrlString:_url fromDictionary:_parameters];
    return reqUrl;
}
- (void)displayRequestUrl
{
    NSString *reqUrl = [self getRequestUrl];
    NSLog(@"<%@> Url = %@",[_object class],reqUrl);//回调对象的类中的url
}

@end
