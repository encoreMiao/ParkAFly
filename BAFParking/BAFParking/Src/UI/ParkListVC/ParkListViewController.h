//
//  ParkListViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/11.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"

typedef NS_ENUM(NSInteger, ParkListViewControllerType)
{
    kParkListViewControllerTypeShow,//主页进来的，显示立即预约
    kParkListViewControllerTypeSelect,//预约页面进来的，显示选择或者已选择
};

@interface ParkListViewController : BAFBaseViewController
@property (nonatomic, assign) ParkListViewControllerType type;
@end
