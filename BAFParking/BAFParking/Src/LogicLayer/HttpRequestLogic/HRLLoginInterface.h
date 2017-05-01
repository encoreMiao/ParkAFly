//
//  HRLLoginInterface.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/30.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HRLLoginInterface <NSObject>
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
- (void)loginRequestWithNumberIndex:(int)numberIndex delegte:(id)delegate parameters:(NSDictionary *)paramters;
@end
