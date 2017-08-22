//
//  WechatCollectionViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "WechatCollectionViewCell.h"

@interface WechatCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (assign, nonatomic) BOOL isWechatSelected;
@end


@implementation WechatCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
//    self.backgroundColor = [UIColor clearColor];
}
- (void)setType:(WechatCollectionViewCellType)type
{
    _type = type;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.type == kWechatCollectionViewCellTypeActivity) {
        if (self.isWechatSelected) {
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz4"];
        }else{
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz2"];
        }
    }
    if (self.type == kWechatCollectionViewCellTypeCommon) {
        if (self.isWechatSelected) {
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz3"];
        }else{
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz1"];
        }
    }

}

- (void)setCollectionSelected:(BOOL)selected
{
    _isWechatSelected = selected;
    if (self.type == kWechatCollectionViewCellTypeActivity) {
        if (self.isWechatSelected) {
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz4"];
        }else{
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz2"];
        }
    }
    if (self.type == kWechatCollectionViewCellTypeCommon) {
        if (self.isWechatSelected) {
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz3"];
        }else{
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz1"];
        }
    }
}

- (void)setChargeInfo:(BAFChargeInfo *)chargeInfo
{
    _chargeInfo = chargeInfo;
     if (self.type == kWechatCollectionViewCellTypeActivity) {
         NSString *str = [NSString stringWithFormat:@"充%0.f元\n赠%0.f元",chargeInfo.money.integerValue/100.0f,chargeInfo.giftmoney.integerValue/100.0f];
         NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
         [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[str rangeOfString:@"充"]];
         [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[str rangeOfString:@"赠"]];
         self.chargeLabel.attributedText = mutStr;
     }else{
         if ([_chargeInfo.discount isEqualToString:@""]||[_chargeInfo.discount isEqual:[NSNull null]]) {
             NSString *str = [NSString stringWithFormat:@"%0.f元",chargeInfo.money.integerValue/100.0f];
             self.chargeLabel.text = str;
         }else{
             NSString *str = [NSString stringWithFormat:@"%0.f元\n%.1f折",chargeInfo.money.integerValue/100.0f,_chargeInfo.discount.integerValue/10.0f];
             NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
             [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[str rangeOfString:[NSString stringWithFormat:@"%.1f折",_chargeInfo.discount.integerValue/10.0f]]];
             self.chargeLabel.attributedText = mutStr;
         }
         
     }
}
@end
