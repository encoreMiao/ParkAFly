//
//  OrderServiceHeaderView.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFUserInfo.h"

@interface OrderServiceHeaderView : UIView
@property (weak, nonatomic) IBOutlet UITextField    *nameTF;
@property (weak, nonatomic) IBOutlet UITextField    *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField    *licenseTF;
@property (weak, nonatomic) IBOutlet UIButton       *maleButton;
@property (weak, nonatomic) IBOutlet UIButton       *femaleButton;
@property (assign, nonatomic) int sexInt; //0 未知 1男 2女
@property (nonatomic, strong) BAFUserInfo *userInfo;
@end
