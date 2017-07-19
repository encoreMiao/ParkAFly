//
//  OrderDetailFeeTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderDetailFeeTableViewCell.h"

@interface OrderDetailFeeTableViewCell()

@end

@implementation OrderDetailFeeTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setType:(OrderDetailFeeTableViewCellType)type
{
    _type = type;
    switch (_type) {
        case OrderDetailFeeTableViewCellTypeService:
            self.detailImg.hidden = YES;
            self.detailLabel.hidden = YES;
            break;
        case OrderDetailFeeTableViewCellTypeTotalFee:
            self.detailImg.hidden = NO;
            self.detailLabel.hidden = NO;
        default:
            break;
    }
}

@end
