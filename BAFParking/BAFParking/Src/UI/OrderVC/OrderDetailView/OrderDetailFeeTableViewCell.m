//
//  OrderDetailFeeTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderDetailFeeTableViewCell.h"

@interface OrderDetailFeeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *serviceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImg;
@end

@implementation OrderDetailFeeTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
