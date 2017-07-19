//
//  OrderDetailFeeTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OrderDetailFeeTableViewCellType){
    OrderDetailFeeTableViewCellTypeTotalFee,
    OrderDetailFeeTableViewCellTypeService,
};

@interface OrderDetailFeeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImg;
@property (assign, nonatomic) OrderDetailFeeTableViewCellType type;
@end
