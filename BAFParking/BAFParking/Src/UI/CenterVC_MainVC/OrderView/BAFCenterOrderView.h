//
//  BAFCenterOrderView.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,BAFCenterOrderViewType)
{
    kBAFCenterOrderViewTypeGoing,//有进行中的订单
    kBAFCenterOrderViewTypeNone,//暂无订单
};

@protocol BAFCenterOrderViewDelegate <NSObject>
- (void)showOrderDetail:(id)sender;
@end

@interface BAFCenterOrderView : UIView
@property (nonatomic, assign) BAFCenterOrderViewType        type;
@property (nonatomic, assign) NSDictionary                  *orderDic;
@property (nonatomic, weak) id <BAFCenterOrderViewDelegate> delegate;
@end
