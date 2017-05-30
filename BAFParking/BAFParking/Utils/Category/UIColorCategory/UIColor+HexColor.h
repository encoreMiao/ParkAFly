//
//  UIColor+HexColor.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
+ (id) colorWithHex:(unsigned int)hex;
+ (id) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;
@end
