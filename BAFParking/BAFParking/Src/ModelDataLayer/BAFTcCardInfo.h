//
//  BAFTcCardInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/6.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFTcCardInfo : NSObject
//"id": "1",
//"card_no": "123456789987456",
//"password": "",
//"contact_name": "腾讯权益卡",//联系人姓名
//"bind_phone": "18911633129",//联系人手机号
//"status": "normal", //卡状态:'inactive'未激活,'normal'正常,'invalid'无效
//"is_hang": "0",//是否挂失:0.否;1.是
//"begin_time": "2017-01-03 14:04:10",//有效期开始时间
//"end_time": "2017-03-31 14:04:18",//有效期结束时间
//"update_time": "2017-02-21 15:23:27",//最后一次变更时间
//"type_name": "北京泊安飞科技有限公司"//类型
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *card_no;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *contact_name;
@property (nonatomic, strong) NSString *bind_phone;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *is_hang;
@property (nonatomic, strong) NSString *begin_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *update_time;
@property (nonatomic, strong) NSString *type_name;
@end


//code = 200;
//data =     (
//            {
//                "begin_time" = "2016-12-15 15:30:00";
//                "bind_phone" = 18511833913;
//                "card_no" = TXQC19024700017;
//                "contact_name" = "";
//                "end_time" = "2017-12-31 23:59:59";
//                id = 17;
//                "is_hang" = 0;
//                password = 961630;
//                remark = "\U9996\U6b21\U505c\U8f6630\U5929\U5185\U514d\U8d39\Uff0c\U8d85\U51fa30\U5929\U8f66\U4f4d\U8d398\U6298";
//                status = normal;
//                "type_id" = 1;
//                "type_name" = "\U817e\U8baf\U6c7d\U8f66\U4f1a\U5458\U6743\U76ca\U5361";
//                "update_time" = "2017-05-04 16:55:53";
//            }
//            );
//message = ok;
