//
//  SuccessViewController.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/30.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFBaseViewController.h"

typedef NS_ENUM(NSInteger,SuccessViewControllerType){
    kSuccessViewControllerTypeSuccess,
    kSuccessViewControllerTypeFailure,
    kSuccessViewControllerTypePay,
};


@interface SuccessViewController : BAFBaseViewController    
@property (nonatomic, assign) SuccessViewControllerType type;
@property (nonatomic, strong) NSString *orderId;
@end
