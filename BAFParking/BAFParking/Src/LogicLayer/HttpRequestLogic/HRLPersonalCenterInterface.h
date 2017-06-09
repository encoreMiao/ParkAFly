//
//  HRLPersonalCenterInterface.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HRLPersonalCenterInterface <NSObject>
/**
 //个人资料信息
 /api/client/client_info

 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param client_id 用户id
 */
- (void)clientInfoRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id;


/**
 //车辆颜色列表 GET
 api/client/car_color_list

 @param numberIndex 求的标记
 @param workThread 请求回调对象
 */
- (void)carColorListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread;


/**
 绑定权益账户
 api/client/equity_account_binding

 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param card_no 权益卡号
 @param password 权益卡密码
 @param bind_phone 绑定的手机号
 */
- (void)equityAccountBindingRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread card_no:(NSString *)card_no password:(NSString *)password bind_phone:(NSString *)bind_phone;


/**
 api/client/equity_account_list
 个人中心-权益账户列表

 @param numberIndex 请求的标记
 @param workThread 请求回调对象
 @param bind_phone 绑定的手机号
 */
- (void)equityAccountListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread bind_phone:(NSString *)bind_phone;



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
 brand 
 color 

 */
- (void)clientEditRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)parm;



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
- (void)clientAvatarRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)parm;








/**
 api/client/personal_account
 功能:账户余额充值页面

 @param client_id client_id
 */
- (void)personalAccountRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id;




/**
 api/client/client_patr
 功能:账户余额交易记录

 @param client_id client_id
 */
- (void)clientPatrRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id;



/**
 api/client/feedback
 功能:意见反馈


 @param client_id client_id
 @param content 反馈内容
 */
- (void)feedBackRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id content:(NSString *)content;




/**
 api/city/city_list
 功能:城市列表 请求方法 :GET/POST

 */
- (void)cityListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread;


- (void)hhh;

/**
 
 api/activity/tc_card
 功能:支付页面-个人腾讯权益卡账号列表 GET

 @param phone 手机号码
 */
- (void)tcCardRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread phone:(NSString *)phone;



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
- (void)checkTcCardRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param;

















/**
 api/coupon/get_coupon_list
 功能:个人中心-优惠券列表
 
 @param client_id client_id
 @param status 优惠券状态:1.未使用;2.已使用;3. 已过期
 */
- (void)couponListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id status:(NSString *)status;


/**
 api/coupon/get_my_coupon
 功能:支付页面-优惠券列表 请求方法 :GET

 @param client_id 用户id
 @param order_id 订单id
 */
- (void)getMyCouponRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id order_id:(NSString *)order_id;



/**
 api/coupon/bind_coupon
 功能:绑定优惠码

 @param client_id client_id
 @param coupon_code 优惠码
 */
- (void)bindCouponRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id coupon_code:(NSString *)coupon_code;


















/**
 api/pay/notify_url
 //功能:微信支付成功后回调接口 请求方法 :GET

 @param order_no 交易流水号
 */
- (void)payNotifyUrlRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread order_no:(NSString *)order_no ;




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
- (void)rechargeOrderRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param;



/**
 api/pay/recharge_notify_url
 功能:个人账户微信充值成功后回调接口 请求方法 :GET
 
 @param recharge_no 充值编号
 */
- (void)rechargeNotifyUrlRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread recharge_no:(NSString *)recharge_no ;




/**
 api/pay/recharge_card
 //    功能:卡密充值
 
 @param client_id client_id
 @param card_no 充值卡卡号
 @param card_password 充值卡密码
 */
- (void)rechargeCardRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id card_no:(NSString *)card_no card_password:(NSString *)card_password;

@end
