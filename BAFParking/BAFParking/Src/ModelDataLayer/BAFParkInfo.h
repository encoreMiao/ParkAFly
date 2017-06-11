//
//  BAFParkInfo.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/10.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAFParkAir.h"
#import "BAFParkCharge.h"

@interface BAFParkInfo : NSObject
@property (nonatomic, strong) BAFParkAir *map_air;
@property (nonatomic, strong) BAFParkCharge *map_charge;
@property (nonatomic, strong) NSString *car_wash_description;
@property (nonatomic, strong) NSString *fuel_description;
@property (nonatomic, strong) NSString *map_address;
@property (nonatomic, strong) NSString *map_carport;
@property (nonatomic, strong) NSString *map_city;
@property (nonatomic, strong) NSString *map_content;
@property (nonatomic, strong) NSString *map_creattime;
@property (nonatomic, strong) NSString *map_id;
@property (nonatomic, strong) NSString *map_is_show;
@property (nonatomic, strong) NSString *map_lat;
@property (nonatomic, strong) NSString *map_lon;
@property (nonatomic, strong) NSString *map_manager;
@property (nonatomic, strong) NSString *map_phone;
@property (nonatomic, strong) NSString *map_pic;
@property (nonatomic, strong) NSString *map_price;
@property (nonatomic, strong) NSString *map_remain_stay;
@property (nonatomic, strong) NSString *map_sort;
@property (nonatomic, strong) NSString *map_standby_phone;
@property (nonatomic, strong) NSString *map_start;
@property (nonatomic, strong) NSString *map_task;
@property (nonatomic, strong) NSString *map_time;
@property (nonatomic, strong) NSString *map_title;
@property (nonatomic, strong) NSString *store_ctrip;
@property (nonatomic, strong) NSString *store_ly;
@property (nonatomic, strong) NSString *store_self;
@property (nonatomic, strong) NSString *store_xqpark;
@end
