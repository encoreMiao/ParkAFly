//
//  OrderDetailStatusTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/9.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderDetailStatusTableViewCell.h"

@interface OrderDetailStatusTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *orderOperatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation OrderDetailStatusTableViewCell
//65
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
