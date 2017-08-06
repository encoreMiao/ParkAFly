//
//  CouponTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CouponTableViewCell.h"
#import "UIColor+HexColor.h"

@interface CouponTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *validateDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (assign, nonatomic) BOOL isCouponSelected;
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
            //灰色
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg3"];
            self.selectButton.hidden = YES;
            self.couponLabel.textColor = [UIColor colorWithHex:0x969696];
            self.couponDetailLabel.textColor = [UIColor colorWithHex:0x969696];
            self.validateDateLabel.textColor = [UIColor colorWithHex:0x969696];
            self.detailBtn.hidden =YES;
            break;
        case kCouponTableViewCellTypeCommonCell3:
            //灰色
            self.couponLabel.textColor = [UIColor colorWithHex:0x969696];
            self.couponDetailLabel.textColor = [UIColor colorWithHex:0x969696];
            self.validateDateLabel.textColor = [UIColor colorWithHex:0x969696];
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg2"];
            self.detailBtn.hidden = YES;
            self.selectButton.hidden = YES;
            break;
            
            
        case kCouponViewControllerTypeUseCell1:
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg"];
            self.selectButton.hidden = NO;
            break;
        case kCouponViewControllerTypeUseCell2:
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_youhuiq_bg4"];
            self.couponLabel.textColor = [UIColor colorWithHex:0x969696];
            self.couponDetailLabel.textColor = [UIColor colorWithHex:0x969696];
            self.validateDateLabel.textColor = [UIColor colorWithHex:0x969696];
            self.selectButton.hidden = YES;
            self.detailBtn.hidden = YES;
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
    NSString *str = [NSString stringWithFormat:@"%@\n%@",couponInfo.number,couponInfo.info];
    NSMutableAttributedString *mutAttributeStr = [[NSMutableAttributedString alloc]initWithString:str];
    [mutAttributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x323232],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[str rangeOfString:couponInfo.number]];
    [mutAttributeStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x323232],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:[str rangeOfString:couponInfo.info]];
    self.couponDetailLabel.attributedText = mutAttributeStr;
    
    
    NSString *price = [NSString stringWithFormat:@"%ld",couponInfo.price.integerValue/100];
    NSString *pricestr = [NSString stringWithFormat:@"¥%@",price];
    NSMutableAttributedString *mutpriceStr = [[NSMutableAttributedString alloc]initWithString:pricestr];
    [mutpriceStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:21]} range:[pricestr rangeOfString:@"¥"]];
    [mutpriceStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFB694B],NSFontAttributeName:[UIFont systemFontOfSize:43]} range:[pricestr rangeOfString:price]];
    self.couponLabel.attributedText = mutpriceStr;
    
    
    self.validateDateLabel.text = [NSString stringWithFormat:@"有效期：%@ - %@",[self getTimeWithTime:couponInfo.starttime],[self getTimeWithTime:couponInfo.endtime]];
    
}

-(NSString*)getTimeWithTime:(NSString *)timeStr
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSTimeInterval interval = timeStr.doubleValue;
    // 毫秒值转化为秒
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

- (IBAction)detailAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(detailActionDelegate:)]) {
        [self.delegate detailActionDelegate:self];
    }
}

- (void)setCouponSelected:(BOOL)selected
{
    _isCouponSelected = selected;
    switch (_type) {
        case kCouponViewControllerTypeUseCell1:
        {
             self.selectButton.selected = selected;
        }
            break;
        default:
            break;
    }
}

- (BOOL)couponSelected
{
    return _isCouponSelected;
}
- (IBAction)selectAction:(id)sender {
    switch (_type) {
        case kCouponViewControllerTypeUseCell1:
        {
            if ([self.delegate respondsToSelector:@selector(selectActionDelegate:)]) {
                [self.delegate selectActionDelegate:self];
            }
        }
            break;
        default:
            break;
    }
}

@end
