//
//  RightsViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "RightsViewController.h"
#import "BAFCenterViewController.h"
#import "RightsTableViewCell.h"
#import "CombineNewRightsViewController.h"

#define RightsTableViewCellIdentifier   @"RightsTableViewCellIdentifier"

@interface RightsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myRightsTableView;
@property (strong, nonatomic) NSMutableArray *rightsArr;
@end

@implementation RightsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightsArr = [NSMutableArray array];
    self.myRightsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self setNavigationTitle:@"权益账户"];
     [self setNavigationRightButtonWithText:@"绑定新卡" method:@selector(rightBtnClicked:)];
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (void)rightBtnClicked:(id)sender
{
    NSLog(@"绑定新卡");
    CombineNewRightsViewController *combinerightsVC = [[CombineNewRightsViewController alloc]init];
    [self.navigationController pushViewController:combinerightsVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 176.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.rightsArr.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightsTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RightsTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RightsTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
    }
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
