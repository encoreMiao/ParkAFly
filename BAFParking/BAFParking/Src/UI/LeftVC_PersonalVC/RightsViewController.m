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
#import "PopViewController.h"

#define RightsTableViewCellIdentifier   @"RightsTableViewCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberAccountList,
};

@interface RightsViewController ()<UITableViewDelegate, UITableViewDataSource,RightsTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myRightsTableView;
@property (strong, nonatomic) NSMutableArray *rightsArr;

@property (strong, nonatomic) IBOutlet UIView *nonRightView;
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
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
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
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.detailStr = @"• 使用此卡结算订单，可享受第一次停车30天内免费停车，超出30天以外车位费享受8折优惠；\n• 从第二次停车开始，使用此卡结算订单，车位费享受80%优惠；\n • 代客泊车、代加油等单项服务正常收费；\n• 权益卡有效期内，享受不限次免费自助洗车；\n• 权益卡在有效期能享受优惠，过期失效。";
    popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    [popView configViewWithData:nil type:kPopViewControllerTypeTop];
    [self presentViewController:popView animated:NO completion:nil];
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
            
            if (self.rightsArr.count<=0) {
                [self.nonRightView setFrame:CGRectMake(0, 0, screenWidth,195)];
                self.myRightsTableView.tableHeaderView = self.nonRightView;
            }else{
                self.myRightsTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
            }

            [self.myRightsTableView reloadData];
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}
@end
