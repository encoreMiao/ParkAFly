//
//  OrderServiceHeaderView.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderServiceHeaderView.h"

@interface OrderServiceHeaderView()
@end

@implementation OrderServiceHeaderView
- (void)setUserInfo:(BAFUserInfo *)userInfo
{
    _userInfo = userInfo;
    self.nameTF.text = userInfo.cname;
    self.phoneTF.text = userInfo.ctel;
    self.licenseTF.text = userInfo.carnum;
    
    //0 未知 1男 2女
    if (userInfo.csex.integerValue == 0) {
        //未知
        [self.maleButton setImage:[UIImage imageNamed:@"list_rb2_gender"] forState:UIControlStateNormal];
        [self.femaleButton setImage:[UIImage imageNamed:@"list_rb2_gender"] forState:UIControlStateNormal];
    }else if (userInfo.csex.integerValue == 1) {
        //男
        [self.maleButton setImage:[UIImage imageNamed:@"list_rb_gender"] forState:UIControlStateNormal];
        [self.femaleButton setImage:[UIImage imageNamed:@"list_rb2_gender"] forState:UIControlStateNormal];
    }else{
        //女
        [self.maleButton setImage:[UIImage imageNamed:@"list_rb2_gender"] forState:UIControlStateNormal];
        [self.femaleButton setImage:[UIImage imageNamed:@"list_rb_gender"] forState:UIControlStateNormal];
    }
    
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.licenseTF resignFirstResponder];
}
- (IBAction)buttonCliked:(id)sender {
    [self.maleButton setImage:[UIImage imageNamed:@"list_rb2_gender"] forState:UIControlStateNormal];
    [self.femaleButton setImage:[UIImage imageNamed:@"list_rb2_gender"] forState:UIControlStateNormal];
    
    UIButton *button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"list_rb_gender"] forState:UIControlStateNormal];
    
    if (button == self.maleButton) {
//        self.userInfo.csex = @"1";
        self.sexInt = 1;
    }else{
//        self.userInfo.csex = @"2";
        self.sexInt = 2;
    }
}
@end
