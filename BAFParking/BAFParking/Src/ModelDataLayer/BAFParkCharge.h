//
//  BAFParkCharge.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/11.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFParkCharge : NSObject
@property (nonatomic, strong) NSString *charge_id;
@property (nonatomic, strong) NSString *chargetype;
@property (nonatomic, strong) NSString *first_day_price;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *limit_days;
@property (nonatomic, strong) NSString *limit_price;
@property (nonatomic, strong) NSString *map_id;
@property (nonatomic, strong) NSString *market_price;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *strike_price;
@property (nonatomic, strong) NSString *type;
@end
