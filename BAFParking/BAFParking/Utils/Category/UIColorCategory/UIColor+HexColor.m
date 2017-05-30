//
//  UIColor+HexColor.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
+ (id) colorWithHex:(unsigned int)hex
{
    return [UIColor colorWithHex:hex alpha:1];
}

+ (id) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}
@end
