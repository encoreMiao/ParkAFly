//
//  NSString+URL.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NSString+URL.h"
#import "NSString+Null.h"

@implementation NSString (URL)
//字典转url参数字符串 dict -> string
+ (NSString*)mm_URLParamStringFromDictionary:(NSDictionary*)dict
{
    
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    if (dict != nil)
    {
        for (NSString *key in dict.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
            if ((value != nil) && ([value isEqualToString:@""] == NO)) {
                NSString * keyValue = [NSString stringWithFormat:@"%@=%@",key,value];
                [mArray addObject:keyValue];
            }
        }
    }
    //拼装
    if (mArray.count >0) {
        return [mArray componentsJoinedByString:@"&"];
    }
    return nil;
}
//字典转url字符串
+ (NSString*)mm_URLString:(NSString*)url fromDictionary:(NSDictionary*)dict
{
    if (!dict) {
        return url;
    }
    NSString *paramStr = [self mm_URLParamStringFromDictionary:dict];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",url,paramStr];
    return urlString;
}
;
//字典转url字符串 并编码
+ (NSString*)mm_encodeUrlString:(NSString*)url fromDictionary:(NSDictionary*)dict
{
    NSString *urlString = [self mm_URLString:url fromDictionary:dict];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return urlString;
}


//url参数字符串转字典 string -> dict
+ (NSDictionary*)mm_URLParamStringToDictionary:(NSString*)url
{
    NSArray *params = [url componentsSeparatedByString:@"?"];
    if (params.count > 1) {
        NSString *keyValues = params[1];
        //获取key，value键值对
        NSArray *params = [keyValues componentsSeparatedByString:@"&"];
        if (params.count > 0) {
            NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
            for (NSString *keyValue in params) {
                NSArray *kv = [keyValue componentsSeparatedByString:@"="];
                if (kv.count > 1) {
                    [mDict setObject:kv[1] forKey:kv[0]];
                }
            }
            return mDict;
        }
        
    }
    return nil;
}

//url字符串拼接固定参数
- (NSString*)mm_urlStringWithParamString:(NSString*)keyValue
{
    NSString *url = nil;
    if ([self rangeOfString:@"?"].location != NSNotFound) {
        //包含？
        if ([self hasSuffix:@"&"]) {
            //keyValue
            url = [NSString stringWithFormat:@"%@%@", self, keyValue];
        }
        else
        {
            //&keyValue
            url = [NSString stringWithFormat:@"%@&%@", self, keyValue];
        }
        
    }
    else
    {
        //?keyValue
        url = [NSString stringWithFormat:@"%@?%@", self, keyValue];
    }
    
    return url;
}

/**
 <#Description#>

 @param url <#url description#>
 @param keyvalue <#keyvalue description#>
 @return <#return value description#>
 */
+ (NSString*)mm_URLString:(NSString *)url keyvalue:(NSString *)keyvalue
{
    if (isNull(url) || isNull(keyvalue)) {
        return url;
    }
    
    return [url mm_urlStringWithParamString:keyvalue];
}

//url字符串包含给定文本
- (BOOL)mm_isContainString:(NSString*)textString
{
    if (self) {
        if ([self rangeOfString:textString].location != NSNotFound) {
            //包含
            return YES;
            
        }
        else
        {
            return NO;
        }
    }
    return NO;
}



@end
