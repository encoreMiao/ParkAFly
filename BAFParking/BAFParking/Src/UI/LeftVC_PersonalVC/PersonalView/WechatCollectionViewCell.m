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
        if (self.isSelected) {
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz4"];
        }else{
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz2"];
        }
    }
    if (self.type == kWechatCollectionViewCellTypeCommon) {
        if (self.isSelected) {
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz3"];
        }else{
            self.bgImageView.image = [UIImage imageNamed:@"leftbar_account_chongz1"];
        }
    }

}


@end
