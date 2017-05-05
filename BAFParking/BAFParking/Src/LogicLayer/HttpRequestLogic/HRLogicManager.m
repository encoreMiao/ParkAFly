//
//  HRLogicManager.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "HRLogicManager.h"
#import "HRLLoginRequest.h"
#import "HRLPersonalCenterRequest.h"
#import "HRLOrderRequest.h"
#import "HRLParkRequest.h"

@interface HRLogicManager ()
@property (nonatomic, strong) HRLLoginRequest *loginRequest;
@property (nonatomic, strong) HRLPersonalCenterRequest *personalCenterRequest;
@property (nonatomic, strong) HRLOrderRequest *orderRequest;
@property (nonatomic, strong) HRLParkRequest *parkRequest;
@end

@implementation HRLogicManager
+(id)sharedInstance
{
    static HRLogicManager * _sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HRLogicManager alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        _loginRequest = [[HRLLoginRequest alloc] init];
        _personalCenterRequest = [[HRLPersonalCenterRequest alloc]init];
        _orderRequest = [[HRLOrderRequest alloc] init];
        _parkRequest = [[HRLParkRequest alloc]init];
    }
    
    return self;
}

/**
 *	@brief	程序启动时调用:统一加载
 */
-(void)load;
{
   // [_userModel load];
}

/**
 *	@brief	模块加载用户数据,模块需根据userId加载相关信息
 */
-(void)loadUserData
{
    
}

/**
 *	@brief	统一存储
 */
-(void)save
{
    
}

/**
 *	@brief	重置模块数据
 *          [注意:]此方法在点击失败时会调用
 */
-(void) reset
{
    
}

/*
 *  @brief  前台进入后台
 */
-(void) enterBackground
{
    //    [_lookHouseNoteModel enterBackground];
    //    [_statisticModel enterBackground];
}

/*
 *  @brief  从后台进入前台
 */
-(void) enterForeground
{
    
    //    [_lookHouseNoteModel enterForeground];
}

/**
 *  登陆
 *  @return 登陆request
 */
- (id <HRLLoginInterface>)getLoginReqest{
    return _loginRequest;
}
- (id <HRLPersonalCenterInterface>)getPersonalCenterReqest{
    return _personalCenterRequest;
}
- (id <HRLParkInterface>)getParkReqest
{
    return _parkRequest;
}
- (id <HRLOrderInterface>)getOrderReqest
{
    return _orderRequest;
}
@end
