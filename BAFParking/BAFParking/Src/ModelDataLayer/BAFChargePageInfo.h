//
//  BAFChargePageInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFChargePageInfo : NSObject

@end


@interface BAFChargePageActivityInfo : NSObject
//活动名称 //有效期开始时间 //有效期结束时间 //状态:0.禁用;1.启用 //活动说明
//"id": "1",
//"name": "充 100 送 50",
//"starttime": "1473264000",
//"endtime": "1493481599",
//"status": "1",
//"description": "国庆活动
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *description;


@end
//activity 列表内容
//                    {
//                        description = "\U6d4b\U8bd5\U6362\U884c\Uff1a
//                        \n1.\U554a\U554a\U554a\U554a\U554a\U554a\U554a\U3002
//                        \n2.\U5575\U5575\U5575\U5575\U5575\U5575\U5575\U3002";
//                        endtime = 1494604799;
//                        id = 1;
//                        name = "\U6d4b\U8bd5";
//                        starttime = 1483891200;
//                        status = 1;
//                    }
//                    );

@interface BAFChargePageRechargeInfo : NSObject
//"id": "1",
//"title": "测试",
//"money": "10000",
//"sort": "1",
//"status": "0",
//"giftmoney": "5000",
//"activityid": "1",
//"pay_money": 0,//支付金额
//"discount":"92"//折扣率(百分数 92%)
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *giftmoney;
@property (nonatomic, strong) NSString *activityid;
@property (nonatomic, strong) NSString *pay_money;
@property (nonatomic, strong) NSString *discount;
@end
//rechargelist 列表内容
//{
//    activityid = 1;
//    discount = "";
//    giftmoney = 2974;
//    id = 4;
//    money = 1;
//    "pay_money" = 1;
//    sort = 0;
//    status = 0;
//    title = "0.03";
//},
