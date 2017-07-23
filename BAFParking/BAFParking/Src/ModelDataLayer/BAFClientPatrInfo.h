//
//  BAFClientPatrInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/5.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFClientPatrInfo : NSObject
//"id": "13",
//"clientid": "1961",
//"orderid": "211",//来源id
//"money": "5000",//交易金额（分为单位）
//"type": "2",//交易状态，1收入，2支出
//"time": "1485279495",//交易时间戳，秒为单位
//"remark": "账户余额支付 50 元.",//备注说明
//"status": "3" //类型:1.充值;2.充值活动;3.账户余额支付;4.充值卡充值
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *clientid;
@property (nonatomic, strong) NSString *orderid;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *status;

@end
