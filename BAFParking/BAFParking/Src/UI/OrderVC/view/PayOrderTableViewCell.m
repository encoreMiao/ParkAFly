//
//  PayOrderTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/3.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PayOrderTableViewCell.h"

@implementation PayOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setShow:(BOOL)show
{
    _show = show;
    if (_show) {
        [self.selectBtn setImage:[UIImage imageNamed:@"list_chb_item"] forState:UIControlStateNormal];
    }
    else{
        [self.selectBtn setImage:[UIImage imageNamed:@"list_chb2_item"] forState:UIControlStateNormal];
    }
}
- (IBAction)selectBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectBtnDelegate:)]) {
        [self.delegate selectBtnDelegate:self];
    }
}

@end
