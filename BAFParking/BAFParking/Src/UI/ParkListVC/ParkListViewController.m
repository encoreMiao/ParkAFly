//
//  ParkListViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/11.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkListViewController.h"
#import "ParkListTableViewCell.h"
#import "HRLParkInterface.h"
#import "HRLPersonalCenterInterface.h"
#import "BAFCityInfo.h"
#import "BAFParkInfo.h"
#import "HRLogicManager.h"
#import "BAFOrderViewController.h"
#import "PopViewController.h"
#import "BAFOrderViewController.h"

#define  ParkListTableViewCelldentifier     @"ParkListTableViewCelldentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCityList,
    kRequestNumberIndexParkList,
};

@interface ParkListViewController ()<UITableViewDelegate,UITableViewDataSource,PopViewControllerDelegate,ParkListTableViewCellDelegate>
@property (nonatomic, weak) IBOutlet  UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray<BAFCityInfo *>        *cityArr;
@property (nonatomic, strong) NSMutableArray<BAFParkInfo *>        *parkArr;
@end

@implementation ParkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityArr = [NSMutableArray array];
    self.parkArr = [NSMutableArray array];
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationTitle:@"停车场列表"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationRightButtonWithText:@"北京" method:@selector(rightBtnClicked:)];
    
    [self cityListRequest];
    [self parkListRequestWithCityId:@"1"];//城市默认北京
}

- (void)backMethod:(id)sender
{
    switch (self.type) {
        case kParkListViewControllerTypeSelect:
        {
            for (UIViewController *tempVC in self.navigationController.viewControllers) {
                if ([tempVC isKindOfClass:[BAFOrderViewController class]]) {
                    [self.navigationController popToViewController:tempVC animated:YES];
                }
            }
        }
            break;
        case kParkListViewControllerTypeShow:
            [self.navigationController  popToRootViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)rightBtnClicked:(id)sender
{
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    popView.delegate = self;
    [popView configViewWithData:self.cityArr type:kPopViewControllerTypeSelecCity];
    [self presentViewController:popView animated:NO completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 252.0f/2;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parkArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkListTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkListTableViewCelldentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkListTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    BAFParkInfo *parkinfo = ((BAFParkInfo *)[self.parkArr objectAtIndex:indexPath.row]);
    switch (self.type) {
        case kParkListViewControllerTypeShow:
            [cell setParkinfo:parkinfo withtype:kParkListTableViewCellTypeShow];
            break;
        case kParkListViewControllerTypeSelect:
            [cell setParkinfo:parkinfo withtype:kParkListTableViewCellTypeSelect];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - ParkListTableViewCellDelegate
- (void)ParkListTableViewCellActionDelegate:(ParkListTableViewCell *)cell actionType:(ParkListTableViewCellActionType)actionType
{
    switch (actionType) {
        case kParkListTableViewCellActionTypeOrder:
        {
            BAFOrderViewController *orderServiceVC = [[BAFOrderViewController alloc]init];
            [self.navigationController pushViewController:orderServiceVC animated:YES];
        }
            break;
        case kParkListTableViewCellActionTypeSelect:
        {
            for (UIViewController *tempVC in self.navigationController.viewControllers) {
                if ([tempVC isKindOfClass:[BAFOrderViewController class]]) {
                    [self.navigationController popToViewController:tempVC animated:YES];
                }
            }
        }
            break;
        case kParkListTableViewCellActionTypeDetails:
        {
            //跳到详情页
        }
            break;
        case kParkListTableViewCellActionTypeLocation:
        {
            //跳到地图页面
        }
            break;
        default:
            break;
    }
}
#pragma mark - PopViewControllerDelegate
- (void)popviewConfirmButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview
{
    switch (type) {
        case kPopViewControllerTypeSelecCity:
        {
            BAFCityInfo *currentCity = ((BAFCityInfo *)[self.cityArr objectAtIndex:popview.selectedIndex.row]);
            DLog(@"当前选择城市%@",currentCity.title);
            [self setNavigationRightButtonWithText:currentCity.title method:@selector(rightBtnClicked:)];
            [self parkListRequestWithCityId:currentCity.id];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Request
- (void)cityListRequest
{
    id <HRLPersonalCenterInterface> personCenterReq = [[HRLogicManager sharedInstance] getPersonalCenterReqest];
    [personCenterReq cityListRequestWithNumberIndex:kRequestNumberIndexCityList delegte:self];
}

- (void)parkListRequestWithCityId:(NSString *)cityid
{
    id <HRLParkInterface> parkReq = [[HRLogicManager sharedInstance] getParkReqest];
    [parkReq parkListRequestWithNumberIndex:kRequestNumberIndexParkList delegte:self city_id:cityid];
}


#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexCityList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //城市列表
            if (self.cityArr) {
                [self.cityArr removeAllObjects];
            }
            self.cityArr = [BAFCityInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
            
        }else{
            //
        }
    }
    
    
    if (aRequestID == kRequestNumberIndexParkList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //停车场列表
            if (self.parkArr) {
                [self.parkArr removeAllObjects];
            }
            self.parkArr = [BAFParkInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
            [self.mainTableView reloadData];
        }else{
            //
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
