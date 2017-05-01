//
//  IUCallBackInterface.h
//  BAFParking
//
//  Created by mengmeng on 2017/4/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

@protocol IUICallbackInterface <NSObject>

//job成功之后需要执行的方法，aRequestID：请求的id
-(void)onJobComplete:(int)aRequestID Object:(id)obj;
//job超时了之后需要执行的方法，aRequestID：请求的id
-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message;

@end
