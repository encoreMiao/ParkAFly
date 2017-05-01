//
//  HRLogicManager.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HRLLoginInterface;

@interface HRLogicManager : NSObject
/**
 *	@brief	创建管理单例
 *
 */
+(id)sharedInstance;

/*
 *  @brief  前台进入后台
 */
-(void) enterBackground;

/*
 *  @brief  从后台进入前台
 */
-(void) enterForeground;

/**
 *  登陆模块
 *
 */

-(id<HRLLoginInterface>)getLoginReqest;


@end
