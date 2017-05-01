//
//  LLErrorOfRequest.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "LLErrorOfRequest.h"

@implementation LLErrorOfRequest


#pragma mark - 处理 errorCode 未登陆（login或cookie为nil或token已过期）
//如果101、102 则退出登录，重新获取Token(100是否为未登陆？)
//100:没有访问权限;101:token 无效(token 过期后,再次请求); 102:token 过期 404:未定义的接口

//USER_NOT_LOGIN = 100,//没有访问权限
//USER_TOKEN_EXPIRED = 102||101,//登录已过期或无效

+ (void)errorCodeDealWith:(int)errorCode
{
    if (errorCode == 100
        || errorCode == 101
        || errorCode == 102) {
        
        //清除cookie，退出登陆
        [[NSNotificationCenter defaultCenter] postNotificationName:NotifyUserLogout object:nil];
        
    }
}
//？？？cookie未null,cookie过期，未登陆
@end
