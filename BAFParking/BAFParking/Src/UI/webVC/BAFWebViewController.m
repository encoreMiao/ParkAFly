//
//  BAFWebViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/4.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFWebViewController.h"

@interface BAFWebViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView * myWebView;
@end


@implementation BAFWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myWebView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadTargetURL:(NSURL *)url title:(NSString *)title
{
    if ([url isKindOfClass:[NSURL class]]) {
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [self.myWebView loadRequest:request];
        [self setNavigationTitle:title];
    }
}

- (void)backMethod:(id)sender
{
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

#pragma mark - webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
////    NSURL* url = [request URL];
//    return [self shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType];
//}
// 子类去实现
//-(BOOL)shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    // 子类去实现
////    return YES;
//}
#pragma mark -setter&getter
- (UIWebView *)myWebView
{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
        _myWebView.backgroundColor = [UIColor clearColor];
        _myWebView.scrollView.backgroundColor = [UIColor clearColor];
        _myWebView.delegate = self;
        _myWebView.opaque = NO;
    }
    return _myWebView;
}


@end
