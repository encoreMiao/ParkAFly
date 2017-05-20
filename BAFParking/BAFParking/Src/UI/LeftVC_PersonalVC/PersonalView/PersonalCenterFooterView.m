//
//  PersonalCenterFooterView.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalCenterFooterView.h"

@interface PersonalCenterFooterView()<UIGestureRecognizerDelegate>
@end

@implementation PersonalCenterFooterView
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    DLog(@"init");
    return self;
}

//代码创建的会调用该方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureOnBGView];
    }
    DLog(@"initWithFrame");
    return self;
}

//通过xib创建的控件会调用通过该方法
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self addGestureOnBGView];
    }
    DLog(@"initWithCoder");
    return self;
}

- (void)addGestureOnBGView
{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerViewDidTap:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)footerViewDidTap:(UITapGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(personalCenterFooterViewDidTapWithGesture:)]) {
        [self.delegate personalCenterFooterViewDidTapWithGesture:gesture];
    }
}

@end
