//
//  OrderTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImageView;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;
@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setType:(OrderTableViewCellType)type
{
    switch (type) {
        case kOrderTableViewCellTypeGoTime:
            self.orderTypeImageView.image = [UIImage imageNamed:@"list_ip_time1"];
            self.orderTF.placeholder = @"请选择泊车时间";
            break;
        case kOrderTableViewCellTypeGoParkTerminal:
            self.orderTypeImageView.image = [UIImage imageNamed:@"list_ip_set"];
            self.orderTF.placeholder = @"请选择出发航站楼";
            break;
        case kOrderTableViewCellTypePark:
            self.orderTypeImageView.image = [UIImage imageNamed:@"list_ip_parking"];
            self.orderTF.placeholder = @"请选择停车场";
            break;
        case kOrderTableViewCellTypeBackTime:
            self.orderTypeImageView.image = [UIImage imageNamed:@"list_ip_time2"];
            self.orderTF.placeholder = @"请选择取车时间(可留空)";
            break;
        case kOrderTableViewCellTypeBackTerminal:
            self.orderTypeImageView.image = [UIImage imageNamed:@"list_ip_back"];
            self.orderTF.placeholder = @"请选择返程航站楼";
            break;
        case kOrderTableViewCellTypeCompany:
            self.orderTypeImageView.image = [UIImage imageNamed:@"list_ip_tongx"];
            self.orderTF.placeholder = @"请选择通行人数";
            break;
    }
}

@end
