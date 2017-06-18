//
//  CardRechargeCollectionViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CardRechargeCollectionViewCell.h"

@interface CardRechargeCollectionViewCell()
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@end


@implementation CardRechargeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor yellowColor];
}

- (void)setType:(CardRechargeCollectionViewCellType)type
{
    _type = type;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.type) {
        case kCardRechargeCollectionViewCellTypeCardNumber:
            self.inputTF.placeholder = @"请输入卡号";
            break;
        case kCardRechargeCollectionViewCellTypeCode:
            self.inputTF.placeholder = @"请输入密码";
            break;
        default:
            break;
    }
}

@end
