//
//  BAFGlobalMananger.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFGlobalMananger.h"
#import "BAFUserInfo.h"
@implementation BAFGlobalMananger

+ (BAFGlobalMananger*)sharedInstance
{
    static BAFGlobalMananger *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BAFGlobalMananger alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    if (self = [super init]) {
        //
    }
    
    return self;
}


///**
// 设置用户登陆状态
// 
// @param isLogin 登陆状态
// */
//- (void)setLoginStatus:(BOOL)isLogin
//{
//    NSNumber *loginStatus = [NSNumber numberWithBool:isLogin];
//    [[NSUserDefaults standardUserDefaults] setObject:loginStatus forKey:kLoginStatus];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
///**
// 获取用户登陆状态
// 
// @return 返回登陆状态
// */
//- (BOOL)getLoginStatus
//{
//    NSNumber *loginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginStatus];
//    
//    if (loginStatus) {
//        return [loginStatus boolValue];
//    }
//    
//    return NO;
//}
//
//#pragma mark-- 存储省市列表信息
//- (BOOL)isHasProviceCityList
//{
//    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:kProviceCityInfo];
//    
//    if (!list) {
//        return NO;
//    }
//    
//    return YES;
//}
//
//- (void)saveProviceCityList:(NSArray*)array
//{
//    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kProviceCityInfo];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (NSArray*)getProviceCityList
//{
//    NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:kProviceCityInfo];
//    
//    return list;
//}
//
//#pragma mark-- 读取/存储用户信息
////存储用户信息
//- (void)saveUserInfo:(NSDictionary*)dict
//{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLoginUserInfo];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//
///**
// 删除本地用户信息
// */
//- (void)deleteUserInfo
//{
//    //清除本地用户信息
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLoginUserInfo];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
////获取用户信息
//- (BAFUserInfo*)getUserInfo
//{
//    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginUserInfo];
//    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    BAFUserInfo *userInfo = [[UserInfo alloc] initWithDictionary:dict];
//    
//    return userInfo;
//}
//
//#pragma mark-- cookie 读取/存储
///**
// 存储HTTP请求地址对应的cookie数据
// 
// @param url http请求地址url
// @param key 存储数据对应的key
// */
//- (void)saveHTTPCookie:(NSString*)url toKey:(NSString*)key
//{
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//
///**
// 设置HTTP请cookie
// 
// @param key 获取存储cookie数据对应的key
// */
//- (void)setHTTPCookieForKey:(NSString*)key
//{
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            NSLog(@"login --- cookie = %@", cookie);
//            NSDictionary *properties = @{ NSHTTPCookieName:cookie.name,
//                                          NSHTTPCookieValue:cookie.value,
//                                          NSHTTPCookieDomain:kHttpCookieDomain,
//                                          NSHTTPCookiePath:@"/"};
//            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        }
//    }
//}
//
//- (NSDictionary*)setHTTPCookieForKey:(NSString*)key withUrl:(NSString*)url
//{
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    if([cookiesdata length]) {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            NSLog(@"login --- cookie = %@", cookie);
//            NSDictionary *properties = @{ NSHTTPCookieName:cookie.name,
//                                          NSHTTPCookieValue:cookie.value,
//                                          NSHTTPCookieDomain:kHttpCookieDomain,
//                                          NSHTTPCookiePath:@"/"};
//            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            
//        }
//        
//        //add
//        //        NSURL *dataUrl = [NSURL URLWithString:url];
//        //        NSArray *subCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:dataUrl];//id: NSHTTPCookie
//        NSDictionary *dict = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//        
//        return dict;
//        //end
//    }
//    
//    return nil;
//}
//
//
///**
// 清空登陆cookie信息，退出登陆调用
// */
//- (void)deleteAllCookie
//{
//    //清除cookies
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [storage cookies])
//    {
//        [storage deleteCookie:cookie];
//    }
//    
//    NSURLCache *cache = [NSURLCache sharedURLCache];
//    [cache removeAllCachedResponses];
//    [cache setDiskCapacity:0];
//    [cache setMemoryCapacity:0];
//    
//    //清除本地登陆cookie数据
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsCookie];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void)cleanCookie
//{
//    
//}

@end
