//
//  OrderTableViewCell.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OrderTableViewCellType){
    kOrderTableViewCellTypeGoTime,
    kOrderTableViewCellTypeGoParkTerminal,
    kOrderTableViewCellTypePark,
    kOrderTableViewCellTypeBackTime,
    kOrderTableViewCellTypeBackTerminal,
    kOrderTableViewCellTypeCompany,//同行人数
};

@interface OrderTableViewCell : UITableViewCell
@property (nonatomic, assign) OrderTableViewCellType type;
@end
