//
//  HRLOrderRequest.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "HRLOrderRequest.h"

@implementation HRLOrderRequest
/**
 api/comment/create_comment
 功能:发表评论
 
 @param param
 order_id
 park_id
 contact_phone
 score 星级、评分
 tags 标签
 remark 评语
 
 //1.order_id,park_id,contact_phone 三个字段缺一不可;
 2.手机号格式错误;3.评分、标签、评语至少有一个不为空;
 
 */
- (void)createCommentRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param
{
    
}




/**
 api/comment/view_comment
 功能:查看订单的评论    GET
 
 @param order_id order_id
 */
- (void)viewCommentRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread order_id:(NSString *)order_id
{
    
}


/**
 api/comment/comment_list
 功能:订单的评论列表 请求方法 :GET
 
 @param order_id 订单id
 */
- (void)commentListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread order_id:(NSString *)order_id
{
    
}


/**
 api/comment/comment_tag
 功能:评论标签 请求方法 :GET/POST
 
 */
- (void)commentListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread
{
    
}



















/**
 api/order/add
 功能:创建订单
 
 @param param
 city_id 城市 id
 park_id 停车场 id
 plan_park_time 预计停车时间如:2017-03-22 15:22
 leave_terminal_id 出发航站楼 id
 
 contact_name 联系人姓名
 contact_gender 联系人性别:unknown-未知，male- 男，female-女
 contact_phone
 car_license_no
 
 order_source 下单来源:wechat.微信,user_android.用户安卓端, user_ios.用户 IOS 端
 client_id
 park_day
 
 <一下是非必填>
 plan_pick_time 预计取车时间
 back_terminal_id  返程航站楼 id
 leave_passenger_number 出发同行人数
 petrol 汽油型号:如 92#
 back_flight_no 返程航班号
 service 收费项 id=>备注，如汽油 6=>92#
 
 
 1. 订单来源必填;2.手机号必填;3.车牌号必填;4.预计停车时间必填;5.泊车城市必填; 6. 停车场必填;7. 出发航站楼必填;19. 用户已被冻结;20. 未定义的下单来源;
 21. 手机号格式错误;22. 车牌号格式错误;23.停车时间格式错误;
 24. 停车时间必须晚于当前时间;25.代客泊车必须提前两小时预约;26.取车时间格式错误; 27. 取车时间必须晚于停车时间;28.未定义的联系人性别;29.停车场停止服务; 30.城市未运营停车场;31.停车场不支持出发航站楼;32. 停车场不支持回程航站楼;
 
 33. 订单创建失败;34. 服务创建失败;101.车位服务资源不足;202.代泊服务资源不足; 203.异地取车服务资源不足;204.代加油服务资源不足;205.洗车服务资源不足; 200.创建成功
 */
- (void)addOrderRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param
{
    
}




/**
 api/order/edit
 功能:修改订单
 
 @param param
 plan_park_time 预计停车时间如:2017-03-22 15:22
 plan_pick_time
 back_terminal_id
 leave_passenger_number 触发通行人数
 
 
 1.订单不存在;2. 订单状态异常;3.已确认取车，不可修改;4.停车时间格式错误 5.代客泊车必须提前两小时预约;6.停车场不支持出发航站楼;7.取车时间格式错误 8.取车时间必须晚于停车时间;9.取车时间必须晚于停车时间(数据库);
 10.取车时间格式错误;11.代客泊车必须提前两小时预约;12. 停车场不支持回程航站楼; 200.修改成功
 */
- (void)editOrderRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param
{
    
}


/**
 api/order/cancel
 功能:取消订单
 
 @param order_id order_id
 */
- (void)cancelOrderRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread order_id:(NSString *)order_id
{
    
}



/**
 api/order/order_fee
 功能:订单费用 请求方法 :GET
 
 @param order_id order_id
 
 201.摆渡车费，202.代泊费，203.异地取车费，204.代加油服务，205.洗车服务，206.自行往返航站楼 101.车位费
 */
- (void)orderFeeRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread order_id:(NSString *)order_id
{
    
}



/**
 api/order/detail
 功能:订单详情
 @param order_id order_id
 */
- (void)orderDetailRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread order_id:(NSString *)order_id
{
    
}


/**
 api/order/latest_order
 功能:app 主界面最新订单
 
 @param client_id client_id
 */
- (void)latestOrderRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id
{
    
}






/**
 api/order/order_list
 功能:订单列表 请求方法 :GET
 
 @param client_id 客户id
 @param order_status 1.进行中;2.已完成
 */
- (void)orderListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread client_id:(NSString *)client_id order_status:(NSString *)order_status
{
    
}


/**
 pi/order/order_payment_set
 功能:设置支付明细
 
 @param param
 client_id yes
 order_id yes
 coupon_code no  优惠码
 coupon_pay_money no 优惠券抵扣金额(以元为单位)
 activity_code no  权益卡号
 activity_pay_money no 权益账户抵扣金额
 paymode yes 支付方式:cash.现金支付;confirm.确认支付;wechat.微信支付
 actual_pay_money no  微信支付或现金支付部分
 account_pay_money no 个人账户余额支付部分
 
 */
- (void)orderPaymentSetWithNumberIndex:(int)numberIndex delegte:(id)workThread param:(NSDictionary *)param
{
    
}
@end
