//
//  OrderServiceTableViewCell.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OrderServiceTableViewCellType){
    kOrderServiceTableViewCellTypeCommon,
    kOrderServiceTableViewCellTypeCommonText,
    kOrderServiceTableViewCellTypeDisclosure,
};

@interface OrderServiceTableViewCell : UITableViewCell
@property (nonatomic, assign) OrderServiceTableViewCellType type;
- (BOOL)isShow;
@end
