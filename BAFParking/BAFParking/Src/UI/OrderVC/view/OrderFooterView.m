//
//  OrderFooterView.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderFooterView.h"

@implementation OrderFooterView
- (IBAction)nextStepAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(nextStepButtonDelegate:)]) {
        [self.delegate nextStepButtonDelegate:sender];
    }
}
@end
