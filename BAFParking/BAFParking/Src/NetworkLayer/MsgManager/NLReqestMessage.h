//
//  NLReqestMessage.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/25.
//  Copyright © 2017年 boanfei. All rights reserved.
// Description:请求的model消息类
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,NLRequestStyle)
{
    kNLRequestStyleDefault = 0,//可重复发送请求
    kNLRequestStyleCancelNew,//取消新请求，保留已发请求 （刷新机制）
    kNLRequestStyleCancelOld,//取消已发请求，保留新请求（条件搜索）
};

@interface NLReqestMessage : NSObject
@property (nonatomic, strong) NSString *url;//baseURL
@property (nonatomic, strong) NSDictionary *parameters;//URL参数
@property (nonatomic, strong) NSDictionary *headerFields;//请求头
@property (nonatomic, strong) id body;//请求体
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) NLRequestStyle style;
@property (nonatomic, assign) NSInteger timeOut;//超时时间
@property (nonatomic, strong) id object;//回调对象

+ (NLReqestMessage*)createReqMsg:(NSString*)url
                      parameters:(NSDictionary*)param
                    headerFields:(NSDictionary*)headerFields
                          object:(id)object
                           style:(NSInteger)style;

+ (NLReqestMessage*)createReqMsg:(NSString*)url
             parameters:(NSDictionary*)param
           headerFields:(NSDictionary*)headerFields
                   body:(id)body
                 object:(id)object
                  style:(NSInteger)style;

- (void)setTask:(NSURLSessionTask *)task;
- (void)cancelMsgTask;
- (NSString *)getRequestUrl;
- (void)displayRequestUrl;

@end
