//
//  NSString+HashMD5.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HashMD5)
+ (NSString *)md5WithString:(NSString *)input;
@end
