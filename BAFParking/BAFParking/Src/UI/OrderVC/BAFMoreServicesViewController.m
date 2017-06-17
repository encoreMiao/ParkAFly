//
//  BAFMoreServicesViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/6/13.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFMoreServicesViewController.h"
#import "BAFOrderServiceViewController.h"
#import "OrderFooterView.h"
#import "MoreServicesTableViewCell.h"
#import "BAFParkServiceInfo.h"


#define MoreServicesTableViewCellIdentifier  @"MoreServicesTableViewCellIdentifier"

@interface BAFMoreServicesViewController ()<OrderFooterViewDelegate,UITableViewDelegate, UITableViewDataSource,MoreServicesTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet OrderFooterView *footerView;
@property (nonatomic, strong) IBOutlet UITableView  *mainTableView;
@end

@implementation BAFMoreServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitle:@"预约停车"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
}

- (void)setupView
{
    self.footerView.delegate = self;
    self.mainTableView.tableFooterView = self.footerView;
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}



- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFOrderServiceViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (void)nextStepButtonDelegate:(id)sender
{
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
    NSLog(@"%@",mutDic);
    
    
    
    [[NSUserDefaults standardUserDefaults]setObject:mutDic forKey:OrderDefaults];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRatIndexPath:indexPath];
}

- (CGFloat)heightForRatIndexPath:(NSIndexPath *)indexpath
{
    if ([[self.more_serviceDic.allKeys objectAtIndex:indexpath.section] isEqualToString:@"204"]) {
        return 160.0f;
    }else{
        return 130.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
    return sectionFooterView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.more_serviceDic.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreServicesTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:MoreServicesTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MoreServicesTableViewCell" owner:nil options:nil] firstObject];
        cell.delegate = self;
    }
    NSUInteger section = indexPath.section;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BAFParkServiceInfo *serviceInfo;
    serviceInfo = [BAFParkServiceInfo mj_objectWithKeyValues:[self.more_serviceDic objectForKey:[self.more_serviceDic.allKeys objectAtIndex:indexPath.section]]];
    if ([[self.more_serviceDic.allKeys objectAtIndex:indexPath.section] isEqualToString:@"204"]) {
        //代加油
        cell.type = kMoreServicesTableViewCellType204;
//        [cell setShow:self.isTextServiceShow];
    }else{
        cell.type = KMoreServicesTableViewCellType205;
//        [cell setShow:self.isCommonServiceShow];
    }
    cell.serviceInfo = serviceInfo;
    return cell;
}

- (void)setMore_serviceDic:(NSMutableDictionary *)more_serviceDic
{
    _more_serviceDic = [more_serviceDic copy];
    [self.mainTableView reloadData];
}

- (void)moreServiceTableViewCellAction:(MoreServicesTableViewCell *)tableviewCell
{
    [tableviewCell setShow:!tableviewCell.show];
}
@end
