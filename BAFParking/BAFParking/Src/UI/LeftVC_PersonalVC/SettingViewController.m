//
//  SettingViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "BAFCenterViewController.h"
#import "BAFUserModelManger.h"
#import "BAFWebViewController.h"
#import "UIViewController+MMDrawerController.h"

#define SettingTableViewCellIdentifier  @"SettingTableViewCellIdentifier"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (nonatomic, strong) NSArray *settingListArr;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingListArr = @[@"用户协议",@"关于我们",@"帮助说明",@"常见问题"];
    self.quitButton.layer.borderColor = [[UIColor colorWithHex:0x3492e9] CGColor];
    self.quitButton.layer.borderWidth = 0.5;
    self.quitButton.clipsToBounds = YES;
    self.quitButton.layer.cornerRadius = 3.0f;
    self.mytableview.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.mytableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"设置"];
}

- (void)backMethod:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)quitMethod:(id)sender {
    [[BAFUserModelManger sharedInstance] removeUserInfo];
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"优惠券选择");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BAFWebViewController  *webview = [[BAFWebViewController alloc]init];
    [self.navigationController pushViewController:webview animated:YES];
    if (indexPath.row == 0) {
        [webview loadTargetURL:[NSURL URLWithString:@"http://www.parknfly.cn/Wap/Index/baf_agreement"] title:@"用户协议"];
    }
    if (indexPath.row == 1) {
        [webview loadTargetURL:[NSURL URLWithString:@"http://parknfly.cn/Wap/Index/app_about"] title:@"关于我们"];
    }
    if (indexPath.row == 2) {
        [webview loadTargetURL:[NSURL URLWithString:@"http://parknfly.cn/Wap/Index/app_help"] title:@"帮助说明"];
    }
    if (indexPath.row == 3) {
        [webview loadTargetURL:[NSURL URLWithString:@"http://parknfly.cn/Wap/Index/app_kh_problems"] title:@"常见问题"];
    }
    
//    web链接地址：
//    正式：
//    价格说明:http://parknfly.cn/Wap/Index/app_price
//    帮助:http://parknfly.cn/Wap/Index/app_help
//    常见问题:http://parknfly.cn/Wap/Index/app_kh_problems
//    分享:http://parknfly.cn/Wap/Index/download
//    关于我们:http://parknfly.cn/Wap/Index/app_about
//    用户协议:http://www.parknfly.cn/Wap/Index/baf_agreement
//    会员说明：http://parknfly.cn/Public/Wap/level/index.html
//    
//    测试：
//    价格说明:http://parknfly.com.cn/Wap/Index/app_price
//    帮助:http://parknfly.com.cn/Wap/Index/app_help
//    常见:http://parknfly.com.cn/Wap/Index/app_kh_problems
//    分享:http://parknfly.com.cn/Wap/Index/download
//    关于我们:http://parknfly.com.cn/Wap/Index/app_about
//    用户协议:http://www.parknfly.com.cn/Wap/Index/baf_agreement
//    会员说明：http://parknfly.com.cn/Public/Wap/level/index.html
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:SettingTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingTableViewCell" owner:nil options:nil] firstObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
    }
    cell.settingLabel.text = [self.settingListArr objectAtIndex:indexPath.row];
    //    BAFParkInfo *parkinfo = ((BAFParkInfo *)[self.parkArr objectAtIndex:indexPath.row]);
    //    switch (self.type) {
    //        case kParkListViewControllerTypeShow:
    //            [cell setParkinfo:parkinfo withtype:kParkListTableViewCellTypeShow];
    //            break;
    //        case kParkListViewControllerTypeSelect:
    //            [cell setParkinfo:parkinfo withtype:kParkListTableViewCellTypeSelect];
    //            break;
    //        default:
    //            break;
    //    }
    return cell;
}
@end
