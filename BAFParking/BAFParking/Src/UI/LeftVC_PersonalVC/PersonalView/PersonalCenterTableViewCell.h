//
//  PersonalCenterTableViewCell.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PersonalCellImgString       @"PersonalCellImgString"
#define PersonalcellTitleString     @"PersonalcellTitleString"
#define PersonalCellType            @"PersonalCellType"

typedef NS_ENUM(NSInteger,PersonalCenterCellType){
    kPersonalCenterCellTypePersonalAccount,//个人账户
    kPersonalCenterCellTypeCompanyAcount,//企业账户
    kPersonalCenterCellTypeRightAccount,//权益账户
    kPersonalCenterCellTypeCoupon,//优惠券
    kPersonalCenterCellTypeOrder,//订单
    kPersonalCenterCellTypeShare,//分享
    kPersonalCenterCellTypeFeedBack,//反馈
};

@interface PersonalCenterTableViewCell : UITableViewCell
- (void)setPersonalCenterCellWithDic:(NSDictionary *)dic;
@end
