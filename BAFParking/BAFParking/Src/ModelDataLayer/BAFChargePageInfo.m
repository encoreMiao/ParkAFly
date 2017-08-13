//
//  BAFChargePageInfo.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFChargePageInfo.h"

@implementation BAFChargePageInfo
@end

@implementation BAFChargePageRechargeInfo
@end

@implementation BAFChargePageActivityInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"descriptionOfActivity" : @"description",
             };
}
@end
