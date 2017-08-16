//
//  CommentViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"

typedef void (^CommetFinishedHandler) (void);

typedef NS_ENUM(NSInteger,CommentViewControllerType)
{
    kCommentViewControllerTypeCommentCheck,
    kCommentViewControllerTypeComment,
    kCommentViewControllerTypePayComment,//支付成功页面
};

@interface CommentViewController : BAFBaseViewController
@property (nonatomic, retain) NSDictionary *orderDic;
@property (nonatomic, assign) CommentViewControllerType type;
@property (nonatomic, copy)   CommetFinishedHandler commentfinishHandler;
@end
