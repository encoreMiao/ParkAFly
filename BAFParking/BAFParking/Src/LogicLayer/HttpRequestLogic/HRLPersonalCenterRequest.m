//
//  HRLPersonalCenterRequest.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "HRLPersonalCenterRequest.h"

@implementation HRLPersonalCenterRequest
/**
 //个人资料信息
 /api/client/client_info
 
 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param client_id 用户id
 */
- (void)clientInfoRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id
{
    DLog(@"获取用户信息");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    //client_id
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/client_info") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  code 1.缺少参数 client_id;2.该用户不存在;200.请求成功
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
 //车辆颜色列表
 api/client/car_color_list
 
 @param numberIndex 求的标记
 @param workThread 请求回调对象
 */
- (void)carColorListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread
{
    DLog(@"获取车辆颜色");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    

    //GET请求
    [self getRequestWithUrl:REQURL(@"api/client/car_color_list") parameters:nil headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];


}


/**
 绑定权益账户
 api/client/equity_account_binding
 
 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param card_no 权益卡号
 @param password 权益卡密码
 @param bind_phone 绑定的手机号
 */
- (void)equityAccountBindingRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread card_no:(NSString *)card_no password:(NSString *)password bind_phone:(NSString *)bind_phone
{
    DLog(@"绑定权益账户");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:card_no forKey:@"card_no"];
    [paramters setObject:password forKey:@"password"];
    [paramters setObject:bind_phone forKey:@"bind_phone"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/equity_account_binding") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  code 1.权益卡号不存在;2.权益卡号已经被绑定;3.权益卡号绑定失败;200.权益卡号绑定成 功
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
 api/client/equity_account_list
 个人中心-权益账户列表
 
 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param bind_phone 绑定的手机号
 */
- (void)equityAccountListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread bind_phone:(NSString *)bind_phone
{
    DLog(@"个人中心-权益账户列表");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:bind_phone forKey:@"bind_phone"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/equity_account_list") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  code 1.没有权益账户;200.成功
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
 api/client/client_edit
 功能:个人资料编辑
 
 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param parm
 client_id
 cname
 csex 性别:0.未知;1.男;2.女
 carnum
 caddr 常驻城市 id
 brand 品牌
 color 车身颜色
 
 */
- (void)clientEditRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)parm
{
    DLog(@"个人资料编辑");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithDictionary:parm];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/client_edit") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  1.缺少参数 client_id;200.保存成功。
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
 api/client/client_avatar
 //功能:个人资料-头像编辑
 
 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param parm
 client_id 用户id
 avatar_data 文件二进制数据
 avatar_ext 文件扩展名
 */
- (void)clientAvatarRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)parm
{
    DLog(@"个人资料-头像编辑");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithDictionary:parm];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/client_avatar") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
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
 api/client/personal_account
 功能:账户余额充值页面
 
 @param client_id client_id
 */
- (void)personalAccountRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id
{
    DLog(@"账户余额充值页面");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/personal_account") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  1.缺少参数 client_id;200.成功。
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
 api/client/client_patr
 功能:账户余额交易记录
 
 @param client_id client_id
 */
- (void)clientPatrRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id
{
    DLog(@"账户余额交易记录");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/client_patr") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  1.缺少参数 client_id;200.成功。
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
 api/client/feedback
 功能:意见反馈
 
 
 @param client_id client_id
 @param content 反馈内容
 */
- (void)feedBackRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id content:(NSString *)content
{
    DLog(@"意见反馈");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    [paramters setObject:content forKey:@"content"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/client/feedback") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  1.缺少参数 client_id;2.缺少参数 content;3.提交失败;
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
 api/city/city_list
 功能:城市列表 请求方法 :GET/POST
 
 */
- (void)cityListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread
{
    DLog(@"获取城市列表");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    
    //GET请求
    [self getRequestWithUrl:REQURL(@"api/city/city_list") parameters:nil headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}




/**
 
 api/activity/tc_card
 功能:支付页面-个人腾讯权益卡账号列表 GET
 
 @param phone 手机号码
 */
- (void)tcCardRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread phone:(NSString *)phone
{
    DLog(@"支付页面-个人腾讯权益卡账号列表");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:phone forKey:@"phone"];
    //GET请求
    [self getRequestWithUrl:REQURL(@"api/activity/tc_card") parameters:paramters headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}



/**
 api/activity/check_tc_card
 功能:支付页面-计算腾讯权益卡的费用 请求方法 :GET
 
 @param param
 phone
 card_no
 client_id
 first_day_price 车位费第一天执行价
 day_price 除第一天外每天车位费
 park_day 停车天数
 park_fee 车位总费用
 
 */
- (void)checkTcCardRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param
{
    DLog(@"支付页面-计算腾讯权益卡的费用");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithDictionary:param];

    //GET请求
    [self getRequestWithUrl:REQURL(@"api/activity/check_tc_card") parameters:paramters headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}


























/**
 api/coupon/get_coupon_list
 功能:个人中心-优惠券列表
 
 @param client_id client_id
 @param status 优惠券状态:1.未使用;2.已使用;3. 已过期
 */
- (void)couponListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id status:(NSString *)status
{
    DLog(@"个人中心优惠券列表");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    [paramters setObject:status forKey:@"status"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/coupon/get_coupon_list") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  1.缺少参数 client_id;2.缺少参数 status;3.没有优惠券;
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
 api/coupon/get_my_coupon
 功能:支付页面-优惠券列表 请求方法 :GET
 
 @param client_id 用户id
 @param order_id 订单id
 */
- (void)getMyCouponRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id order_id:(NSString *)order_id
{
    DLog(@"支付页面-优惠券列表");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    [paramters setObject:order_id forKey:@"order_id"];
    
    //GET请求
    [self getRequestWithUrl:REQURL(@"api/coupon/get_my_coupon") parameters:paramters headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
//        1.缺少参数 client_id;2.缺少参数 order_id;
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}



/**
 api/coupon/bind_coupon
 功能:绑定优惠码
 
 @param client_id client_id
 @param coupon_code 优惠码
 */
- (void)bindCouponRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id coupon_code:(NSString *)coupon_code
{
    DLog(@"绑定优惠码");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    [paramters setObject:coupon_code forKey:@"coupon_code"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/coupon/bind_coupon") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
        //  1.缺少参数 client_id;2.缺少参数 coupon_code;3.该优惠券无效;4.优惠码失效或者已 经被使用;5.该优惠码已经被绑定;6.绑定失败;
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
 api/pay/notify_url
 //功能:微信支付成功后回调接口 请求方法 :GET
 
 @param order_no 交易流水号
 */
- (void)payNotifyUrlRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread order_no:(NSString *)order_no
{
    DLog(@"微信支付成功后回调接口");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:order_no forKey:@"order_no"];
    //GET请求
    [self getRequestWithUrl:REQURL(@"api/pay/notify_url") parameters:paramters headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}




/**
 api/pay/recharge_order
 //功能:获取个人账户微信充值订单编号 请求方法 :GET
 
 @param param
 client_id
 recharge_money 充值金额(以分为单位)
 gift_money  赠送金额(以分为单位)
 rechargeid  充值档位 id
 activityid  活动 id
 recharge_discount 充值折扣率
 */
- (void)rechargeOrderRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param
{
    DLog(@"获取个人账户微信充值订单编号");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithDictionary:param];
    //GET请求
    [self getRequestWithUrl:REQURL(@"api/pay/recharge_order") parameters:paramters headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}

- (void)rechargeSignRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param
{
    DLog(@"商户系统调微信支付系统生成预付单 id 和 sign 签名");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithDictionary:param];
    //GET请求
    [self getRequestWithUrl:REQURL(@"api/order/app_wechat_pay") parameters:paramters headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}



/**
 api/pay/recharge_notify_url
 功能:个人账户微信充值成功后回调接口 请求方法 :GET
 
 @param recharge_no 充值编号
 */
- (void)rechargeNotifyUrlRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread recharge_no:(NSString *)recharge_no
{
    DLog(@"个人账户微信充值成功后回调接口");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:recharge_no forKey:@"recharge_no"];
    //GET请求
    [self getRequestWithUrl:REQURL(@"api/pay/recharge_notify_url") parameters:paramters headerFields:headerFields object:nil style:0 success:^(id operation,id responseObject){
        NSLog(@"JSON = %@", responseObject);
        if ([workThread respondsToSelector:@selector(onJobComplete:Object:)]) {
            [workThread onJobComplete:numberIndex Object:(id)responseObject];
        }
    }failure:^(id operation, NSError *error) {
        if ([workThread respondsToSelector:@selector(onJobTimeout:Error:)]) {
            [workThread onJobTimeout:numberIndex Error:nil];
        }
    }];
}




/**
 api/pay/recharge_card
 //    功能:卡密充值
 
 @param client_id client_id
 @param card_no 充值卡卡号
 @param card_password 充值卡密码
 */
- (void)rechargeCardRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id card_no:(NSString *)card_no card_password:(NSString *)card_password
{
    DLog(@"卡密充值");
    //设置请求头
    NSDictionary *headerFields = [[NSDictionary alloc] initWithObjectsAndKeys:@"ios", @"from",
                                  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"token", nil];
    
    //设置请求体
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    [paramters setObject:client_id forKey:@"client_id"];
    [paramters setObject:card_no forKey:@"card_no"];
    [paramters setObject:card_password forKey:@"card_password"];
    
    //post数据请求
    [self postRequestWithUrl:REQURL(@"api/pay/recharge_card") parameters:nil headerFields:headerFields body:paramters object:workThread style:0 success:^(id operation, id responseObject) {
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
