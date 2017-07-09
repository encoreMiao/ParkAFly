//
//  BAFChargeInfo.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/9.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFChargeInfo : NSObject
//activityid = 0;
//discount = 100;
//giftmoney = 0;
//id = 4;
//money = 1;
//"pay_money" = 1;
//sort = 0;
//status = 0;
//title = "0.03";
@property (nonatomic, strong) NSString *activityid;
@property (nonatomic, strong) NSString *discount;
@property (nonatomic, strong) NSString *giftmoney;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSString *pay_money;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *title;
@end
