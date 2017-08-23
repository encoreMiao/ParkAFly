//
//  SuccessViewController.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/30.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFBaseViewController.h"

typedef NS_ENUM(NSInteger,SuccessViewControllerType){
    kSuccessViewControllerTypeSuccess,
    kSuccessViewControllerTypeFailure,
    kSuccessViewControllerTypePay,
    kSuccessViewControllerTypeRechargeSuccess,
};


@interface SuccessViewController : BAFBaseViewController    
@property (nonatomic, assign) SuccessViewControllerType type;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *rechargeMoneyStr;//充值金额
@property (nonatomic, strong) NSString *rechargeTimeStr;//充值时间、

@property (nonatomic, assign) BOOL isEdit;//是否是修改
@end
