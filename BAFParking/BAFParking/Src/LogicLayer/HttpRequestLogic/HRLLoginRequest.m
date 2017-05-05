//
//  HRLLoginRequest.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/30.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "HRLLoginRequest.h"
//#import "NSMutableDictionary+Valuation.h"
#import "NSString+HashMD5.h"

@implementation HRLLoginRequest
/*
 获取短信验证码：
 /api/login/sms_code_af4a3cc5c6556729
 
 @param numberIndex 请求的标记
 @param delegate 请求回调对象
 @param paramters
 参数 ：
 phone：手机号
 sim：客户端随机生成6位随机数
 secret_key：密钥 md5(phone+sim+secret)
 
 secret:测试环境(a19e9af4a3cc5c6556729770367927ac)
 secret:生产环境(67e9e377a2ee0f25a274754836fc1f05)
 
 参数类型 ：string
 参数位置 ：bodyParam
 */
- (void)msgCodeRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread phone:(NSString *)phone
{
    DLog(@"获取短信验证码");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from", nil];
    
    //设置请求体
    //phone
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:phone forKey:@"phone"];
    
    //sime
    NSMutableString *randSim = [NSMutableString string];
    for (int i = 0; i<6; i++) {
        NSString *str = [NSString stringWithFormat:@"%i",arc4random()%10];
        [randSim appendString:str];
    }
    [paramters setObject:randSim forKey:@"sim"];
    
    //secret_key
    NSString *secret = [NSString stringWithFormat:@"%@+%@+%@",phone,randSim,[ServerManager secretStr]];
    NSString *md5Secret = [NSString md5ForLower32Bate:secret];
    [paramters setObject:md5Secret  forKey:@"secret_key"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/login/sms_code_af4a3cc5c6556729") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
//        code 1.手机号格式错误;2.随机数格式错误;3.密钥错误;4.频繁请求;200.短信发送成功。
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    } failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
    
}


/**
 用户登录
 /api/login/login
 
 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param phone 手机号码
 @param sms_verification_code 短信验证码
 */
- (void)loginRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread phone:(NSString *)phone msgCode:(NSString *)sms_verification_code
{
    DLog(@"登录");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from", nil];
    
    //设置请求体
    //phone
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:phone forKey:@"phone"];
    
    //sms_verification_code
    [paramters setObject:sms_verification_code forKey:@"sms_verification_code"];
    
    //device
    NSString *device = [[NSUUID UUID] UUIDString];;
    [paramters setObject:device  forKey:@"device"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/login/login") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
//       code 1.手机号格式错误;2.短信验证码错误;3.短信验证码失效;4.缺少手机设备号参数;200.ok
//        token 密钥
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    } failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];

}


/**
 检测 app 版本号
 /api/login/check_version
 
 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param version app 版本号
 */
- (void)checkVersionRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread version:(NSString *)version
{
    DLog(@"登录");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from", nil];
    
    //设置请求体
    //version
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:version forKey:@"version"];
    
    [paramters setObject:@"ios" forKey:@"source"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/login/check_version") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
//            "code": 1000（1000.提示更新;200.已经是最新版本。）, "message": "版本描述", "data": 下载地址
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    } failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}

@end
