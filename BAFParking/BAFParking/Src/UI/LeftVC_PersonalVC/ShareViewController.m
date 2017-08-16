//
//  ShareViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ShareViewController.h"
#import "BAFCenterViewController.h"
#import "WXApi.h"

@interface ShareViewController ()
{
    enum WXScene _scene;
}
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = HexRGB(0xffffff);
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"分享"];
}

- (void)backMethod:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)wechatShare:(id)sender {
    //微信好友分享
    _scene = WXSceneSession;
    [self sendLinkContent];
    
}
- (IBAction)friend:(id)sender {
    //朋友圈分享
    _scene = WXSceneTimeline;
    [self sendLinkContent];
}

- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"泊安飞，不一样的机场停车";
    message.description = @"致力于为自驾往来机场的航空旅客提供更低价格，更多服务的机场停车服务商";
    [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"www.parknfly.cn";
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;//WXSceneTimeline
    
    [WXApi sendReq:req];
}

@end
