//
//  BAFConfigFile.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#ifndef BAFConfigFile_h
#define BAFConfigFile_h

/******************服务器环境切换开关******************/
//#define PUBLISHCONFIG  //发布环境宏定义，在测试时注释掉该宏定义

/******************HTTPS请求支持******************/
//#define kOpenHttpsSSL           //添加支持https证书请求
//#define kCancelHttpsValidation  //取消客户端对https证书的验证（测试阶段使用），正式包需要注释掉

/******************请求基地址******************/
#define Server_Url  [ServerManager mainServerUrl]

/******************请求地址宏定义******************/
#define REQURL(active)  [NSString stringWithFormat:@"%@/%@",Server_Url, active]



/******************三方应用访问的相关注册参数******************/

///******************高德地图参数定义******************/
////高德地图Key
//#define kMapKey                 @"96e519da3e6f9dbfd43e875afbc4fb06"
////腾讯街景地图KEY
//#define kQMapApiKey  @""
//
///******************新浪微博******************/
//#define WBKey @"3148142750"
//#define WBRedirectURI @"http://house.focus.cn/app/"
//#define WBSecret @"4c21293cf905ea7ff10a0b3da52acd60"
//
///******************QQ******************/
//#define QQAPPID @"1105845877"
//#define QQRedirectURI @"http://house.focus.cn/app/"
////腾讯IM SDK key
//#define TXIMSdkKey 1400018644
//
///******************微信******************/
//#define WeiXinAPPID @"wxe853748d99d7b2b0"
//#define WeiXinSecret @"42c2f3e98e41e1d461d8fbd5a17643e7"
//#define WeiXinRedirectURI @"http://house.focus.cn/app/"
//
///******************友盟key******************/
//#define UmengKey  @"585203cf2ae85b6d510024f0"



#endif /* BAFConfigFile_h */
