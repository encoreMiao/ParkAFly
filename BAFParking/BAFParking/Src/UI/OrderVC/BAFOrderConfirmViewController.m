//
//  BAFOrderConfirmViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFOrderConfirmViewController.h"
#import "OrderConfirmTableViewCell.h"
#import "ServiceConfirmTableViewCell.h"
#import "BAFOrderServiceViewController.h"
#import "SuccessViewController.h"

#define OrderConfirmTableViewCellIdentifier @"OrderConfirmTableViewCellIdentifier"
#define ServiceConfirmTableViewCellIdentifier   @"ServiceConfirmTableViewCellIdentifier"

@interface BAFOrderConfirmViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableVIEW;
@property (strong, nonatomic) IBOutlet UIView *mainHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *headerText;

@end

@implementation BAFOrderConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mainHeaderView setFrame:CGRectMake(0, 0, screenWidth, 50)];
    self.mainTableVIEW.tableHeaderView = self.mainHeaderView;
    self.mainTableVIEW.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavigationTitle:@"确认信息"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFOrderServiceViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}
- (IBAction)submitOrder:(id)sender {
    NSLog(@"提交预约");
    SuccessViewController *successVC = [[SuccessViewController alloc]init];
    successVC.type = kSuccessViewControllerTypeFailure;
    [self.navigationController pushViewController:successVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 104.0f;
    }else if (indexPath.section == 1){
        return 104.0f;
    }else{
        return 40.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }else if (section == 1){
        return 10.0f;
    }else{
        return 10.0f;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0||section == 1) {
        return 1;
    }else{
        return 3;//根据内容返回多少
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1 ) {
        OrderConfirmTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderConfirmTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderConfirmTableViewCell" owner:nil options:nil] firstObject];
            
        }
        return cell;
    }else{
        ServiceConfirmTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ServiceConfirmTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ServiceConfirmTableViewCell" owner:nil options:nil] firstObject];
            
        }
        return cell;
    }
    
}


@end
