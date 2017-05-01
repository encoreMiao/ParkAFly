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
- (void)loginRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread phone:(NSString *)phone
{
    DLog(@"获取短信验证码");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:phone forKey:@"phone"];
    
    NSMutableString *randSim = [NSMutableString string];
    for (int i = 0; i<6; i++) {
        NSString *str = [NSString stringWithFormat:@"%i",arc4random()%10];
        [randSim appendString:str];
    }
    [paramters setObject:randSim forKey:@"sim"];
    
    NSString *md5Secret = nil;
#ifdef PUBLISHCONFIG
    md5Secret = [NSString stringWithFormat:@"%@+%@+%@",phone,randSim,@"67e9e377a2ee0f25a274754836fc1f05"];
#else
    md5Secret = [NSString stringWithFormat:@"%@+%@+%@",phone,randSim,@"a19e9af4a3cc5c6556729770367927ac"];
#endif
    [paramters setObject:[NSString md5WithString:md5Secret]  forKey:@"secret_key"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/login/sms_code_af4a3cc5c6556729") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        
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
//- (NSDictionary *)filterInvaludateParam:(NSDictionary *)dataDic
//{
//    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
//    [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *obj, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"-100"] == NO) {
//            [paramDic setNonemptyValue:obj forkey:key];
//        }
//    }];
//    
//    return paramDic;
//}
- (void)test
{
    [self postRequestWithUrl:@"http://123.57.219.230/vis/getdoors.action" parameters:nil headerFields:nil body:nil object:nil style:0 success:^(id operation, id responseObject) {
        
        NSLog(@"JSON = %@", responseObject);
    } failure:^(id operation, NSError *error) {
        
    }];
}
@end
