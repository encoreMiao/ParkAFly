//
//  ParkListTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/11.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFParkInfo.h"
@class ParkListTableViewCell;

typedef NS_ENUM(NSInteger, ParkListTableViewCellActionType) {
    kParkListTableViewCellActionTypeOrder,
    kParkListTableViewCellActionTypeSelect,
    kParkListTableViewCellActionTypeLocation,
    kParkListTableViewCellActionTypeDetails,
};


typedef NS_ENUM(NSInteger, ParkListTableViewCellType) {
    kParkListTableViewCellTypeShow,
    kParkListTableViewCellTypeSelect,
};

@protocol ParkListTableViewCellDelegate <NSObject>
- (void)ParkListTableViewCellActionDelegate:(ParkListTableViewCell *)cell actionType:(ParkListTableViewCellActionType)actionType;
@end

@interface ParkListTableViewCell : UITableViewCell
@property (nonatomic, assign) id<ParkListTableViewCellDelegate> delegate;
- (void)setParkinfo:(BAFParkInfo *)parkinfo withtype:(ParkListTableViewCellType)type;
@end
