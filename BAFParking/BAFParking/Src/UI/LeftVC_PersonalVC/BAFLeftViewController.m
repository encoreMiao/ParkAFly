//
//  BAFLeftViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFLeftViewController.h"
#import "PersonalCenterTableViewCell.h"
#import "PersonalCenterHeaderView.h"
#import "PersonalCenterFooterView.h"

@interface BAFLeftViewController ()
<UITableViewDelegate, UITableViewDataSource,PersonalCenterFooterViewDelegate,PersonalCenterHeaderViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *personalTableView;
@property (nonatomic, strong) NSArray *personalCellArray;
@property (nonatomic, weak) IBOutlet PersonalCenterHeaderView *headerView;
@property (nonatomic, weak) IBOutlet PersonalCenterFooterView *footerView;
@end

@implementation BAFLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    [self configData];
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupView{
    self.personalTableView.backgroundColor = [UIColor clearColor];
    self.personalTableView.separatorColor = [UIColor clearColor];
    self.personalTableView.scrollEnabled = NO;
    
    [self.headerView setFrame:CGRectMake(0, 0, screenWidth,195)];
    self.personalTableView.tableHeaderView = self.headerView;
    self.headerView.delegate =self;
    
//    [self.footerView setFrame:CGRectMake(0, 0, screenWidth, 55)];
//    self.personalTableView.tableFooterView = self.footerView;
    [self.footerView setFrame:CGRectMake(0, screenHeight-55, screenWidth, 55)];
    [self.view addSubview:self.footerView];
    self.footerView.delegate = self;

    
    [_personalTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PersonalCenterTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PersonalCenterTableViewCell class])];
}

- (void)configData{
    self.personalCellArray = @[@{PersonalCellImgString:@"leftbar_info1",PersonalcellTitleString:@"个人账户",PersonalCellType:[NSNumber numberWithInt:kPersonalCenterCellTypePersonalAccount]},
                               @{PersonalCellImgString:@"leftbar_info2",PersonalcellTitleString:@"企业账户",PersonalCellType:[NSNumber numberWithInt:kPersonalCenterCellTypeCompanyAcount]},
                               @{PersonalCellImgString:@"leftbar_info3",PersonalcellTitleString:@"权益账户",PersonalCellType:[NSNumber numberWithInt:kPersonalCenterCellTypeRightAccount]},
                               @{PersonalCellImgString:@"leftbar_info4",PersonalcellTitleString:@"优惠券",PersonalCellType:[NSNumber numberWithInt:kPersonalCenterCellTypeCoupon]},
                               @{PersonalCellImgString:@"leftbar_info5",PersonalcellTitleString:@"我的订单",PersonalCellType:[NSNumber numberWithInt:kPersonalCenterCellTypeOrder]},
                               @{PersonalCellImgString:@"leftbar_info6",PersonalcellTitleString:@"分享",PersonalCellType:[NSNumber numberWithInt:kPersonalCenterCellTypeShare]},
                               @{PersonalCellImgString:@"leftbar_info7",PersonalcellTitleString:@"意见反馈",PersonalCellType:[NSNumber numberWithInt:kPersonalCenterCellTypeFeedBack]},
                               ];
}

#pragma mark - TableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.personalCellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonalCenterTableViewCell class])];
    [cell setPersonalCenterCellWithDic:self.personalCellArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

#pragma mark - PersonalCenterFooterViewTapDelegate
- (void)personalCenterFooterViewDidTapWithGesture:(UITapGestureRecognizer*)gesture
{
    DLog(@"footer手势方法被调用");
}

#pragma mark - PersonalCenterHeaderViewDelegate
- (void)PersonalCenterHeaderViewDidTapWithGesture:(UITapGestureRecognizer*)gesture
{
    DLog(@"header手势方法被调用");
}

@end