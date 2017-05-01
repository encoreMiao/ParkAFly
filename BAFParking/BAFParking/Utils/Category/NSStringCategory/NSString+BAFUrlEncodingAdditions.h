//
//  NSString+BAFUrlEncodingAdditions.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BAFUrlEncodingAdditions)
- (NSString *)mm_URLEncodedString;
- (NSString *)mm_URLDecodedString;
@end
