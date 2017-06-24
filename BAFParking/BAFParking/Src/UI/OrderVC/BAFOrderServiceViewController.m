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
#import "BAFMoreServicesViewController.h"
#import "PopViewController.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexParkService,
};

#define OrderServiceTableViewCellIdentifier @"OrderServiceTableViewCellIdentifier"

@interface BAFOrderServiceViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFooterViewDelegate,OrderServiceTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet OrderFooterView *footerView;
@property (nonatomic, strong) IBOutlet UITableView  *mainTableView;
@property (nonatomic, strong) IBOutlet OrderServiceHeaderView *serviceHeaderView;
@property (nonatomic, strong) BAFUserInfo *userInfo;

@property (nonatomic, copy)     NSMutableDictionary *single_serviceDic;
@property (nonatomic, copy)     NSMutableDictionary *more_serviceDic;
@property (nonatomic, copy)     NSMutableDictionary *service_description;

@property (nonatomic, assign) BOOL isTextServiceShow;
@property (nonatomic, assign) BOOL isCommonServiceShow;
@property (nonatomic, assign) BOOL isMoreServiceSelected;

@property (nonatomic, strong) NSMutableDictionary       *dicDatasource;
@end

@implementation BAFOrderServiceViewController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.dicDatasource = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
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
    self.dicDatasource = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationTitle:@"预约停车"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationRightButtonWithText:@"说明" method:@selector(rightBtnClicked:)];
    self.serviceHeaderView.userInfo = self.userInfo;
    
//    if ([self.dicDatasource objectForKey:OrderParamTypePark]) {
//        NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypePark] componentsSeparatedByString:@"&"];
//        [self parkListRequestWithParkid:arr[1]];
//    }
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

#pragma mark - actions
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
    if ([self.serviceHeaderView.nameTF.text length]<=0) {
        [self showTipsInView:self.view message:@"请输入姓名" offset:self.view.center.x+100];
        return;
    }
    
    if ([self.serviceHeaderView.phoneTF.text length]<=0) {
        [self showTipsInView:self.view message:@"请输入手机号码" offset:self.view.center.x+100];
        return;
    }

    if (![self checkCarID:self.serviceHeaderView.licenseTF.text]) {
        [self showTipsInView:self.view message:@"请输入正确车牌号码" offset:self.view.center.x+100];
        return;
    }
    
    [self.dicDatasource setObject:self.serviceHeaderView.nameTF.text forKey:OrderParamTypeContact_name];
    [self.dicDatasource setObject:self.serviceHeaderView.phoneTF.text forKey:OrderParamTypeContact_phone];
    [self.dicDatasource setObject:self.serviceHeaderView.licenseTF.text forKey:OrderParamTypeCar_license_no];
    [self.dicDatasource setObject:[NSString stringWithFormat:@"%d",self.serviceHeaderView.sexInt] forKey:OrderParamTypeContact_gender];
    
    BAFOrderConfirmViewController *orderConfirmVC = [[BAFOrderConfirmViewController alloc]init];
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

- (void)rightBtnClicked:(id)sender
{
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    [popView configViewWithData:nil type:kPopViewControllerTypeTop];
    [self presentViewController:popView animated:NO completion:nil];
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
    if (indexPath.section == 1) {
        BAFMoreServicesViewController *moreServiceVC = [[BAFMoreServicesViewController alloc]init];
        [self.navigationController pushViewController:moreServiceVC animated:YES];
        moreServiceVC.more_serviceDic = self.more_serviceDic;
        moreServiceVC.service_description = self.service_description;
    }
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
#pragma mark - requestdelegate
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
            self.service_description = [[obj objectForKey:@"data"] objectForKey:@"service_description"];
            [self.mainTableView reloadData];
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

//车牌号验证
- (BOOL)checkCarID:(NSString *)carID;
{
    if (carID.length!=7) {
        return NO;
    }
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-hj-zA-HJ-Z]{1}[a-hj-zA-HJ-Z_0-9]{4}[a-hj-zA-HJ-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];
    
    return YES;
}

@end
