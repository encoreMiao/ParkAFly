//
//  NSString+BAFUrlEncodingAdditions.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NSString+BAFUrlEncodingAdditions.h"

@implementation NSString (BAFUrlEncodingAdditions)
- (NSString *)mm_URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)self,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    
    return result;
}
- (NSString *)mm_URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                             (CFStringRef)self,
                                                                                                             CFSTR(""),
                                                                                                             kCFStringEncodingUTF8));
    
    return result;
}

@end
