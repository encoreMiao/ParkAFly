//
//  BAFGlobalMananger.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BAFUserInfo;

#define GlobalManager [BAFGlobalMananger sharedInstance]

@interface BAFGlobalMananger : NSObject
+ (BAFGlobalMananger*)sharedInstance;

#pragma mark-- cookie 读取/存储
/**
 存储HTTP请求地址对应的cookie数据
 
 @param url http请求地址url
 @param key 存储数据对应的key
 */
- (void)saveHTTPCookie:(NSString*)url toKey:(NSString*)key;

/**
 设置HTTP请cookie
 
 @param key 获取对应cookie数据的key
 */
- (void)setHTTPCookieForKey:(NSString*)key;


/**
 设置HTTP请cookie
 
 @param key 获取对应cookie数据的key
 @param url 请求url
 @return cookie字典
 */
- (NSDictionary*)setHTTPCookieForKey:(NSString*)key withUrl:(NSString*)url;

/**
 设置用户登陆状态
 
 @param isLogin 登陆状态
 */
- (void)setLoginStatus:(BOOL)isLogin;

/**
 获取用户登陆状态
 
 @return 返回登陆状态
 */
- (BOOL)getLoginStatus;


#pragma mark-- 存储省市列表信息

/**
 是否存在省市列表信息
 
 @return 存在返回YES,不存在返回NO
 */
- (BOOL)isHasProviceCityList;

/**
 保存省市列表信息
 
 @param array 城市列表信息
 */
- (void)saveProviceCityList:(NSArray*)array;

/**
 读取省市列表信息
 
 @return 省市列表信息
 */
- (NSArray*)getProviceCityList;

/**
 清空登陆cookie信息，退出登陆调用
 */
- (void)deleteAllCookie;


#pragma mark-- 读取/存储用户信息
//存储用户信息
- (void)saveUserInfo:(NSDictionary*)dict;

/**
 删除本地用户信息
 */
- (void)deleteUserInfo;

//获取用户信息
- (BAFUserInfo*)getUserInfo;

@end
