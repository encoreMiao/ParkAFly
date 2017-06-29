//
//  BAFOrderViewController.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"
//预约内容&id组合
#define OrderParamTypeGoTime            @"plan_park_time"
#define OrderParamTypeTime              @"plan_pick_time"
#define OrderParamTypePark              @"park_id"
#define OrderParamTypeTerminal          @"leave_terminal_id"
#define OrderParamTypeBackTerminal      @"back_terminal_id"
#define OrderParamTypeCompany           @"leave_passenger_number"
#define OrderParamTypeCity              @"city_id"

#define OrderParamTypeParkLocation            @"OrderParamTypeParkLocation"//map_address
#define OrderParamTypeParkFeeFirstDay         @"OrderParamTypeParkFeeFirstDay"//map_charge=>first_day_price
#define OrderParamTypeParkFeeDay              @"OrderParamTypeParkFeeDay"//map_charge=>market_price


typedef NS_ENUM(NSInteger,BAFOrderViewControllerType){
    kBAFOrderViewControllerTypeOrder,
    kBAFOrderViewControllerTypeModifyAll,
    kBAFOrderViewControllerTypeModifyPart,
};

@interface BAFOrderViewController : BAFBaseViewController
@property (nonatomic, strong) NSString                  *cityid;
@property (nonatomic, strong) NSMutableDictionary       *dicDatasource;
@property (nonatomic, assign) BAFOrderViewControllerType type;
@end
