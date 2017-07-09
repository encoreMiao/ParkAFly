//
//  WechatCollectionViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFChargeInfo.h"

typedef NS_ENUM(NSInteger,WechatCollectionViewCellType)
{
    kWechatCollectionViewCellTypeActivity,//活动
    kWechatCollectionViewCellTypeCommon,//正常
};

@interface WechatCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) WechatCollectionViewCellType type;
@property (nonatomic, strong) BAFChargeInfo *chargeInfo;

- (void)setCollectionSelected:(BOOL)selected;

@end
