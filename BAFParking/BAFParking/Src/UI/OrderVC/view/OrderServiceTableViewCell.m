//
//  OrderServiceTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderServiceTableViewCell.h"

@interface OrderServiceTableViewCell()
@property (assign, nonatomic) BOOL show;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNotitionLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailTextF;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@end

@implementation OrderServiceTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    _show = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    switch (self.type) {
        case kOrderServiceTableViewCellTypeCommon:
            self.detailTextF.hidden = YES;
            self.couponLabel.hidden = NO;
            break;
        case kOrderServiceTableViewCellTypeCommonText:
            self.detailTextF.hidden = NO;
            self.couponLabel.hidden = NO;
            break;
        case kOrderServiceTableViewCellTypeDisclosure:
            self.detailTextF.hidden = YES;
            self.couponLabel.hidden = YES;
            [self.clickButton setImage:[UIImage imageNamed:@"list_ip_more"] forState:UIControlStateNormal];
            [self setFrame:CGRectMake(0, 0, screenWidth, 64)];
            break;
        default:
            break;
    }
}

- (void)setType:(OrderServiceTableViewCellType)type
{
    switch (type) {
        case kOrderServiceTableViewCellTypeCommon:
            
            self.detailTextF.hidden = YES;
            self.couponLabel.hidden = NO;
            break;
        case kOrderServiceTableViewCellTypeCommonText:
            self.serviceTitle.text = @"代驾代泊服务";
            
            self.detailTextF.hidden = NO;
            self.couponLabel.hidden = NO;
            break;
        case kOrderServiceTableViewCellTypeDisclosure:
            self.detailTextF.hidden = YES;
            self.couponLabel.hidden = YES;
            [self.clickButton setImage:[UIImage imageNamed:@"list_ip_more"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (BOOL)isShow
{
    return self.show;
}

- (IBAction)checkButtonClicked:(id)sender {
    _show = !_show;
    if (self.type == kOrderServiceTableViewCellTypeDisclosure) {
        _show = NO;
    }else{
        if(_show){
            [self.clickButton setImage:[UIImage imageNamed:@"list_chb_item"] forState:UIControlStateNormal];
        }else{
            [self.clickButton setImage:[UIImage imageNamed:@"list_chb2_item"] forState:UIControlStateNormal];
        }
    }
}
@end
