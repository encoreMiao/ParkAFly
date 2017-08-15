//
//  BAFDefine.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#ifndef BAFDefine_h
#define BAFDefine_h


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//*********************************************************************************
#define kBAFCommonColor             (0x3492e9)
#define kBAFAssistiveColor          (0xfb694b)
#define kBAFLineGrayColor           (0xc9c9c9)
#define kBAFBackgroundGrayColor     (0xf5f5f5)
#define kBAFShadeColor              (0x000000)  //透明度50%
#define kBAFColorForTitle           (0x323232) //标题栏
#define kBAFColorForTitleButton     (0x3492e9)  //标题栏左右
#define kBAFColorForBeforeText      (0xb0b0b0)  //输入前（正文）
#define kBAFColorForText            (0x323232)  //输入后（正文）
#define kBAFColorForToast           (0x969696)  //提示

#define kBAFFontSizeForTitle        18 //标题栏
#define kBAFFontSizeForTitleButton  15  //标题栏左右
#define kBAFFontSizeForText         15  //输入后（正文）
#define kBAFFontSizeForLittleTitle  16 //小标题
#define kBAFFontSizeForDetailText   14  //正文（说明）
#define kBAFFontSizeForToast        13  //提示

#define kBAFDistanceCommon          10
#define kBAFDistanceMedium          15
#define kBAFButtonHeight            42


//*********************************************************************************
#define screenWidth ([UIScreen mainScreen].bounds.size.width) // 屏幕宽
#define screenHeight ([UIScreen mainScreen].bounds.size.height) // 屏幕高
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)


#define BAFAppdelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//***************************程序中的通知定义*******************************************//
#define NotifyUserInfoChange  @"NotifyUserInfoChange"  //用户信息更改
#define NotifyUserLoginOK     @"NotifyUserLoginOK"     //用户登陆成功
#define NotifyUserLogout      @"NotifyUserLogout"      //用户登陆失败


#define OrderDefaults   @"OrderDefaults" //预约的内容


#define PaySuccessNotification  @"PaySuccessNotification"
#define PayFailureNotification  @"PayFailureNotification"

#endif /* BAFDefine_h */

