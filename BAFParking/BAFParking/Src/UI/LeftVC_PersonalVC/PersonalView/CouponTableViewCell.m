//
//  CouponTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CouponTableViewCell.h"

@interface CouponTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *validateDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@end



@implementation CouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (_type) {
        case kCouponTableViewCellTypeCommonCell1:
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg"];
            self.selectButton.hidden = YES;
            break;
        case kCouponTableViewCellTypeCommonCell2:
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg3"];
            self.selectButton.hidden = YES;
            break;
        case kCouponTableViewCellTypeCommonCell3:
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg2"];
            self.selectButton.hidden = YES;
            break;
            
            
        case kCouponViewControllerTypeUseCell1:
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg"];
            self.selectButton.hidden = NO;
            break;
        case kCouponViewControllerTypeUseCell2:
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg"];
            self.selectButton.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)setType:(CouponTableViewCellType)type
{
    _type = type;
//    //查看优惠券
//    kCouponTableViewCellTypeCommonCell1,//未使用
//    kCouponTableViewCellTypeCommonCell2,//已使用
//    kCouponTableViewCellTypeCommonCell3,//已过期
//    
//    //使用优惠券
//    kCouponViewControllerTypeUseCell1,//可用
//    kCouponViewControllerTypeUseCell2,//不可用
//
}

- (void)setCouponInfo:(BAFCouponInfo *)couponInfo
{
    _couponInfo = couponInfo;
    
}

- (IBAction)detailAction:(id)sender
{
    
}

@end
