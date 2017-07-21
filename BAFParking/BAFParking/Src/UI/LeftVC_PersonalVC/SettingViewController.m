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

#define SettingTableViewCellIdentifier  @"SettingTableViewCellIdentifier"

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *quitButton;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (nonatomic, strong) NSArray *settingListArr;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingListArr = @[@"用户协议",@"关于我们",@"帮助说明"];
    self.quitButton.layer.borderColor = [[UIColor colorWithHex:0x3492e9] CGColor];
    self.quitButton.layer.borderWidth = 0.5;
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
//    for (UIViewController *tempVC in self.navigationController.viewControllers) {
//        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
//            [self.navigationController popToViewController:tempVC animated:YES];
//        }
//    }
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
