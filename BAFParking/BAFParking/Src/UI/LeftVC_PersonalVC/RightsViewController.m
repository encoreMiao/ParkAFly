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
#import "HRLPersonalCenterInterface.h"
#import "BAFEquityAccountInfo.h"

#define RightsTableViewCellIdentifier   @"RightsTableViewCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberAccountList,
};

@interface RightsViewController ()<UITableViewDelegate, UITableViewDataSource,RightsTableViewCellDelegate>
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
    
    [self equityAccountListRequest];
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
    return self.rightsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightsTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:RightsTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RightsTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    BAFEquityAccountInfo  *accountinfo = ((BAFEquityAccountInfo *)[self.rightsArr objectAtIndex:indexPath.row]);
    cell.accountInfo = accountinfo;
    return cell;
}

#pragma mark - RightsTableViewCellDelegate
- (void)useNotiActionDelegate:(RightsTableViewCell *)cell
{
    NSLog(@"权益账户使用说明");
}

#pragma mark - REQUEST
- (void)equityAccountListRequest
{
    id <HRLPersonalCenterInterface> equityAccountList = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [equityAccountList equityAccountListRequestWithNumberIndex:kRequestNumberAccountList delegte:self bind_phone:userInfo.ctel];
}

-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberAccountList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //城市列表
            if (self.rightsArr) {
                [self.rightsArr removeAllObjects];
            }
            self.rightsArr = [BAFEquityAccountInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
            [self.myRightsTableView reloadData];
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}
@end
