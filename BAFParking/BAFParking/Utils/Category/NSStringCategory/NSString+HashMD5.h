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
#pragma mark - 32位 小写
+(NSString *)md5ForLower32Bate:(NSString *)input;
#pragma mark - 32位 大写
+(NSString *)md5ForUpper32Bate:(NSString *)input;
#pragma mark - 16位 大写
+(NSString *)md5ForUpper16Bate:(NSString *)input;
#pragma mark - 16位 小写
+(NSString *)md5ForLower16Bate:(NSString *)input;
@end
