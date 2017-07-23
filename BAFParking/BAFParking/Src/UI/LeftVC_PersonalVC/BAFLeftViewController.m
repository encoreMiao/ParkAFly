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
#import "OrderListViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "PersonalAccountViewController.h"
#import "CompanyAccountViewController.h"
#import "RightsViewController.h"
#import "CouponViewController.h"
#import "ShareViewController.h"
#import "FeedBackViewController.h"
#import "SettingViewController.h"
#import "PersonalEditViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.headerView setupView];
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
    [self.headerView setupView];
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setPersonalCenterCellWithDic:self.personalCellArray[indexPath.row]];
    if (indexPath.row == 0) {
        BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
        cell.cellSubTitle.text = [NSString stringWithFormat:@"%.0f元",userInfo.account.integerValue/100.0f];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc ;
    switch (indexPath.row) {
        case 0:
            
            vc = [[PersonalAccountViewController alloc]init];
            break;
        case 1:
//            vc = [[CompanyAccountViewController alloc]init];
            [self showTipsInView:self.view message:@"暂时未开通" offset:self.view.center.x+100];
            return;
            break;
        case 2:
            vc = [[RightsViewController alloc]init];
            break;
        case 3:
        {
            vc = [[CouponViewController alloc]init];
            CouponViewController *couponVC = (CouponViewController *)vc;
            couponVC.type = kCouponViewControllerTypeCommon;
            vc = couponVC;
        }
            break;
        case 4:
            vc = [[OrderListViewController alloc]init];
            break;
        case 5:
            vc = [[ShareViewController alloc]init];
            break;
        case 6:
            vc = [[FeedBackViewController alloc]init];
            break;
    }
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];

    UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    [nav pushViewController:vc animated:NO];
    //当我们push成功之后，关闭我们的抽屉
}

#pragma mark - PersonalCenterFooterViewTapDelegate
- (void)personalCenterFooterViewDidTapWithGesture:(UITapGestureRecognizer*)gesture
{
    UIViewController *vc = [[SettingViewController alloc]init];
    UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    [nav pushViewController:vc animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

#pragma mark - PersonalCenterHeaderViewDelegate
- (void)PersonalCenterHeaderViewDidTapWithGesture:(UITapGestureRecognizer*)gesture
{
    UIViewController *vc = [[PersonalEditViewController alloc]init];
    UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    [nav pushViewController:vc animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }];
}

@end
