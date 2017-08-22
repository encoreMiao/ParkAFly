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
    kPopViewControllerTypeSelecCity,//选择城市
    kPopViewControllerTypeGoTime,//选择泊车时间
    kPopViewControllerTypeBackTime,//选择取车时间
    kPopViewControllerTypeSelecGoTerminal,//选择出发航站楼
    kPopViewControllerTypeSelecBackTerminal,//选择返程航站楼
    kPopViewControllerTypeCompany,//通行人数
    kPopViewControllerTypeTipsshow,//费用明细
    kPopViewControllerTypeTcCard,//权益卡列表
    
    kPopViewControllerTypeSelecColor,//选择颜色
    kPopViewControllerTypeSelecSex,//选择性别
};

@protocol PopViewControllerDelegate <NSObject>
- (void)popviewConfirmButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview;
- (void)popviewDismissButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview;
@end


@interface PopViewController : UIViewController
@property (nonatomic, retain) NSDate        *selectedDate;
@property (nonatomic, retain) NSIndexPath   *selectedIndex;
@property (nonatomic, assign) id<PopViewControllerDelegate> delegate;
- (void)configViewWithData:(NSArray *)arr type:(PopViewControllerType)type;

@property (nonatomic, strong) NSString *detailStr;


@property (nonatomic, strong) NSString *selectedStr;

@end
