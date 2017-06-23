//
//  BAFOrderServiceViewController.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"

#define OrderParamTypeContact_name      @"contact_name"
#define OrderParamTypeContact_gender    @"contact_gender"
#define OrderParamTypeContact_phone     @"contact_phone"
#define OrderParamTypeCar_license_no    @"car_license_no"
#define OrderParamTypeBack_flight_no    @"back_flight_no"
#define OrderParamTypePetrol            @"petrol"
#define OrderParamTypeService           @"service"//收费项 id=>备注，如汽油 6=>92#
#define OrderParamTypePark_day          @"park_day"

@interface BAFOrderServiceViewController : BAFBaseViewController
@end
