//
//  NSMutableDictionary+Valuation.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NSMutableDictionary+Valuation.h"

@implementation NSMutableDictionary (Valuation)
- (void)setNonemptyValue:(id)value forkey:(NSString*)key
{
    if (value && [value isKindOfClass:[NSObject class]]) {
        [self setObject:value forKey:key];
    }
}
@end
