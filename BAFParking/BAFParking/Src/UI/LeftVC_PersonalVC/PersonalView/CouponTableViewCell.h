//
//  CouponTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CouponTableViewCellType){
    //查看优惠券
    kCouponTableViewCellTypeCommonCell1,//未使用
    kCouponTableViewCellTypeCommonCell2,//已使用
    kCouponTableViewCellTypeCommonCell3,//已过期
    
    //使用优惠券
    kCouponViewControllerTypeUseCell1,//可用
    kCouponViewControllerTypeUseCell2,//不可用
};

@interface CouponTableViewCell : UITableViewCell
@property (assign, nonatomic) CouponTableViewCellType type;
@end
