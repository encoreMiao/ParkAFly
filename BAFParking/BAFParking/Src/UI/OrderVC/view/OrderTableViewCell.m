//
//  OrderTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderTableViewCell.h"

@interface OrderTableViewCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *orderTypeImageView;
@property (weak, nonatomic) IBOutlet UITextField *orderTF;
@end

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.orderTF.delegate = self;
    [self.orderTF addTarget:self action:@selector(orderCellClicked:) forControlEvents:UIControlEventTouchDown];
    self.orderTF.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrderTFText:(NSString *)tfstr
{
    [self.orderTF resignFirstResponder];
    self.orderTF.text = tfstr;
}

- (void)setType:(OrderTableViewCellType)type
{
    _type = type;
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
            self.orderTF.placeholder = @"请选择同行人数";
            break;
    }
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (void)orderCellClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(orderCellClickedDelegate:)]) {
        [self.delegate orderCellClickedDelegate:self];
    }
}

@end
