//
//  BAFParkCommentInfo.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/9.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFParkCommentInfo : NSObject
//id": "1",
//"order_id": "88",
//"park_id": "20",
//"manager_id": "0", "contact_phone": "18911633129", "score": "5",
//"tags": "服务态度好", "remark": "ouiojkoko", "reply": "",
//"sort": "0",
//"is_show": "1",
//"is_delete": "0",
//"create_time": "2016-12-29 15:29:24",
//"reply_time": "0000-00-00 00:00:00",
//"sort_time": "2016-12-29 15:29:24",
//"avg_star": 5,
//"avg_score": 5,
//"avatar": "/Uploads/user/1961/20170113/avatar_1961302.jpg"
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *park_id;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString *contact_phone;
@property (nonatomic, strong) NSString *manager_id;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *tags;//星级、评分
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *is_show;
@property (nonatomic, strong) NSString *is_delete;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *reply_time;
@property (nonatomic, strong) NSString *sort_time;
@property (nonatomic, strong) NSString *avg_star;//平均星
@property (nonatomic, strong) NSString *avg_score;//平均分
@property (nonatomic, strong) NSString *avatar;// /Uploads/user/1961/20170113/avatar_1961302.jpg"
@end
