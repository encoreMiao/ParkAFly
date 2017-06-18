//
//  AccountDetailViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "PersonalAccountViewController.h"
#import "AccountDetailTableViewCell.h"

#define AccountDetailTableViewCellIdentifier @"AccountDetailTableViewCellIdentifier"

@interface AccountDetailViewController ()
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *rechargeListArr;
@end

@implementation AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rechargeListArr = [NSMutableArray array];
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
    [self setNavigationTitle:@"充值明细"];
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[PersonalAccountViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountDetailTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:AccountDetailTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AccountDetailTableViewCell" owner:nil options:nil] firstObject];
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
