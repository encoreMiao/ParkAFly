//
//  ServiceConfirmTableViewCell.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceConfirmTableViewCell;

@protocol ServiceConfirmTableViewCellDelegate <NSObject>
- (void)closeBtnActionDelegate:(ServiceConfirmTableViewCell *)cell;
@end

@interface ServiceConfirmTableViewCell : UITableViewCell
@property (nonatomic, assign) id<ServiceConfirmTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSString *serviceStr;
@end
