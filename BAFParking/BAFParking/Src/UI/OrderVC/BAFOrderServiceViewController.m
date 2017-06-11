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
#import "BAFUserInfo.h"
#import "BAFUserModelManger.h"
#import "HRLParkInterface.h"
#import "HRLogicManager.h"
#import "BAFParkServiceInfo.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexParkService,
};

#define OrderServiceTableViewCellIdentifier @"OrderServiceTableViewCellIdentifier"

#define OrderParamTypeService             @"service" //收费项 id=>备注，如汽油 6=>92#


@interface BAFOrderServiceViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFooterViewDelegate,OrderServiceTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet OrderFooterView *footerView;
@property (nonatomic, strong) IBOutlet UITableView  *mainTableView;
@property (nonatomic, strong) IBOutlet OrderServiceHeaderView *serviceHeaderView;
@property (nonatomic, strong) BAFUserInfo *userInfo;

@property (nonatomic, copy) NSMutableDictionary *single_serviceDic;
@property (nonatomic, copy) NSMutableDictionary *more_serviceDic;

@property (nonatomic, assign) BOOL isTextServiceShow;
@property (nonatomic, assign) BOOL isCommonServiceShow;
@property (nonatomic, assign) BOOL isMoreServiceSelected;

@property (nonatomic, strong) NSMutableDictionary       *dicDatasource;
@end

@implementation BAFOrderServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dicDatasource = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
    self.isTextServiceShow = NO;
    self.isCommonServiceShow = NO;
    self.isMoreServiceSelected = NO;
    self.userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [self setupView];
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
    
    self.serviceHeaderView.userInfo = self.userInfo;
    
    [self parkListRequestWithParkid:@"20"];
}

- (void)setupView
{
    [self.serviceHeaderView setFrame:CGRectMake(0, 0, screenWidth, 210)];
    self.mainTableView.tableHeaderView = self.serviceHeaderView;
    self.footerView.delegate = self;
    self.mainTableView.tableFooterView = self.footerView;
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
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

#pragma mark - request
- (void)parkListRequestWithParkid:(NSString *)parkid
{
    id <HRLParkInterface> parkReq = [[HRLogicManager sharedInstance] getParkReqest];
    [parkReq parkServiceRequestWithNumberIndex:kRequestNumberIndexParkService delegte:self park_id:parkid];
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
//    202.代泊费，206.自行往返航站楼 204.代加油服务，205.洗车服 务，
//    201.摆渡车费，101.车位费,203.异地取车费，
    if (indexpath.section == 0) {
        //单项服务
        if ([[self.single_serviceDic.allKeys objectAtIndex:indexpath.row] isEqualToString:@"202"]) {
            if (self.isTextServiceShow) {
                return 104.0f;
            }
            return 64.0f;
        }else{
            return 64.0f;
        }
    }
    else {
        return 64;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }return 0;
}
#pragma mark -  OrderServiceTableViewCellDelegate
- (void)OrderServiceTableViewCellAction:(OrderServiceTableViewCell *)cell
{
    NSIndexPath *indexpath = [self.mainTableView indexPathForCell:cell];
    if ([[self.single_serviceDic.allKeys objectAtIndex:indexpath.row] isEqualToString:@"202"]) {
        self.isTextServiceShow = !cell.show;
        self.isCommonServiceShow = NO;
    }else{
        self.isTextServiceShow = NO;
        self.isCommonServiceShow = !cell.show;
    }
     [self.mainTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.single_serviceDic.count;
    }else{
//        return self.more_serviceDic.count;
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderServiceTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderServiceTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderServiceTableViewCell" owner:nil options:nil] firstObject];
        cell.delegate = self;
    }
    NSUInteger section = indexPath.section;
    if (section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        BAFParkServiceInfo *serviceInfo;
        serviceInfo = [BAFParkServiceInfo mj_objectWithKeyValues:[self.single_serviceDic objectForKey:[self.single_serviceDic.allKeys objectAtIndex:indexPath.row]]];
        if ([[self.single_serviceDic.allKeys objectAtIndex:indexPath.row] isEqualToString:@"202"]) {
            cell.type = kOrderServiceTableViewCellTypeCommonText;
            [cell setShow:self.isTextServiceShow];
        }else{
            cell.type = kOrderServiceTableViewCellTypeCommon;
            [cell setShow:self.isCommonServiceShow];
        }
        cell.serviceInfo = serviceInfo;
        
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.type = kOrderServiceTableViewCellTypeDisclosure;
    }
    return cell;
}
#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexParkService) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //停车场服务列表
            self.more_serviceDic = [[obj objectForKey:@"data"] objectForKey:@"more_service"];
            self.single_serviceDic = [[obj objectForKey:@"data"] objectForKey:@"single_service"];
            [self.mainTableView reloadData];
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
