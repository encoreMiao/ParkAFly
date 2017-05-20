//
//  BAFCenterViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFCenterViewController.h"
#import "UIViewController+MMDrawerController.h"
//#import "JLAdvertisingScrollView.h"

@interface BAFCenterViewController ()
//<JLAdvertisingScrollViewDelegate>

@end

@implementation BAFCenterViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)showLeftVC:(id)sender {
    [self leftDrawerButtonPress:sender];
}


//#pragma mark - ViewConfig
//- (void)scrollViewConfig
//{
//    JLAdvertisingScrollView *advertising = [[JLAdvertisingScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)];
//    [advertising setDelegate:self];
//    advertising.autoLoop = NO;
////    [advertising setAutoLoopInterval:3];
////    [advertising setShowPageControl:NO];
//    [self.view addSubview:advertising];
//}
//
//- (void)advertisingScrollView:(JLAdvertisingScrollView *)scrollView clickEventAtIndex:(NSInteger)index {
//    NSLog(@"点击了第%ld张图片",(long)index);
//}


#pragma mark - Button Handlers
- (void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
