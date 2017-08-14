//
//  OrderFooterView.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderFooterViewDelegate <NSObject>
- (void)nextStepButtonDelegate:(id)sender;
- (void)showPriceInformationDelegate:(id)sender;
@end


@interface OrderFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@property (nonatomic, assign) id<OrderFooterViewDelegate> delegate;
@end
