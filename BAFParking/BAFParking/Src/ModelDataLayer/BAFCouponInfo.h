//
//  BAFCouponInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/7.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFCouponInfo : NSObject
//clientid 客户id
//ctime //下单时间

//"prid": "106",//优惠券分类 id
//"prtitle": "泊安飞机场停车 100 元代金券",//优惠码名称
//"starttime": "1480953600",//有效期起始时间
//"endtime": "1493567999",//有效期结束时间
//"prnum": "30",
//"price": "10000",购买价格
//"salenum": "8",
//"status": "1",
//"info": "抢车位",//描述
//"calprice": "10000",//计算价格
//"logo": "/Uploads/Picture/2016-04-08/57075bcc83ed0.png",
//"proid": "31579",//优惠券 id
//"number": "792376712075",//优惠码
//"issale": "2",//1.未售出;2.已售出
//"usetime": null,
//"isbind": "2"//1 未绑定，2 已绑定

@property (nonatomic, strong) NSString *clientid;
@property (nonatomic, strong) NSString *ctime;

@property (nonatomic, strong) NSString *prid;
@property (nonatomic, strong) NSString *prtitle;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *prnum;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *salenum;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *calprice;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *proid;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *issale;
@property (nonatomic, strong) NSString *usetime;
@property (nonatomic, strong) NSString *isbind;
@end
