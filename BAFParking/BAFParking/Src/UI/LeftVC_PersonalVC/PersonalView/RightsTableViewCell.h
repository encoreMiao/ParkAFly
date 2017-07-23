//
//  RightsTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFEquityAccountInfo.h"
@class RightsTableViewCell;

@protocol RightsTableViewCellDelegate <NSObject>
- (void)useNotiActionDelegate:(RightsTableViewCell *)cell;
@end

@interface RightsTableViewCell : UITableViewCell
@property (nonatomic, retain) BAFEquityAccountInfo *accountInfo;
@property (nonatomic, assign) id<RightsTableViewCellDelegate> delegate;
@end
