//
//  BAFOrderServiceViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFOrderServiceViewController.h"
#import "OrderFooterView.h"
#import "OrderServiceHeaderView.h"
#import "BAFOrderViewController.h"
#import "OrderServiceTableViewCell.h"
#import "BAFOrderConfirmViewController.h"

#define OrderServiceTableViewCellIdentifier @"OrderServiceTableViewCellIdentifier"

@interface BAFOrderServiceViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFooterViewDelegate>
@property (strong, nonatomic) IBOutlet OrderFooterView *footerView;
@property (nonatomic, strong) IBOutlet UITableView  *mainTableView;
@property (strong, nonatomic) IBOutlet OrderServiceHeaderView *serviceHeaderView;
@end

@implementation BAFOrderServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.serviceHeaderView setFrame:CGRectMake(0, 0, screenWidth, 210)];
    self.mainTableView.tableHeaderView = self.serviceHeaderView;
    self.footerView.delegate = self;
    self.mainTableView.tableFooterView = self.footerView;
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavigationTitle:@"预约停车"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFOrderViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (void)nextStepButtonDelegate:(id)sender;
{
    BAFOrderConfirmViewController *orderConfirmVC = [[BAFOrderConfirmViewController alloc]init];
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }
    return 104.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }return 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderServiceTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderServiceTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderServiceTableViewCell" owner:nil options:nil] firstObject];
        
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (row == 0) {
            cell.type = kOrderServiceTableViewCellTypeCommonText;
        }else{
            cell.type = kOrderServiceTableViewCellTypeCommon;
        }
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.type = kOrderServiceTableViewCellTypeDisclosure;
    }
    return cell;
}


@end
