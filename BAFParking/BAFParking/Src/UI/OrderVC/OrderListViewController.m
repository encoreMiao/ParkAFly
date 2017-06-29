//
//  OrderListViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderListViewController.h"
#import "BAFCenterViewController.h"
#import "OrderListTableViewCell.h"
#import "HRLOrderInterface.h"
#import "HRLogicManager.h"
#import "BAFUserModelManger.h"

#define OrderListTableViewCellIdentifier   @"OrderListTableViewCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexOrderList,
};

@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *noneView;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (weak, nonatomic) IBOutlet UIButton *ongoingButton;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (strong, nonatomic) UIView *buttonView;

@property (strong, nonatomic) NSMutableArray *orderListArr;
@end



@implementation OrderListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.buttonView];
    self.orderListArr = [NSMutableArray array];
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [self setNavigationTitle:@"我的订单"];
    
    self.ongoingButton.selected = YES;
    self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.ongoingButton.frame), screenWidth/2, 2);

    [self orderListRequestWithOrderstatus:@"1"];//进行中
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (IBAction)segementSelect:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"进行中"]) {
        [self orderListRequestWithOrderstatus:@"1"];
        self.ongoingButton.selected = YES;
        self.finishedButton.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.ongoingButton.frame), screenWidth/2, 2);
        } completion:^(BOOL finished) {
            if (finished) {
            }
        }];
        
    }else{
        [self orderListRequestWithOrderstatus:@"2"];
        self.ongoingButton.selected = NO;
        self.finishedButton.selected = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.buttonView.frame = CGRectMake(screenWidth/2,CGRectGetMaxY(self.ongoingButton.frame), screenWidth/2, 2);
        } completion:^(BOOL finished) {
        }];
    }
    
}

#pragma mark - setter&getter
- (UIView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
        [_buttonView setBackgroundColor:[UIColor colorWithHex:0x3492e9]];
        _buttonView.userInteractionEnabled = YES;
    }
    return _buttonView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 188.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderListTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderListTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
    }
    cell.orderDic = [self.orderListArr objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - request
- (void)orderListRequestWithOrderstatus:(NSString *)ordrstatus
{
    //1进行中 2已完成
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [orderReq orderListRequestWithNumberIndex:kRequestNumberIndexOrderList delegte:self client_id:userInfo.clientid order_status:ordrstatus];
}


#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexOrderList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self.orderListArr removeAllObjects];
            self.orderListArr = [NSMutableArray arrayWithArray:[obj objectForKey:@"data"]];
            [self.mytableview  reloadData];
        }else{
            [self.orderListArr removeAllObjects];
            [self.mytableview reloadData];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
