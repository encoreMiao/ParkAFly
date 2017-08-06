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
#import "ParkDetailViewController.h"
#import "BAFLoginViewController.h"
#import "MapViewController.h"

#define  ParkListTableViewCelldentifier     @"ParkListTableViewCelldentifier"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCityList,
    kRequestNumberIndexParkList,
};

@interface ParkListViewController ()<UITableViewDelegate,UITableViewDataSource,PopViewControllerDelegate,ParkListTableViewCellDelegate>
@property (nonatomic, weak) IBOutlet  UITableView *mainTableView;
@property (nonatomic, strong) NSString *currentCityID;
@property (nonatomic, strong) NSString *currentCityTitle;
@property (nonatomic, strong) NSMutableArray<BAFCityInfo *>        *cityArr;
@property (nonatomic, strong) NSMutableArray<BAFParkInfo *>        *parkArr;
@end

@implementation ParkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityArr = [NSMutableArray array];
    self.parkArr = [NSMutableArray array];
    self.currentCityID = nil;
    self.currentCityTitle = nil;
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationTitle:@"停车场列表"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self cityListRequest];
    
   
    if (self.dicDatasource) {
        NSArray *tempCityId = [[self.dicDatasource objectForKey:OrderParamTypeCity] componentsSeparatedByString:@"&"];
        if (self.type == kParkListViewControllerTypeShow) {
            [self setNavigationRightButtonWithText:tempCityId[0] image:[UIImage imageNamed:@"parking_cbb"] method:@selector(rightBtnClicked:)];
        }
        [self parkListRequestWithCityId:tempCityId[1]];
    }else{
        if (self.currentCityTitle &&self.currentCityID) {
            if (self.type == kParkListViewControllerTypeShow) {
                [self setNavigationRightButtonWithText:self.currentCityTitle image:[UIImage imageNamed:@"parking_cbb"] method:@selector(rightBtnClicked:)];
            }
            [self parkListRequestWithCityId:self.currentCityID];//城市默认北京
        }else{
            if (self.type == kParkListViewControllerTypeShow) {
                [self setNavigationRightButtonWithText:@"北京" image:[UIImage imageNamed:@"parking_cbb"] method:@selector(rightBtnClicked:)];
            }
            [self parkListRequestWithCityId:@"1"];//城市默认北京
        }
    }
    
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
            if ([_dicDatasource objectForKey:OrderParamTypePark]) {
                NSArray *arr = [[_dicDatasource objectForKey:OrderParamTypePark] componentsSeparatedByString:@"&"];
                if (parkinfo.map_id == arr[1]) {
//                    [cell setSelected:YES animated:YES];
                    [cell setCitySelected:YES];
                }
            }
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
            BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
            if (userInfo.clientid) {
                cell.selected = YES;
                NSString *str = [NSString stringWithFormat:@"%@&%@",self.rightButtonText,cell.parkinfo.map_city];
                BAFOrderViewController *orderServiceVC = [[BAFOrderViewController alloc]init];
                orderServiceVC.cityid = str;
                [self.navigationController pushViewController:orderServiceVC animated:YES];
            }else{
                BAFLoginViewController  *loginVC = [[BAFLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
        }
            break;
        case kParkListTableViewCellActionTypeSelect:
        {
            BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
            if (userInfo.clientid) {
                if ([_dicDatasource objectForKey:OrderParamTypePark]) {
                    [_dicDatasource removeObjectForKey:OrderParamTypePark];
                }
                NSString *str = [NSString stringWithFormat:@"%@&%@",cell.parkinfo.map_title,cell.parkinfo.map_id];
                [_dicDatasource setObject:str forKey:OrderParamTypePark];
                [_dicDatasource setObject:cell.parkinfo.map_charge.first_day_price forKey:OrderParamTypeParkFeeFirstDay];
                [_dicDatasource setObject:cell.parkinfo.map_charge.market_price forKey:OrderParamTypeParkFeeDay];
                [_dicDatasource setObject:cell.parkinfo.map_address forKey:OrderParamTypeParkLocation];
                
                for (UIViewController *tempVC in self.navigationController.viewControllers) {
                    if ([tempVC isKindOfClass:[BAFOrderViewController class]]) {
                        ((BAFOrderViewController *)tempVC).dicDatasource = _dicDatasource;
                        [self.navigationController popToViewController:tempVC animated:YES];
                    }
                }
            }else{
                BAFLoginViewController  *loginVC = [[BAFLoginViewController alloc]init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            
            
            
        }
            break;
        case kParkListTableViewCellActionTypeDetails:
        {
            //跳到详情页
            ParkDetailViewController *vc = [[ParkDetailViewController alloc]init];
            vc.parkid = cell.parkinfo.map_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case kParkListTableViewCellActionTypeLocation:
        {
            //跳到地图页面
            MapViewController *vc = [[MapViewController alloc]init];
            vc.imageStr = cell.parkinfo.map_pic;
            vc.pointStr = cell.parkinfo.map_title;
            vc.titleStr = cell.parkinfo.map_content;
            vc.detailStr = cell.parkinfo.map_address;
            CLLocationCoordinate2D coor;
            coor.latitude = cell.parkinfo.map_lon.doubleValue;
            coor.longitude = cell.parkinfo.map_lat.doubleValue;
            vc.coor = coor;
            [self.navigationController pushViewController:vc animated:YES];
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
            self.currentCityID = currentCity.id;
            self.currentCityTitle = currentCity.title;
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
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
