//
//  OrderServiceTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderServiceTableViewCell.h"

@interface OrderServiceTableViewCell()
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
            self.moreServiceView.hidden = YES;
            break;
        case kOrderServiceTableViewCellTypeCommonText:
            if (_show) {
                self.detailTextF.hidden = NO;
            }else{
                self.detailTextF.hidden = YES;
            }
            self.couponLabel.hidden = NO;
            self.moreServiceView.hidden = YES;
            break;
        case kOrderServiceTableViewCellTypeDisclosure:
            self.detailTextF.hidden = YES;
            self.couponLabel.hidden = YES;
            self.serviceTitle.text = @"更多服务";
            self.serviceNotitionLabel.text = @"提供代加油、洗车服务等";
            [self.clickButton setImage:[UIImage imageNamed:@"list_ip_more"] forState:UIControlStateNormal];
            self.moreServiceView.hidden = YES;
            break;
        case kOrderServiceTableViewCellTypeMore:
            self.detailTextF.hidden = YES;
            self.couponLabel.hidden = YES;
            self.serviceTitle.text = @"更多服务";
            self.serviceNotitionLabel.hidden = YES;
            [self.clickButton setImage:[UIImage imageNamed:@"list_ip_more"] forState:UIControlStateNormal];
            self.moreServiceView.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setType:(OrderServiceTableViewCellType)type
{
    _type = type;
}

- (void)setServiceInfo:(BAFParkServiceInfo *)serviceInfo
{
    _serviceInfo = serviceInfo;
    self.serviceTitle.text = serviceInfo.title;
    self.serviceNotitionLabel.text = serviceInfo.remark;
    if (self.type == kOrderServiceTableViewCellTypeCommon) {
        self.couponLabel.text = [NSString stringWithFormat:@"立减%ld元",serviceInfo.strike_price.integerValue/100];
    }else{
        self.couponLabel.text = [NSString stringWithFormat:@"%ld元",serviceInfo.strike_price.integerValue/100];
    }
}

- (void)setShow:(BOOL)show
{
    _show = show;
    if (_show) {
        [self.clickButton setImage:[UIImage imageNamed:@"list_chb_item"] forState:UIControlStateNormal];
    }
    else{
        [self.clickButton setImage:[UIImage imageNamed:@"list_chb2_item"] forState:UIControlStateNormal];
    }
}

- (IBAction)checkButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(OrderServiceTableViewCellAction:)]) {
        [self.delegate OrderServiceTableViewCellAction:self];
    }
}

- (NSString *)parkflyno
{
    if (self.detailTextF.hidden == NO && self.detailTextF.text.length !=0) {
        return self.detailTextF.text;
    }
    return nil;
}

- (void)setParkflyno:(NSString *)parkflyno
{
    self.detailTextF.text = parkflyno;
    [self.detailTextF resignFirstResponder];
}
@end
