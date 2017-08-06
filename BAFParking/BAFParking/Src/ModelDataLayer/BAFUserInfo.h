//
//  BAFUserInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFUserInfo : NSObject <NSCoding>
@property (nonatomic, strong) NSString *clientid;
@property (nonatomic, strong) NSString *ctel;
@property (nonatomic, strong) NSString *cname;
@property (nonatomic, strong) NSString *csex;//0.未知，1.男，2 女
@property (nonatomic, strong) NSString *carnum;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *wechat_id;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *caddr;
@property (nonatomic, strong) NSString *ctype;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *cardid;
@property (nonatomic, strong) NSString *did;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *brand;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSString *city_name;

@property (nonatomic, strong) NSString *level_id;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *endtime;

@end
//code = 200;
//data =     {
//    client =         {
//        account = 0;
//        avatar = "";
//        brand = "";
//        caddr = 1;
//        cardid = "<null>";
//        carnum = "";
//        cityname = "\U5317\U4eac";
//        clientid = 7296;
//        cname = "";
//        color = "";
//        createtime = 1493877782;
//        csex = 0;
//        ctel = 18511833913;
//        ctype = 1;
//        did = "<null>";
//        endtime = "<null>";
//        "is_bind_yearcard" = 0;
//        "is_send_coupon" = 0;
//        "level_id" = 1;
//        password = 488d72933f722163aacac8626fa296e3;
//        starttime = "<null>";
//        status = 0;
//        "wechat_id" = "";
//    };
//    token = YmxnbXJLUTY1bHJ2UzByTFRkQ0REaDByTlNXL0lZK1JqZEFrL3BzZkpDMkdDNkd0ZHZTVFpiNTM4QjgwODI2bmpGWXpYZWZSaDhjbm1ReFoxQUNWQ2V2UE1CcDhqREJqRmQyQ0ZpMnUwZ2M9;
//};
//message = ok;

//"client": {
//    "clientid": "1961",
//    "ctel": "18911633129",
//    "cname": "吕测试",
//    "csex": "1", //用户性别(0.未知，1.男，2 女)
//    "carnum": "京 A12349", //车牌号
//    "createtime": "1459561755",
//    "wechat_id": "oJmLFt5lIEEi-tStIFO6ACgeGB88",
//    "status": "0",
//    "avatar": "", //头像地址
//    "caddr": "1", //常驻城市 id
//    "ctype": "1",
//    "password": "96e79218965eb72c92a549dd5a330112",
//    "cardid": null,
//    "did": null,
//    "account": "32800",//账户余额以分为单位
//    "brand": "", //品牌
//    "color": "", //颜色
//    "cityname": "北京"
//    "level_id": "2", //会员等级:1.普通会员;2.金牌会员;3.钻石会员
//    "starttime": "2017-04-12 00:00:00", //开始时间
//    "endtime": "2017-04-13 23:59:59", //结束时间
//},
