//
//  NSString+ImageExtName.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "NSString+ImageExtName.h"

@implementation NSString (ImageExtName)
//获取图片后缀
+ (NSString *)typeForImageData:(NSData *)data {
    
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {   
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
 
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
  
}
@end
