//
//  PopViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopViewController;

typedef NS_ENUM(NSInteger,PopViewControllerType){
    kPopViewControllerTypeTop,//服务说明
    kPopViewControllerTypeSelec,//选择
    kPopViewControllerTypeTipsshow,//费用明细
    kPopViewControllerTypCompany,//通行人数
};

@protocol PopViewControllerDelegate <NSObject>
- (void)popviewConfirmButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview;
@end


@interface PopViewController : UIViewController
@property (nonatomic, assign) id<PopViewControllerDelegate> delegate;
- (void)configViewWithData:(NSArray *)arr type:(PopViewControllerType)type;
@end
