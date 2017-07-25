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
#import "BAFParkAir.h"
#import "ParkListViewController.h"
#import "HRLOrderInterface.h"
#import "SuccessViewController.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCityList,
    kRequestNumberIndexGetAir,
    kRequestNumberIndexGetParkByAid,
    kRequestNumberIndexEditOrder,
    kRequestNumberIndexOrderDetail,
};

#define OrderTableViewCellIdentifier            @"OrderTableViewCellIdentifier"

@interface BAFOrderViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFooterViewDelegate,OrderTableViewCellDelegate,PopViewControllerDelegate,IUICallbackInterface>
{
    NSString *_chargeRemark;
    NSDate *_goDate;
    NSDate *_backDate;
}
@property (strong, nonatomic) IBOutlet OrderFooterView  *footerView;
@property (nonatomic, strong) IBOutlet UITableView      *mainTableView;
@property (nonatomic, strong) NSMutableArray<BAFCityInfo *>       *cityArr;
@property (nonatomic, strong) NSMutableArray<BAFParkAir *>        *parkAirArr;
@property (nonatomic, strong) NSMutableArray<BAFParkInfo *>       *parkArr;
@end


@implementation BAFOrderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dicDatasource = [NSMutableDictionary dictionary];
    _cityArr = [NSMutableArray array];
    _parkAirArr = [NSMutableArray array];
    _parkArr = [NSMutableArray array];
    _chargeRemark = @"";
    self.footerView.delegate = self;
    self.mainTableView.tableFooterView = self.footerView;
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.mainTableView.separatorColor = [UIColor colorWithHex:0xc9c9c9];
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
    
    
    if (self.type == kBAFOrderViewControllerTypeOrder) {
        //预约
        [self.footerView.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.footerView.tipsLabel.text = @"1.返程未定时，取车时间可留空。后续情提前到订单中预约您的取车时间，以便我们及时为您服务。\n2.如有疑问，请致电3008138666联系客服。";
        
        [self cityListRequest];
        if ([_dicDatasource objectForKey:OrderParamTypePark]) {
            [self.mainTableView reloadData];
        }
        
        if (self.cityid) {
            [_dicDatasource setObject:self.cityid forKey:OrderParamTypeCity];
            self.cityid = nil;
        }
        if ([_dicDatasource objectForKey:OrderParamTypeCity]) {
            NSString *cityid = [_dicDatasource objectForKey:OrderParamTypeCity];
            NSArray *tempCityId = [cityid componentsSeparatedByString:@"&"];
            [self setNavigationRightButtonWithText:tempCityId[0] method:@selector(rightBtnClicked:)];
            [self parkAirRequestWithCityId:tempCityId[1]];
        }else{
            BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
            if (userInfo.cityname) {
                [self setNavigationRightButtonWithText:userInfo.cityname method:@selector(rightBtnClicked:)];
                [self parkAirRequestWithCityId:userInfo.caddr];//城市默认北京
                [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@", userInfo.cityname,userInfo.caddr] forKey:OrderParamTypeCity];
            }
            else{
                [self setNavigationRightButtonWithText:@"北京" method:@selector(rightBtnClicked:)];
                [self parkAirRequestWithCityId:@"1"];//城市默认北京
                [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@", @"北京",@"1"] forKey:OrderParamTypeCity];
            }
        }
        
    }else{
        //修改
        [self.footerView.nextBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.footerView.tipsLabel.text = @"修改订单不支持更改出发航站楼和停车场，如需更改信息请取消订单后重新下单。";
        
        //根据cityid获取城市名称？？？
        [self parkAirRequestWithCityId:[self.orderDicForModify objectForKey:@"city_id"]];//城市默认北京
        
        [self orderDetailRequestWithOrdersid:[self.orderDicForModify objectForKey:@"id"]];
    }
    
}

- (void)backMethod:(id)sender
{
//    [self.navigationController  popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender
{
    if (self.type == kBAFOrderViewControllerTypeOrder) {
        PopViewController *popView = [[PopViewController alloc] init];
        popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.definesPresentationContext = YES;
        popView.delegate = self;
        [popView configViewWithData:self.cityArr type:kPopViewControllerTypeSelecCity];
        [self presentViewController:popView animated:NO completion:nil];
    }else{
        //城市固定不能选择
    }
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
    return 0.5;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    UIView *linetop = [[UIView alloc]initWithFrame:CGRectZero];
    [linetop setBackgroundColor:[UIColor colorWithHex:0xc9c9c9]];
    UIView *linebottom = [[UIView alloc]initWithFrame:CGRectZero];
    [linebottom setBackgroundColor:[UIColor colorWithHex:0xc9c9c9]];
    [sectionFooterView addSubview:linetop];
    [sectionFooterView addSubview:linebottom];
    if (section == 0) {
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 9.5)];
        [linetop setFrame:CGRectMake(0, 0, screenWidth, 0.5)];
        [linebottom setFrame:CGRectMake(0, 9, screenWidth, 0.5)];
    }else if(section == 1){
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 29.5)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, screenWidth-24, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:13.0f];
        label.textColor = [UIColor colorWithHex:0x969696];
        label.text = _chargeRemark;
        [sectionFooterView addSubview:label];
        [linetop setFrame:CGRectMake(0, 0, screenWidth, 0.5)];
        [linebottom setFrame:CGRectMake(0, 29, screenWidth, 0.5)];
    }else if(section == 2){
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 9.5)];
        [linetop setFrame:CGRectMake(0, 0, screenWidth, 0.5)];
        [linebottom setFrame:CGRectMake(0, 9, screenWidth, 0.5)];
    }else{
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 0.5)];
        [linetop setFrame:CGRectMake(0, 0, screenWidth, 0.5)];
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
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0 ) {
            cell.type = kOrderTableViewCellTypeGoTime;
            if ([_dicDatasource objectForKey:OrderParamTypeGoTime]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                id strDate = [_dicDatasource objectForKey:OrderParamTypeGoTime];
                if ([strDate isKindOfClass:[NSDate class]]) {
                    [cell setOrderTFText:[dateFormatter stringFromDate:strDate]];
                }
                if ([strDate isKindOfClass:[NSString class]]) {
                    [cell setOrderTFText:strDate];
                }
            }
        }else if(row == 1){
            cell.type = kOrderTableViewCellTypeGoParkTerminal;
            if ([_dicDatasource objectForKey:OrderParamTypeTerminal]) {
                NSArray *arr = [[_dicDatasource objectForKey:OrderParamTypeTerminal] componentsSeparatedByString:@"&"];
                if (arr.count>1) {
                    [cell setOrderTFText:arr[0]];
                }else{
                    [cell setOrderTFText:[_dicDatasource objectForKey:OrderParamTypeTerminal]];
                }
            }
        }
    }else if (section == 1){
        cell.type = kOrderTableViewCellTypePark;
        if ([_dicDatasource objectForKey:OrderParamTypePark]) {
            NSArray *arr = [[_dicDatasource objectForKey:OrderParamTypePark] componentsSeparatedByString:@"&"];
            if (arr.count>1) {
                [cell setOrderTFText:arr[0]];
            }else{
                [cell setOrderTFText:[_dicDatasource objectForKey:OrderParamTypePark]];
            }
            
        }
    }else if (section == 2){
        if (row == 0) {
            cell.type = kOrderTableViewCellTypeBackTime;
            if ([_dicDatasource objectForKey:OrderParamTypeTime]) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                id strDate = [_dicDatasource objectForKey:OrderParamTypeTime];
                if ([strDate isKindOfClass:[NSDate class]]) {
                    [cell setOrderTFText:[dateFormatter stringFromDate:strDate]];
                }
                if ([strDate isKindOfClass:[NSString class]]) {
                    if (![strDate isEqualToString:@"0000-00-00 00:00:00"]) {
                        [cell setOrderTFText:strDate];
                    }
                }
            }
        }else{
            cell.type = kOrderTableViewCellTypeBackTerminal;
            if ([_dicDatasource objectForKey:OrderParamTypeBackTerminal]&&![[_dicDatasource objectForKey:OrderParamTypeBackTerminal] isEqualToString:@"0"]) {
                NSArray *arr = [[_dicDatasource objectForKey:OrderParamTypeBackTerminal] componentsSeparatedByString:@"&"];
                if (arr.count>1) {
                    [cell setOrderTFText:arr[0]];
                }else{
                    [cell setOrderTFText:[_dicDatasource objectForKey:OrderParamTypeBackTerminal]];
                }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == kBAFOrderViewControllerTypeOrder) {
        [self orderCellClickedDelegate:[tableView cellForRowAtIndexPath:indexPath]];
    }else if(self.type == kBAFOrderViewControllerTypeModifyAll){
        if (indexPath.section == 2||indexPath.section == 3 ||(indexPath.section == 0&&indexPath.row == 0)) {
            [self orderCellClickedDelegate:[tableView cellForRowAtIndexPath:indexPath]];
        }else{
            [self showTipsInView:self.view message:@"如需更改，请取消订单充新下单" offset:self.view.center.x+100];
        }
    }else if(self.type == kBAFOrderViewControllerTypeModifyPart){
        if (indexPath.section != 1&&indexPath.section != 0) {
            [self orderCellClickedDelegate:[tableView cellForRowAtIndexPath:indexPath]];
        }else{
            [self showTipsInView:self.view message:@"如需更改，请取消订单充新下单" offset:self.view.center.x+100];
        }
    }

    
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
    if (self.type == kBAFOrderViewControllerTypeOrder) {
        if (![_dicDatasource objectForKey:OrderParamTypeGoTime]) {
            [self showTipsInView:self.view message:@"请先选择出发时间" offset:self.view.center.x+100];
        }else if(![_dicDatasource objectForKey:OrderParamTypeTerminal]) {
            [self showTipsInView:self.view message:@"请先选择出发航站楼" offset:self.view.center.x+100];
        }else if(![_dicDatasource objectForKey:OrderParamTypePark]) {
            [self showTipsInView:self.view message:@"请先选择停车场" offset:self.view.center.x+100];
        }else{
            int days = -1;
            if ([_dicDatasource objectForKey:OrderParamTypeTime]) {
                NSDate *gotime = [_dicDatasource objectForKey:OrderParamTypeGoTime];
                NSDate *backtime = [_dicDatasource objectForKey:OrderParamTypeTime];
                NSComparisonResult result = [gotime compare:backtime];
                if (result != NSOrderedAscending) {
                    [self showTipsInView:self.view message:@"取车时间不能小于泊车时间" offset:self.view.center.x+100];
                    return;
                }
                NSTimeInterval time = [_backDate timeIntervalSinceDate:_goDate];
                //开始时间和结束时间的中间相差的时间
                days = ((int)time)/(3600*24);  //一天是24小时*3600秒
            }
            [_dicDatasource setObject:[NSString stringWithFormat:@"%d",days] forKey:OrderParamTypePark_day];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrderDefaults];
            }
            [[NSUserDefaults standardUserDefaults]setObject:self.dicDatasource  forKey:OrderDefaults];
            [[NSUserDefaults standardUserDefaults]synchronize];
            BAFOrderServiceViewController *orderServiceVC = [[BAFOrderServiceViewController alloc]init];
            [self.navigationController pushViewController:orderServiceVC animated:YES];
        }
    }else{
        id strDate = [_dicDatasource objectForKey:OrderParamTypeTime];
        if ([strDate isKindOfClass:[NSString class]]) {
            if (![strDate isEqualToString:@"0000-00-00 00:00:00"]) {
                NSDate *gotime = [_dicDatasource objectForKey:OrderParamTypeGoTime];
                NSDate *backtime = [_dicDatasource objectForKey:OrderParamTypeTime];
                NSComparisonResult result = [gotime compare:backtime];
                if (result != NSOrderedAscending) {
                    [self showTipsInView:self.view message:@"取车时间不能小于泊车时间" offset:self.view.center.x+100];
                    return;
                }
            }
        }
        [self editOrder];
    }
    
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
                [popView configViewWithData:self.parkAirArr type:kPopViewControllerTypeSelecGoTerminal];
            }else{
                [popView configViewWithData:self.parkAirArr type:kPopViewControllerTypeSelecBackTerminal];
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
                parklistVC.dicDatasource = _dicDatasource;
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    switch (type) {
        case kPopViewControllerTypeGoTime:
        {
            _goDate = popview.selectedDate;
            [_dicDatasource setObject:[dateFormatter stringFromDate:popview.selectedDate] forKey:OrderParamTypeGoTime];
            [self.mainTableView reloadData];
        }
            break;
        case kPopViewControllerTypeBackTime:
        {
            _backDate = popview.selectedDate;
            [_dicDatasource setObject:[dateFormatter stringFromDate:popview.selectedDate] forKey:OrderParamTypeTime];
            [self.mainTableView reloadData];
        }
            break;
        case kPopViewControllerTypeSelecCity:
        {
            BAFCityInfo *currentCity = ((BAFCityInfo *)[self.cityArr objectAtIndex:popview.selectedIndex.row]);
            DLog(@"当前选择城市%@",currentCity.title);
            [self setNavigationRightButtonWithText:currentCity.title method:@selector(rightBtnClicked:)];
            [_dicDatasource removeAllObjects];
            [self.mainTableView reloadData];
            [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@",currentCity.title,currentCity.id] forKey:OrderParamTypeCity];
            [self parkAirRequestWithCityId:currentCity.id];
        }
            break;
        case kPopViewControllerTypeSelecGoTerminal:
        case kPopViewControllerTypeSelecBackTerminal:
        {
            BAFParkAir *currentPark = ((BAFParkAir *)[self.parkAirArr objectAtIndex:popview.selectedIndex.row]);
            if (type == kPopViewControllerTypeSelecGoTerminal) {
                 [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@",currentPark.title,currentPark.id] forKey:OrderParamTypeTerminal];
            }else{
                 [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@",currentPark.title,currentPark.id] forKey:OrderParamTypeBackTerminal];
            }
            if (type == kPopViewControllerTypeSelecBackTerminal) {
                [self.mainTableView reloadData];
            }else{
                [self getParkByAid:currentPark.id];
            }
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

- (void)parkAirRequestWithCityId:(NSString *)cityid
{
    id <HRLParkInterface> parkReq = [[HRLogicManager sharedInstance] getParkReqest];
    [parkReq getAirByCidRequestWithNumberIndex:kRequestNumberIndexGetAir delegte:self city_id:cityid];
}

- (void)getParkByAid:(NSString *)parkid
{
    id <HRLParkInterface> parkReq = [[HRLogicManager sharedInstance] getParkReqest];
    [parkReq getParkByAidRequestWithNumberIndex:kRequestNumberIndexGetParkByAid delegte:self air_id:parkid];
}

- (void)orderDetailRequestWithOrdersid:(NSString *)order_id
{
    //订单详情
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [orderReq orderDetailRequestWithNumberIndex:kRequestNumberIndexOrderDetail delegte:self order_id:order_id];
}

- (void)editOrder
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    

    if ([self.dicDatasource objectForKey:OrderParamTypeGoTime]) {
        NSString *str = [self.dicDatasource objectForKey:OrderParamTypeGoTime];
        [mutDic setObject:str  forKey:@"plan_park_time"];
    }
    if ([self.dicDatasource objectForKey:OrderParamTypeTime]&&![[self.dicDatasource objectForKey:OrderParamTypeTime] isEqualToString:@"0000-00-00 00:00:00"]) {
        NSString *str = [self.dicDatasource objectForKey:OrderParamTypeTime];
        [mutDic setObject:str  forKey:@"plan_pick_time"];
    }
    if ([self.dicDatasource objectForKey:OrderParamTypeBackTerminal]&&![[_dicDatasource objectForKey:OrderParamTypeBackTerminal] isEqualToString:@"0"]) {
        NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypeBackTerminal] componentsSeparatedByString:@"&"];
        if (arr.count>1) {
            [mutDic setObject:arr[1] forKey:@"back_terminal_id"];
        }else{
            [mutDic setObject:arr[0] forKey:@"back_terminal_id"];
        }
        
    }
    if ([self.dicDatasource objectForKey:OrderParamTypeCompany]) {
        [mutDic setObject:[self.dicDatasource objectForKey:OrderParamTypeCompany] forKey:@"leave_passenger_number"];
    }else{
        [mutDic setObject:@"1" forKey:@"leave_passenger_number"];
    }
    [mutDic setObject:[self.orderDicForModify objectForKey:@"id"] forKey:@"order_id"];
    [orderReq editOrderRequestWithNumberIndex:kRequestNumberIndexEditOrder delegte:self param:mutDic];
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
    
    
    if (aRequestID == kRequestNumberIndexGetAir) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //航站楼列表
            if (self.parkAirArr) {
                [self.parkAirArr removeAllObjects];
            }
            self.parkAirArr = [BAFParkAir mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexGetParkByAid) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //停车场列表
            if (self.parkArr) {
                [self.parkArr removeAllObjects];
            }
            self.parkArr = [BAFParkInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
            
            if (self.parkArr) {
                [_dicDatasource setObject:[NSString stringWithFormat:@"%@&%@",self.parkArr[0].map_title,self.parkArr[0].map_id] forKey:OrderParamTypePark];
//                _chargeRemark = self.parkArr[0].map_charge.remark;
                _chargeRemark = [NSString stringWithFormat:@"该车场收费标准为：%@",self.parkArr[0].map_price];
                [_dicDatasource setObject:self.parkArr[0].map_charge.first_day_price forKey:OrderParamTypeParkFeeFirstDay];
                [_dicDatasource setObject:self.parkArr[0].map_charge.market_price forKey:OrderParamTypeParkFeeDay];
                [_dicDatasource setObject:self.parkArr[0].map_address forKey:OrderParamTypeParkLocation];
                
                
                [self.mainTableView reloadData];
            }
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexEditOrder) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //修改订单
            [self showTipsInView:self.view message:@"订单修改成功" offset:self.view.center.x+100];
        }else{
            [self showTipsInView:self.view message:[obj objectForKey:@"message"] offset:self.view.center.x+100];
        }
    }
    
    
    if (aRequestID == kRequestNumberIndexOrderDetail) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            //订单详情
            NSDictionary *resultDic = [obj objectForKey:@"data"];
            self.dicDatasource = [NSMutableDictionary dictionaryWithDictionary:self.orderDicForModify];
            if ([resultDic objectForKey:@"leave_terminal_name"]&&![[resultDic objectForKey:@"leave_terminal_name"] isEqual:[NSNull null]]) {
                NSString *str = [NSString stringWithFormat:@"%@&%@",[resultDic objectForKey:@"leave_terminal_name"],[resultDic objectForKey:@"leave_terminal_id"]];
                [self.dicDatasource setObject:str forKey:@"leave_terminal_id"];
            }
            
            if ([resultDic objectForKey:@"back_terminal_name"]&&![[resultDic objectForKey:@"back_terminal_name"] isEqual:[NSNull null]]) {
                NSString *str = [NSString stringWithFormat:@"%@&%@",[resultDic objectForKey:@"back_terminal_name"],[resultDic objectForKey:@"back_terminal_id"]];
                [self.dicDatasource setObject:str forKey:@"back_terminal_id"];
            }
            
            if ([self.orderDicForModify objectForKey:@"park_name"]&&![[self.orderDicForModify objectForKey:@"park_name"] isEqual:[NSNull null]]) {
                NSString *str = [NSString stringWithFormat:@"%@&%@",[self.orderDicForModify objectForKey:@"park_name"],[resultDic objectForKey:@"park_id"]];
                [self.dicDatasource setObject:str forKey:@"park_id"];
            }
            
            [self.mainTableView reloadData];
        }else{
            [self showTipsInView:self.view message:[obj objectForKey:@"message"] offset:self.view.center.x+100];
        }
    }
    
    
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}
@end
