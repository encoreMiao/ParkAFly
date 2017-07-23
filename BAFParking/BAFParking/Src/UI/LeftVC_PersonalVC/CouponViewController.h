//
//  CouponViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"
#import "BAFCouponInfo.h"

typedef NS_ENUM(NSInteger,CouponViewControllerType){
    kCouponViewControllerTypeCommon,
    kCouponViewControllerTypeUse,
};

typedef void (^couponselectHandler) (BAFCouponInfo *coponinfo);


@interface CouponViewController : BAFBaseViewController
@property (nonatomic, assign) CouponViewControllerType type;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, copy) couponselectHandler handler;
@property (nonatomic, strong) BAFCouponInfo *selectCouponInfo;
@end
