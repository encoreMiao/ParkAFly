//
//  PopViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PopViewControllerType){
    kPopViewControllerTypeTop,//服务说明
    kPopViewControllerTypeSelec,//选择
    kPopViewControllerTypeTipsshow,//费用明细
    kPopViewControllerTypCompany,//通行人数
};


@interface PopViewController : UIViewController
- (void)configViewWithData:(NSArray *)arr type:(PopViewControllerType)type;
@end
