//
//  MoreServicesTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/6/13.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "MoreServicesTableViewCell.h"

@interface MoreServicesTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *serviceIcon;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNotitionLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (weak, nonatomic) IBOutlet UIView *gastypeview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationTopConstraint;

@end

@implementation MoreServicesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codeí
    
    [self.clickButton setImage:[UIImage imageNamed:@"list_chb2_item"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setServiceInfo:(BAFParkServiceInfo *)serviceInfo
{
    _serviceInfo = serviceInfo;
    self.serviceTitle.text = serviceInfo.title;
    self.serviceNotitionLabel.text = serviceInfo.remark;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.type) {
        case kMoreServicesTableViewCellType204:
            self.gastypeview.hidden = NO;
            
            break;
        case KMoreServicesTableViewCellType205:
            self.gastypeview.hidden = YES;
            self.notificationTopConstraint.constant -=30;
            break;
        default:
            break;
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
    if ([self.delegate respondsToSelector:@selector(moreServiceTableViewCellAction:)]) {
        [self.delegate moreServiceTableViewCellAction:self];
    }
}
@end
