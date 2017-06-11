//
//  BAFOrderViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFOrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderFooterView.h"
#import "BAFOrderServiceViewController.h"
#import "PopViewController.h"
#import "IUCallBackInterface.h"
#import "HRLogicManager.h"
#import "HRLLoginInterface.h"
#import "HRLParkInterface.h"
#import "HRLPersonalCenterInterface.h"
#import "BAFCityInfo.h"
#import "BAFParkInfo.h"
#import "ParkListViewController.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCityList,
    kRequestNumberIndexParkList,
};

#define OrderTableViewCellIdentifier            @"OrderTableViewCellIdentifier"


//预约内容&id组合
#define OrderParamTypeGoTime            @"plan_park_time"
#define OrderParamTypeTime              @"plan_pick_time"

#define OrderParamTypePark              @"park_id"

#define OrderParamTypeTerminal          @"leave_terminal_id"
#define OrderParamTypeBackTerminal      @"back_terminal_id"

#define OrderParamTypeCompany           @"leave_passenger_number"

#define OrderParamTypeCity              @"city_id"


@interface BAFOrderViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFooterViewDelegate,OrderTableViewCellDelegate,PopViewControllerDelegate,IUICallbackInterface>
@property (strong, nonatomic) IBOutlet OrderFooterView  *footerView;
@property (nonatomic, strong) IBOutlet UITableView      *mainTableView;
@property (nonatomic, strong) NSMutableDictionary       *dicDatasource;

@property (nonatomic, strong) NSMutableArray<BAFCityInfo *>        *cityArr;
@property (nonatomic, strong) NSMutableArray<BAFParkInfo *>        *parkArr;
@end

@implementation BAFOrderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dicDatasource = [NSMutableDictionary dictionary];
    self.cityArr = [NSMutableArray array];
    self.parkArr = [NSMutableArray array];
    
    self.footerView.delegate = self;
    self.mainTableView.tableFooterView = self.footerView;
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
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
    [self setNavigationRightButtonWithText:@"北京" method:@selector(rightBtnClicked:)];
    
    [self cityListRequest];
    [self parkListRequestWithCityId:@"1"];//城市默认北京
}

- (void)backMethod:(id)sender
{
    [self.navigationController  popToRootViewControllerAnimated:YES];
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98.0f/2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }else if(section == 1){
        return 30.0f;//若选择停车场则为30
    }else if (section == 2){
        return 10.0f;
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    if (section == 0) {
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
    }else if(section == 1){
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, screenWidth-24, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithHex:0x585c64];
        label.text = @"该车场收费标准为首日60元/天，之后25元/天";
        [sectionFooterView addSubview:label];
    }else if(section == 2){
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
    }
    return sectionFooterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0 ) {
            cell.type = kOrderTableViewCellTypeGoTime;
            if ([_dicDatasource objectForKey:OrderParamTypeGoTime]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                [cell setOrderTFText:[dateFormatter stringFromDate:[_dicDatasource objectForKey:OrderParamTypeGoTime]]];
            }
        }else if(row == 1){
            cell.type = kOrderTableViewCellTypeGoParkTerminal;
            if ([_dicDatasource objectForKey:OrderParamTypeTerminal]) {
                [cell setOrderTFText:[_dicDatasource objectForKey:OrderParamTypeTerminal]];
            }
        }
    }else if (section == 1){
        cell.type = kOrderTableViewCellTypePark;
    }else if (section == 2){
        if (row == 0) {
            cell.type = kOrderTableViewCellTypeBackTime;
            if ([_dicDatasource objectForKey:OrderParamTypeTime]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                [cell setOrderTFText:[dateFormatter stringFromDate:[_dicDatasource objectForKey:OrderParamTypeTime]]];
            }
        }else{
            cell.type = kOrderTableViewCellTypeBackTerminal;
            if ([_dicDatasource objectForKey:OrderParamTypeBackTerminal]) {
                [cell setOrderTFText:[_dicDatasource objectForKey:OrderParamTypeBackTerminal]];
            }
        }
    }else{
        cell.type = kOrderTableViewCellTypeCompany;
        if ([_dicDatasource objectForKey:OrderParamTypeCompany]) {
            [cell setOrderTFText:[_dicDatasource objectForKey:OrderParamTypeCompany]];
        }
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - OrderFooterViewDelegate
- (void)nextStepButtonDelegate:(id)sender
{
//    if (![_dicDatasource objectForKey:OrderTableViewCellTypeGoTime]) {
//        [self showTipsInView:self.view message:@"请先选择出发时间" offset:self.view.center.x+100];
//    }else if(![_dicDatasource objectForKey:OrderTableViewCellTypeGoParkTerminal]) {
//        [self showTipsInView:self.view message:@"请先选择出发航站楼" offset:self.view.center.x+100];
//    }else if(![_dicDatasource objectForKey:OrderTableViewCellTypePark]) {
//        [self showTipsInView:self.view message:@"请先选择停车场" offset:self.view.center.x+100];
//    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrderDefaults];
        }
        [[NSUserDefaults standardUserDefaults]setObject:self.dicDatasource  forKey:OrderDefaults];
        [[NSUserDefaults standardUserDefaults]synchronize];
        BAFOrderServiceViewController *orderServiceVC = [[BAFOrderServiceViewController alloc]init];
        [self.navigationController pushViewController:orderServiceVC animated:YES];
//    }
}

#pragma mark - OrderTableViewCellDelegate
- (void)orderCellClickedDelegate:(OrderTableViewCell *)cell
{
    switch (cell.type) {
        case kOrderTableViewCellTypeGoTime:
        case kOrderTableViewCellTypeBackTime:
        {
            //选择时间
            PopViewController *popView = [[PopViewController alloc] init];
            popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
            self.definesPresentationContext = YES;
            popView.delegate = self;
            if (cell.type == kOrderTableViewCellTypeGoTime) {
                [popView configViewWithData:nil type:kPopViewControllerTypeGoTime];
            }else{
                [popView configViewWithData:nil type:kPopViewControllerTypeBackTime];
            }
            [self presentViewController:popView animated:NO completion:nil];
        }
            break;
        case kOrderTableViewCellTypeGoParkTerminal:
        case kOrderTableViewCellTypeBackTerminal:
        {
            //选择航站楼
            PopViewController *popView = [[PopViewController alloc] init];
            popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
            self.definesPresentationContext = YES;
            popView.delegate = self;
            if (cell.type == kOrderTableViewCellTypeGoParkTerminal) {
                [popView configViewWithData:self.parkArr type:kPopViewControllerTypeSelecGoTerminal];
            }else{
                [popView configViewWithData:self.parkArr type:kPopViewControllerTypeSelecBackTerminal];
            }
            [self presentViewController:popView animated:NO completion:nil];
        }
            break;
        case kOrderTableViewCellTypePark:
        {
            NSLog(@"park");
            if (![_dicDatasource objectForKey:OrderParamTypeTerminal]) {
                 [self showTipsInView:self.view message:@"请先选择出发航站楼" offset:self.view.center.x+100];
            }else{
                //跳转到停车场选择
                ParkListViewController  *parklistVC = [[ParkListViewController alloc]init];
                parklistVC.type = kParkListViewControllerTypeSelect;
                [self.navigationController pushViewController:parklistVC animated:YES];
            }
        }
            break;
        case kOrderTableViewCellTypeCompany:
        {
            //选择同行人数
            PopViewController *popView = [[PopViewController alloc] init];
            popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
            self.definesPresentationContext = YES;
            popView.delegate = self;
            [popView configViewWithData:@[@"1",@"2",@"3"] type:kPopViewControllerTypeCompany];
            [self presentViewController:popView animated:NO completion:nil];
        }
            break;
    }
}
#pragma mark - PopViewControllerDelegate
- (void)popviewConfirmButtonDidClickedWithType:(PopViewControllerType)type popview:(PopViewController*)popview
{
#warning 还差一个停车场停车场停车场
    switch (type) {
        case kPopViewControllerTypeGoTime:
        {
            [_dicDatasource setObject:popview.selectedDate forKey:OrderParamTypeGoTime];
            [self.mainTableView reloadData];
        }
            break;
        case kPopViewControllerTypeBackTime:
        {
            [_dicDatasource setObject:popview.selectedDate forKey:OrderParamTypeTime];
            [self.mainTableView reloadData];
        }
            break;
        case kPopViewControllerTypeSelecCity:
        {
            BAFCityInfo *currentCity = ((BAFCityInfo *)[self.cityArr objectAtIndex:popview.selectedIndex.row]);
            DLog(@"当前选择城市%@",currentCity.title);
            [self setNavigationRightButtonWithText:currentCity.title method:@selector(rightBtnClicked:)];
            [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@",currentCity.title,currentCity.id] forKey:OrderParamTypeCity];
            [self parkListRequestWithCityId:currentCity.id];
            
            [_dicDatasource removeAllObjects];
            [self.mainTableView reloadData];
        }
            break;
        case kPopViewControllerTypeSelecGoTerminal:
        case kPopViewControllerTypeSelecBackTerminal:
        {
            //要改，是航站楼，不是停车场，不是停车场不是停车场
            BAFParkInfo *currentPark = ((BAFParkInfo *)[self.parkArr objectAtIndex:popview.selectedIndex.row]);
            if (type == kPopViewControllerTypeSelecGoTerminal) {
                 [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@",currentPark.map_title,currentPark.map_id] forKey:OrderParamTypeTerminal];
            }else{
                 [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@",currentPark.map_title,currentPark.map_id] forKey:OrderParamTypeBackTerminal];
            }
            [self.mainTableView reloadData];
        }
            break;
        case kPopViewControllerTypeCompany:
        {
            NSArray *arr = @[@"1",@"2",@"3"];
            [_dicDatasource setObject:arr[popview.selectedIndex.row] forKey:OrderParamTypeCompany];
            [self.mainTableView reloadData];
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
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}
@end
