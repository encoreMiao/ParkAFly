//
//  HRLParkRequest.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "HRLParkRequest.h"

@implementation HRLParkRequest
/**
 api/park/park_list
 功能:停车场列表 请求方法 :GET
 
 @param city_id city_id
 */
- (void)parkListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread city_id:(NSString *)city_id
{
    
}



/**
 api/park/park_service
 功能:停车场单项服务 请求方法 :GET
 
 @param park_id park_id
 */
- (void)parkServiceRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread park_id:(NSString *)park_id
{
    
}




/**
 api/park/park_all_service
 功能:停车场所有服务 请求方法 :GET
 
 @param park_id park_id
 */
- (void)parkAllServiceRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread park_id:(NSString *)park_id
{
    
}



/**
 api/park/map_detail
 功能:停车场详情 请求方法 :GET
 
 @param park_id park_id
 */
- (void)parkMapDetailRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread park_id:(NSString *)park_id
{
    
}


/**
 pi/park/map_comment_list
 功能:停车场评论列表 请求方法 :GET
 
 @param park_id park_id
 */
- (void)parkMapCommentListRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread park_id:(NSString *)park_id
{
    
}


/**
 /api/park/get_air_by_cid
 功能:根据城市获取航站楼 请求方法 :GET
 
 @param city_id city_id
 */
- (void)getAirByCidRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread city_id:(NSString *)city_id
{
    
}



/**
 api/park/get_park_by_aid
 功能:根据航站楼获取停车场 请求方法 :GET
 
 @param air_id air_id
 */
- (void)getParkByAidRequestWithNumberIndex:(int)numberIndex delegte:(id)workThread air_id:(NSString *)air_id
{
    
}

@end
