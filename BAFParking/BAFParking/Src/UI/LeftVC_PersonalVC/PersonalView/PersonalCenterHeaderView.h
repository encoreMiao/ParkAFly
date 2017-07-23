//
//  PersonalCenterHeaderView.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PersonalCenterHeaderViewDelegate <NSObject>
- (void)PersonalCenterHeaderViewDidTapWithGesture:(UITapGestureRecognizer*)gesture;
//- (void)
@end

@interface PersonalCenterHeaderView : UIView
@property (nonatomic, weak) id<PersonalCenterHeaderViewDelegate> delegate;
- (void)setupView;
@end
