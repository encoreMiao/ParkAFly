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
@end