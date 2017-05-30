//
//  BAFOrderViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFOrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderFooterView.h"
#import "BAFOrderServiceViewController.h"

#define OrderTableViewCellIdentifier    @"OrderTableViewCellIdentifier"

@interface BAFOrderViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFooterViewDelegate>
@property (strong, nonatomic) IBOutlet OrderFooterView *footerView;
@property (nonatomic, strong) IBOutlet UITableView  *mainTableView;
@end

@implementation BAFOrderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
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
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98.0f/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }else if(section == 1){
        return 10.0f;//若选择停车场则为30
    }else if (section == 2){
        return 10.0f;
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    if (section == 0) {
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
    }else if(section == 1){
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, screenWidth-24, 20)];
//        label.backgroundColor = [UIColor grayColor];
//        label.font = [UIFont systemFontOfSize:14.0f];
//        label.textColor = [UIColor colorWithHex:0x585c64];
//        label.text = @"该车场收费标准为首日60元/天，之后25元/天";
//        [sectionFooterView addSubview:label];
    }else if(section == 2){
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
    }
    return sectionFooterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCell" owner:nil options:nil] firstObject];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0 ) {
            cell.type = kOrderTableViewCellTypeGoTime;
        }else if(row == 1){
            cell.type = kOrderTableViewCellTypeGoParkTerminal;
        }
    }else if (section == 1){
        cell.type = kOrderTableViewCellTypePark;
    }else if (section == 2){
        if (row == 0) {
            cell.type = kOrderTableViewCellTypeBackTime;
        }else{
            cell.type = kOrderTableViewCellTypeBackTerminal;
        }
    }else{
        cell.type = kOrderTableViewCellTypeCompany;
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark - OrderFooterViewDelegate
- (void)nextStepButtonDelegate:(id)sender
{
    BAFOrderServiceViewController *orderServiceVC = [[BAFOrderServiceViewController alloc]init];
    [self.navigationController pushViewController:orderServiceVC animated:YES];
}

@end
