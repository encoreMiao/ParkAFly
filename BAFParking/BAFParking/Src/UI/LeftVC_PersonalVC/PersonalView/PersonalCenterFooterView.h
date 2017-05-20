//
//  PersonalCenterFooterView.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonalCenterFooterViewDelegate <NSObject>
- (void)personalCenterFooterViewDidTapWithGesture:(UITapGestureRecognizer*)gesture;
@end

@interface PersonalCenterFooterView : UIView
@property (nonatomic, weak) id<PersonalCenterFooterViewDelegate> delegate;
@end
