//
//  BAFCityInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/6.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

//"id": "1",
//"title": "北京",//城市名称
//"nums": "010",//编号
//"sort": "0",//排序(同级有效)
//"hide": "0",//是否隐藏:0.否;1.是
//"selfservice": "1",
//"replaceservice": "1",
//"close": "0"//是否关闭服务，0 不关闭，1 关闭


@interface BAFCityInfo : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *nums;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *hide;
@property (nonatomic, strong) NSString *selfservice;
@property (nonatomic, strong) NSString *replaceservice;
@property (nonatomic, strong) NSString *close;
@end
