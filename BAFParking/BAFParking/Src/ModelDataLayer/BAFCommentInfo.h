//
//  BAFCommentInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/7.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFCommentInfo : NSObject
//"id": "2",
//"order_id": "101",//订单 id
//"park_id": "20",//停车场 id
//"manager_id": "0", //回复车场经理 id
//"contact_phone": "18911633129",  //评论手机号
//"score": "5",//星级、评分
//"tags": "服务态度好",//标签
//"remark": "dddddddd",//评语
//"reply": "",//回复内容
//"sort": "0",//排序
//"is_show": "1",//是否显示:0.否;1.是
//"is_delete": "0", //是否删除:0.否;1.是
//"create_time": "2017-01-13 10:14:50",//评论时间
//"reply_time": "0000-00-00 00:00:00",//回复时间
//"sort_time": "2017-01-13 10:14:50",//排序时间
@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *order_id;
@property (nonatomic, retain) NSString *park_id;
@property (nonatomic, retain) NSString *manager_id;
@property (nonatomic, retain) NSString *contact_phone;
@property (nonatomic, retain) NSString *score;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSString *remark;
@property (nonatomic, retain) NSString *reply;
@property (nonatomic, retain) NSString *sort;
@property (nonatomic, retain) NSString *is_show;
@property (nonatomic, retain) NSString *is_delete;
@property (nonatomic, retain) NSString *create_time;
@property (nonatomic, retain) NSString *reply_time;
@property (nonatomic, retain) NSString *sort_time;

@end
