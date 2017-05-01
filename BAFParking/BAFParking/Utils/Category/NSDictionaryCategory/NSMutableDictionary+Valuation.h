//
//  NSMutableDictionary+Valuation.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Valuation)
- (void)setNonemptyValue:(id)value forkey:(NSString*)key;
@end
