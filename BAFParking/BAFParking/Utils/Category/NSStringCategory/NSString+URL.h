//
//  NSString+URL.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)
//字典转url参数字符串 dict -> string
+ (NSString*)mm_URLParamStringFromDictionary:(NSDictionary*)dict;
//字典转url字符串
+ (NSString*)mm_URLString:(NSString*)url fromDictionary:(NSDictionary*)dict;
//字典转url字符串 并编码
+ (NSString*)mm_encodeUrlString:(NSString*)url fromDictionary:(NSDictionary*)dict;

//url参数字符串转字典 string -> dict
+ (NSDictionary*)mm_URLParamStringToDictionary:(NSString*)url;

+ (NSString*)mm_URLString:(NSString *)url keyvalue:(NSString *)keyvalue;
//url字符串拼接固定参数
- (NSString*)mm_urlStringWithParamString:(NSString*)keyValue;
//url字符串包含给定文本
- (BOOL)mm_isContainString:(NSString*)textString;
@end
