//
//  MoreServicesTableViewCell.h
//  BAFParking
//
//  Created by mengmeng on 2017/6/13.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFParkServiceInfo.h"
@class MoreServicesTableViewCell;

@protocol MoreServicesTableViewCellDelegate <NSObject>
- (void)moreServiceTableViewCellAction:(MoreServicesTableViewCell *)tableviewCell;
- (void)fuelSelectedAction:(MoreServicesTableViewCell *)tableviewCell;
@end

typedef NS_ENUM(NSInteger, MoreServicesTableViewCellType)
{
    kMoreServicesTableViewCellType204,//代加油
    KMoreServicesTableViewCellType205,
};
@interface MoreServicesTableViewCell : UITableViewCell
@property (nonatomic, assign) MoreServicesTableViewCellType type;
@property (nonatomic, assign) BOOL  show;
@property (nonatomic, strong) NSString *fuelStr;
@property (nonatomic, strong) BAFParkServiceInfo *serviceInfo;
@property (nonatomic, assign) id<MoreServicesTableViewCellDelegate> delegate;
- (void)setServiceInfo:(BAFParkServiceInfo *)serviceInfo andDescription:(NSString *)description;
@end
