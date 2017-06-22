//
//  BAFBaseViewController.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAFBaseViewController : UIViewController
- (void)setNavigationBackButtonWithText:(NSString *)text method:(SEL)method;
- (void)setNavigationBackButtonWithImage:(UIImage *)image method:(SEL)method;
- (void)setNavigationRightButtonWithText:(NSString *)text method:(SEL)method;
- (void)setNavigationRightButtonWithImage:(UIImage *)image method:(SEL)method;
- (void)setNavigationTitle:(NSString *)title;
- (NSString *)rightButtonText;

- (void)showTipsInWindow:(NSString*)msg;
-(void)showTipsMsgWith:(NSString *)msg;
-(void)showTipsMsgWith:(NSString *)msg offset:(CGFloat)offset;
- (void)showTipsInView:(UIView*)view message:(NSString*)msg;
- (void)showTipsInView:(UIView*)view message:(NSString*)msg offset:(CGFloat)offset;
@end
