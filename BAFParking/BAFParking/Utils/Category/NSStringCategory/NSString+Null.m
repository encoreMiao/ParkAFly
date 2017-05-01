//
//  NSString+Null.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NSString+Null.h"

@implementation NSString (Null)

- (BOOL)mm_strIsNull
{
    if ([self isEqualToString:@""]||[self isEqual:[NSNull null]]) {
        return YES;
    }else{
        return NO;
    }
}

@end
