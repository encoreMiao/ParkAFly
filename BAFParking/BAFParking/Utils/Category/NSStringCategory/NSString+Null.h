//
//  NSString+Null.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isNull(s)  ((s == nil)||([s mm_strIsNull]))

@interface NSString (Null)

- (BOOL)mm_strIsNull;

@end
