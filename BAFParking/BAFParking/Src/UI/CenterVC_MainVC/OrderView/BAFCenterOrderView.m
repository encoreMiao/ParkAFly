//
//  BAFCenterOrderView.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFCenterOrderView.h"


@interface BAFCenterOrderView()
@property (nonatomic, weak) IBOutlet UIView *goingView;
@property (nonatomic, weak) IBOutlet UIView *noneView;
@end


@implementation BAFCenterOrderView
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
//        [self addGestureOnBGView];
    }
    DLog(@"initWithFrame");
    return self;
}

//通过xib创建的控件会调用通过该方法
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
//        [self addGestureOnBGView];
    }
    DLog(@"initWithCoder");
    return self;
}

- (void)setType:(BAFCenterOrderViewType)type
{
    _type = type;
    switch (_type) {
        case kBAFCenterOrderViewTypeNone:
        {
            self.noneView.hidden = NO;
            self.goingView.hidden = YES;
        }
            break;
        case kBAFCenterOrderViewTypeGoing:
        {
            self.noneView.hidden = YES;
            self.goingView.hidden = NO;
        }
            break;
    }
}

- (IBAction)showOrderDetail:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(showOrderDetail:)]) {
        [self.delegate showOrderDetail:sender];
    }
}

@end
