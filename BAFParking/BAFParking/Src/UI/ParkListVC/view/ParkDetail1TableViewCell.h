//
//  ParkDetail1TableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFParkInfo.h"

@interface ParkDetail1TableViewCell : UITableViewCell
@property (nonatomic, retain) BAFParkInfo *parkDetailInfo;
@property (nonatomic, retain) NSArray *parkCommentList;
@end
