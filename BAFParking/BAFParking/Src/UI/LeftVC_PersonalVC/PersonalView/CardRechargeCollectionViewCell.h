//
//  CardRechargeCollectionViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CardRechargeCollectionViewCellType)
{
    kCardRechargeCollectionViewCellTypeCardNumber,//输入卡号
    kCardRechargeCollectionViewCellTypeCode,//输入密码
};

@interface CardRechargeCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) CardRechargeCollectionViewCellType type;
@end
