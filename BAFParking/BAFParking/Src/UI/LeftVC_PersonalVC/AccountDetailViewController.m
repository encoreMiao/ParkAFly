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
#import "HRLPersonalCenterInterface.h"
#import "HRLogicManager.h"
#import "BAFUserModelManger.h"
#import "BAFClientPatrInfo.h"

#define AccountDetailTableViewCellIdentifier @"AccountDetailTableViewCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexPersonalAccount,//账户充值页面
    kRequestNumberIndexClientPatr,//账户余额交易记录
};

@interface AccountDetailViewController ()
@property (nonatomic, weak) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *rechargeListArr;
@end

@implementation AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rechargeListArr = [NSMutableArray array];
    
    self.mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
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
    [self setNavigationTitle:@"明细"];
    
    [self clientDetailRequest];
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rechargeListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountDetailTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:AccountDetailTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AccountDetailTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BAFClientPatrInfo *rechargeInfo = ((BAFClientPatrInfo *)[self.rechargeListArr objectAtIndex:indexPath.row]);
    cell.patrInfo = rechargeInfo;
    return cell;
}


- (void)clientDetailRequest
{
    //账户余额交易记录
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [personCenterReq clientPatrRequestWithNumberIndex:kRequestNumberIndexClientPatr delegte:self client_id:userInfo.clientid];
    
}

#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexClientPatr) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //账户余额交易记录
            if (self.rechargeListArr) {
                [self.rechargeListArr removeAllObjects];
            }
            self.rechargeListArr = [BAFClientPatrInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
            [self.mainTableView reloadData];
        }else{
            
        }
    }

}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}


@end
