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
//#import "OrderMoreCollectionViewCell.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexParkService,
};

#define OrderServiceTableViewCellIdentifier     @"OrderServiceTableViewCellIdentifier"
//#define OrderMoreCollectionViewCellIdentifier   @"OrderMoreCollectionViewCellIdentifier"

@interface BAFOrderServiceViewController ()<UITableViewDelegate, UITableViewDataSource,OrderFooterViewDelegate,OrderServiceTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet OrderFooterView *footerView;
@property (nonatomic, strong) IBOutlet UITableView  *mainTableView;
@property (nonatomic, strong) IBOutlet OrderServiceHeaderView *serviceHeaderView;
@property (nonatomic, strong) BAFUserInfo *userInfo;

@property (nonatomic, copy)     NSMutableDictionary *single_serviceDic;
@property (nonatomic, copy)     NSMutableDictionary *more_serviceDic;
@property (nonatomic, copy)     NSMutableDictionary *service_description;

@property (nonatomic, assign) BOOL isTextServiceShow;
@property (nonatomic, strong) NSIndexPath *textServiceIndexPath;
@property (nonatomic, assign) BOOL isCommonServiceShow;
@property (nonatomic, assign) BOOL isMoreServiceSelected;
@property (nonatomic, strong) NSString *singleSelectedStr;

@property (nonatomic, strong) NSMutableDictionary       *dicDatasource;
@end

@implementation BAFOrderServiceViewController
#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isTextServiceShow = NO;
    self.textServiceIndexPath = nil;
    self.isCommonServiceShow = NO;
    self.isMoreServiceSelected = NO;
    self.singleSelectedStr = nil;
    
    self.userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [self setupView];
    self.serviceHeaderView.userInfo = self.userInfo;
    
    self.footerView.nextBtn.clipsToBounds = YES;
    self.footerView.nextBtn.layer.cornerRadius = 3.0f;
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
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"list_nav_explain"] method:@selector(rightBtnClicked:)];
    
    if ([self.dicDatasource objectForKey:OrderParamTypePark]) {
        NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypePark] componentsSeparatedByString:@"&"];
        [self parkListRequestWithParkid:arr[1]];
    }
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
    
    
    [self configServiceOrder];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrderDefaults];
    }
    [[NSUserDefaults standardUserDefaults]setObject:self.dicDatasource forKey:OrderDefaults];
    BAFOrderConfirmViewController *orderConfirmVC = [[BAFOrderConfirmViewController alloc]init];
    [self.navigationController pushViewController:orderConfirmVC animated:YES];
}

- (void)configServiceOrder
{
    NSMutableArray *mutArr = [NSMutableArray array];
    if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
        mutArr = [NSMutableArray arrayWithArray:[[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"]];
        for (NSString *key in self.single_serviceDic) {
            NSDictionary *singleService = [self.single_serviceDic objectForKey:key];
            NSString *str = [NSString stringWithFormat:@"%@=>%@=>%@=>%@",[singleService objectForKey:@"charge_id"],[singleService objectForKey:@"remark"],[singleService objectForKey:@"title"],[singleService objectForKey:@"strike_price"]];
            if ([mutArr containsObject:str]) {
                [mutArr removeObject:str];
            }
            
        }
    }
    
    if (self.singleSelectedStr) {
        [mutArr addObject:self.singleSelectedStr];
    }
    if (mutArr.count>0) {
        [self.dicDatasource setObject:[mutArr componentsJoinedByString:@"&"] forKey:OrderParamTypeService];
    }
    
    
    if (self.isTextServiceShow) {
        if (self.textServiceIndexPath) {
            OrderServiceTableViewCell *cell = [self.mainTableView cellForRowAtIndexPath:self.textServiceIndexPath];
            if (cell.parkflyno) {
                [self.dicDatasource setObject:cell.parkflyno forKey:OrderParamTypeBack_flight_no];
            }
        }
    }else{
        if ([self.dicDatasource objectForKey:OrderParamTypeBack_flight_no]) {
            [self.dicDatasource removeObjectForKey:OrderParamTypeBack_flight_no];
        }
    }
}

- (void)rightBtnClicked:(id)sender
{
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.detailStr = @"默认提供停车场与航站楼之间往返的免费摆渡车服务，客户自驾车至停车场停车，乘坐车场摆渡车前往航站楼；返程时，在航站楼乘坐摆渡车回到停车场取车。\n ● 什么是代驾代泊服务\n指客户自驾车到航站楼，在约定地点将车辆交付给伯安飞专业司机代驾到停车场停放妥当；返程时由伯安飞司机在客户约定时间将车辆从停车场送往航站楼交还给客户。\n● 什么是自行往返航站楼\n指客户自驾车至停车场停车，自行车前往航站楼；返程时，自行回到停车场取车。客户不需要乘坐伯安飞摆渡车，自行往返停车场与航站楼。";
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [self configServiceOrder];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:OrderDefaults];
        }
        [[NSUserDefaults standardUserDefaults]setObject:self.dicDatasource forKey:OrderDefaults];
        
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
        if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
            NSMutableArray *mutArr = [NSMutableArray array];
            NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
            for (NSString *str in arr) {
                NSArray *arrs = [str componentsSeparatedByString:@"=>"];
                if ([arrs[0] isEqualToString:@"5"]) {
                    [mutArr addObject:[NSString stringWithFormat:@"%@%@    %.0f元",arrs[2],[self.dicDatasource objectForKey:OrderParamTypePetrol],[arrs[3] integerValue]/100.0f]];
                }
                if ([arrs[0] isEqualToString:@"6"]) {
                    [mutArr addObject:[NSString stringWithFormat:@"%@    %.0f元",arrs[2],[arrs[3] integerValue]/100.0f]];
                }
            }
            if (mutArr.count>0) {
                NSString *str = [mutArr componentsJoinedByString:@"\n"];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:6];
                CGSize titleSize = [str boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle}
                                                     context:nil].size;
                return 20+titleSize.height+42;
            }else{
                return 64;
            }
        }
        else{
            return 64;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 9.5f;
    }return 1.0f;
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
    }else{
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 1)];
        [linetop setFrame:CGRectMake(0, 0.5, screenWidth, 0.5)];
    }
    return sectionFooterView;
}
#pragma mark -  OrderServiceTableViewCellDelegate
- (void)OrderServiceTableViewCellAction:(OrderServiceTableViewCell *)cell
{
    NSString *str = [NSString stringWithFormat:@"%@=>%@=>%@=>%@",cell.serviceInfo.charge_id,cell.serviceInfo.remark,cell.serviceInfo.title,cell.serviceInfo.strike_price];
    NSIndexPath *indexpath = [self.mainTableView indexPathForCell:cell];
    if ([[self.single_serviceDic.allKeys objectAtIndex:indexpath.row] isEqualToString:@"202"]) {
        if (!cell.show) {
            NSDate *twohoursDate = [[NSDate date] dateByAddingTimeInterval:2*60*60];
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
            NSDate *parkDate =[dateFormat dateFromString:[self.dicDatasource objectForKey:OrderParamTypeGoTime]];
            if ([twohoursDate compare:parkDate] == NSOrderedDescending) {
                [self showTipsInView:self.view message:@"代泊服务需提前两小时" offset:self.view.center.x+100];
                return;
            }
        }
        self.isTextServiceShow = !cell.show;
        self.isCommonServiceShow = NO;
        
        
    }else{
        self.isTextServiceShow = NO;
        self.isCommonServiceShow = !cell.show;
    }


    self.singleSelectedStr = str;
    if (!self.isTextServiceShow&&!self.isCommonServiceShow) {
        self.textServiceIndexPath = nil;
    }else {
        if (self.isTextServiceShow) {
            self.textServiceIndexPath = indexpath;
        }else{
            self.textServiceIndexPath = nil;
        }
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
    
//    OrderMoreCollectionViewCell *orderMoreCell =  [tableView dequeueReusableCellWithIdentifier:OrderMoreCollectionViewCellIdentifier];
//    if (orderMoreCell == nil) {
//        orderMoreCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderMoreCollectionViewCell" owner:nil options:nil] firstObject];
//    }
    NSUInteger section = indexPath.section;
    if (section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        BAFParkServiceInfo *serviceInfo;
        serviceInfo = [BAFParkServiceInfo mj_objectWithKeyValues:[self.single_serviceDic objectForKey:[self.single_serviceDic.allKeys objectAtIndex:indexPath.row]]];
        if ([[self.single_serviceDic.allKeys objectAtIndex:indexPath.row] isEqualToString:@"202"]) {
            cell.type = kOrderServiceTableViewCellTypeCommonText;
            [cell setShow:self.isTextServiceShow];
            if ([self.dicDatasource objectForKey:OrderParamTypeBack_flight_no]) {
                [cell setParkflyno:[self.dicDatasource objectForKey:OrderParamTypeBack_flight_no]];
            }
        }else{
            cell.type = kOrderServiceTableViewCellTypeCommon;
            [cell setShow:self.isCommonServiceShow];
        }
        cell.serviceInfo = serviceInfo;
        
    }else{
        if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
            NSMutableArray *mutArr = [NSMutableArray array];
            NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
            for (NSString *str in arr) {
                NSArray *arrs = [str componentsSeparatedByString:@"=>"];
                if ([arrs[0] isEqualToString:@"5"]) {
                    [mutArr addObject:str];
                }
                if ([arrs[0] isEqualToString:@"6"]) {
                    [mutArr addObject:str];
                }
            }
            if (mutArr.count> 0) {
                if (mutArr.count == 1) {
                    cell.more1MoneyLabel.hidden = NO;
                    cell.more2MoneyLabel.hidden = YES;
                    cell.more1ServiceLabel.hidden = NO;
                    cell.more2ServiceLabel.hidden = YES;
                    
                    NSArray *arrs = [mutArr[0] componentsSeparatedByString:@"=>"];
                    if ([arrs[0] isEqualToString:@"5"]) {
                        cell.more1ServiceLabel.text = [NSString stringWithFormat:@"%@(%@)",arrs[2],[self.dicDatasource objectForKey:OrderParamTypePetrol]];
                    }else{
                        cell.more1ServiceLabel.text = [NSString stringWithFormat:@"%@",arrs[2]];
                    }
                    cell.more1MoneyLabel.text =[NSString stringWithFormat:@"%.0f元",[arrs[3] integerValue]/100.0f];
                }else{
                    cell.more1MoneyLabel.hidden = NO;
                    cell.more2MoneyLabel.hidden = NO;
                    cell.more1ServiceLabel.hidden = NO;
                    cell.more2ServiceLabel.hidden = NO;
                    
                    NSArray *arrs = [mutArr[0] componentsSeparatedByString:@"=>"];
                    if ([arrs[0] isEqualToString:@"5"]) {
                        cell.more1ServiceLabel.text = [NSString stringWithFormat:@"%@(%@)",arrs[2],[self.dicDatasource objectForKey:OrderParamTypePetrol]];
                    }else{
                        cell.more1ServiceLabel.text = [NSString stringWithFormat:@"%@",arrs[2]];
                    }
                    cell.more1MoneyLabel.text =[NSString stringWithFormat:@"%.0f元",[arrs[3] integerValue]/100.0f];
                    
                    NSArray *arrs1 = [mutArr[1] componentsSeparatedByString:@"=>"];
                    if ([arrs1[0] isEqualToString:@"5"]) {
                        cell.more2ServiceLabel.text = [NSString stringWithFormat:@"%@(%@)",arrs1[2],[self.dicDatasource objectForKey:OrderParamTypePetrol]];
                    }else{
                        cell.more2ServiceLabel.text = [NSString stringWithFormat:@"%@",arrs1[2]];
                    }
                    cell.more2MoneyLabel.text =[NSString stringWithFormat:@"%.0f元",[arrs1[3] integerValue]/100.0f];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.type = kOrderServiceTableViewCellTypeMore;
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.type = kOrderServiceTableViewCellTypeDisclosure;
            }
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.type = kOrderServiceTableViewCellTypeDisclosure;
        }
    }
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 10;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
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
