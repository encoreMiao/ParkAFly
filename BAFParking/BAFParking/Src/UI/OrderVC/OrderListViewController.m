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
#import "BAFOrderViewController.h"
#import "CommentViewController.h"
#import "PayOrderViewController.h"
#import "OrderDetailViewController.h"
#import "SuccessViewController.h"

#define OrderListTableViewCellIdentifier   @"OrderListTableViewCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexOrderList,
    kRequestNumberIndexCancelOrder,
};

@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate,OrderListTableViewCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *noneView;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (weak, nonatomic) IBOutlet UIButton *ongoingButton;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (strong, nonatomic) UIView *buttonView;

@property (strong, nonatomic) NSMutableArray *orderListArr;

@property (strong, nonatomic) NSString *cancelOrderStr;
@end



@implementation OrderListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.buttonView];
    self.orderListArr = [NSMutableArray array];
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytableview.backgroundColor = [UIColor colorWithHex:0xffffff];
    
    
    self.ongoingButton.selected = YES;
    self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.ongoingButton.frame), screenWidth/2, 2);
    [self orderListRequestWithOrderstatus:@"1"];//进行中
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
    
    
}

- (void)backMethod:(id)sender
{
    if (self.isFromLeftVC) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        [self.navigationController popViewControllerAnimated:YES];
        for (UIViewController *tempVC in self.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
                [self.navigationController popToViewController:tempVC animated:YES];
            }
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
    return 200.0f;
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
        cell.delegate = self;
    }
    cell.orderDic = [self.orderListArr objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - OrderListTableViewCellDelegate
- (void)orderBtnActionTag:(NSInteger)btnTag cell:(OrderListTableViewCell *)cell
{
//    PayOrderViewController  *vc = [[PayOrderViewController alloc]init];
//    vc.orderDic = cell.orderDic;
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    NSLog(@"%@",cell.orderDic);
    //修改时提交按钮为保存，泊车时间定位到当前时间两小时之后
    switch (btnTag) {
        case kOrderListTableViewCellTypeModifyAll:
        {
            NSLog(@"实际未停车，锁定出发航站楼、停车场项，其他信息可修改(如需修改，需联系客服或重新下单)");
            BAFOrderViewController  *orderVC = [[BAFOrderViewController alloc]init];
            orderVC.handler = ^(void){
                [self orderListRequestWithOrderstatus:@"1"];
                [self segementSelect:self.ongoingButton];
            };
            orderVC.type = kBAFOrderViewControllerTypeModifyAll;
            orderVC.orderDicForModify = cell.orderDic;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case kOrderListTableViewCellTypeModifyPart:
        {
            NSLog(@"实际已停车，修改时锁定泊车时间、出发航站楼、停车场项，只能修改取车时间、返程航站楼，保存后提交");
            BAFOrderViewController  *orderVC = [[BAFOrderViewController alloc]init];
            orderVC.handler = ^(void){
                [self orderListRequestWithOrderstatus:@"1"];
                [self segementSelect:self.ongoingButton];
            };
            orderVC.type = kBAFOrderViewControllerTypeModifyPart;
            orderVC.orderDicForModify = cell.orderDic;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        case kOrderListTableViewCellTypeCancel:
        {
            NSLog(@"未停车可取消");
            self.cancelOrderStr = [cell.orderDic objectForKey:@"id"];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确定取消么" message:nil delegate:self cancelButtonTitle:@"不取消了" otherButtonTitles:@"确定取消",nil];
            [alertView show];
        }
            break;
        case kOrderListTableViewCellTypePay:
        {
            NSLog(@"车场端【确认取车】后可进行支付，点击跳转到订单支付");
            PayOrderViewController  *vc = [[PayOrderViewController alloc]init];
            vc.orderDic = cell.orderDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kOrderListTableViewCellTypeComment:
        {
            NSLog(@"已完成订单评价：支付完成的订单可进行评价(线上支付完成的当时即可评价)");
            CommentViewController  *vc = [[CommentViewController alloc]init];
            vc.type = kCommentViewControllerTypeComment;
            vc.commentfinishHandler = ^(void){
                //评价完成
                [self segementSelect:self.finishedButton];
            };
            vc.orderDic = cell.orderDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kOrderListTableViewCellTypeCheckComment:
        {
            NSLog(@"已完成订单查看评价。");
            CommentViewController  *vc = [[CommentViewController alloc]init];
            vc.type = kCommentViewControllerTypeCommentCheck;
            vc.orderDic = cell.orderDic;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kOrderListTableViewCellTypeDetail:
        {
            NSLog(@"查看订单详情");
            OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
            vc.orderIdStr = [cell.orderDic objectForKey:@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        //确定取消
        [self cancelOrderWithOrderid:self.cancelOrderStr];
    }else if (buttonIndex == 0){
        //不取消了
    }
}

#pragma mark - request
- (void)orderListRequestWithOrderstatus:(NSString *)ordrstatus
{
    //1进行中 2已完成
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [orderReq orderListRequestWithNumberIndex:kRequestNumberIndexOrderList delegte:self client_id:userInfo.clientid order_status:ordrstatus];
}

- (void)cancelOrderWithOrderid:(NSString *)order_id
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [orderReq cancelOrderRequestWithNumberIndex:kRequestNumberIndexCancelOrder delegte:self order_id:order_id];
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
        }else{
            [self.orderListArr removeAllObjects];
            
        }

        if (self.orderListArr.count<=0) {
            [self.noneView setFrame:CGRectMake(0, 0, screenWidth,195)];
            self.mytableview.tableHeaderView = self.noneView;
            self.mytableview.backgroundColor = [UIColor colorWithHex:0xffffff];
        }else{
            self.mytableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
            self.mytableview.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        }
        
        [self.mytableview reloadData];
    }
    
    if (aRequestID == kRequestNumberIndexCancelOrder) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self orderListRequestWithOrderstatus:@"1"];
            [self showTipsInView:self.view message:@"取消成功" offset:self.view.center.x+100];
        }else{
             [self showTipsInView:self.view message:@"取消失败" offset:self.view.center.x+100];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
