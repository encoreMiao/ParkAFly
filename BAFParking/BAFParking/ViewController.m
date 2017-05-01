//
//  ViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/4/7.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ViewController.h"
#import "IUCallBackInterface.h"
#import "HRLLoginInterface.h"
#import "HRLogicManager.h"

@interface ViewController ()<IUICallbackInterface>

@end

@implementation ViewController
- (IBAction)requestTest:(id)sender {
    
    id <HRLLoginInterface> loginReq = [[HRLogicManager sharedInstance]getLoginReqest];
    [loginReq loginRequestWithNumberIndex:0 delegte:self phone:@"18511833913"];
//    [loginReq test];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//job成功之后需要执行的方法，aRequestID：请求的id
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    DLog(@"请求成功调用 %@",obj);
}
//job超时了之后需要执行的方法，aRequestID：请求的id
-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    DLog(@"请求失败调用 %@",message);
}


@end
