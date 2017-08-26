//
//  CityCollectionViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/8/21.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CityCollectionViewCell.h"

@implementation CityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.layer.borderWidth = 1.0f;
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 3.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setCityCollectionSelected:(BOOL)citySelected
{
    if (citySelected) {
        self.layer.borderColor = [[UIColor colorWithHex:0x3492e9] CGColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.0f;
    }else{
        self.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.0f;
    }
}

@end
