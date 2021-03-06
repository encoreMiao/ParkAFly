//
//  ChargeFooterCollectionReusableView.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ChargeFooterCollectionReusableView.h"

@implementation ChargeFooterCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.chargeBtn.clipsToBounds = YES;
    self.chargeBtn.layer.cornerRadius = 3.0f;
}

- (IBAction)chargeAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chargeActionDelegate:)]){
        [self.delegate chargeActionDelegate:self];
    }
}

@end
