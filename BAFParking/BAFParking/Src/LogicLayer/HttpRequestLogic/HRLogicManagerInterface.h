//
//  HRLogicManagerInterface.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HRLogicManagerInterface <NSObject>
@required

/**
 *	@brief	程序启动时调用:统一加载
 */
-(void)load;

/**
 *	@brief	模块加载用户数据,模块需根据userId加载相关信息
 */
-(void)loadUserData;

/**
 *	@brief	统一存储
 */
-(void)save;

/**
 *	@brief	重置模块数据
 *          [注意:]此方法在点击失败时会调用
 */
-(void) reset;

/*
 *  @brief  前台进入后台
 */
-(void) enterBackground;

/*
 *  @brief  从后台进入前台
 */
-(void) enterForeground;
@end
