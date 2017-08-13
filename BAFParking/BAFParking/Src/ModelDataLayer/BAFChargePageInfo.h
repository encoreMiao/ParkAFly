//
//  BAFChargePageInfo.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFChargePageInfo : NSObject
@end


@interface BAFChargePageActivityInfo : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *starttime;
@property (nonatomic, strong) NSString *endtime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *descriptionOfActivity;
@end


@interface BAFChargePageRechargeInfo : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *giftmoney;
@property (nonatomic, strong) NSString *activityid;
@property (nonatomic, strong) NSString *pay_money;
@property (nonatomic, strong) NSString *discount;
@end
