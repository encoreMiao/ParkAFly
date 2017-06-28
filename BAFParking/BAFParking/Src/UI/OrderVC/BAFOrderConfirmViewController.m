//
//  BAFOrderConfirmViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFOrderConfirmViewController.h"
#import "OrderConfirmTableViewCell.h"
#import "ServiceConfirmTableViewCell.h"
#import "BAFOrderServiceViewController.h"
#import "SuccessViewController.h"
#import "BAFOrderViewController.h"
#import "HRLOrderInterface.h"
#import "HRLogicManager.h"
#import "BAFUserModelManger.h"
#import "PopViewController.h"

#define OrderConfirmTableViewCellIdentifier @"OrderConfirmTableViewCellIdentifier"
#define ServiceConfirmTableViewCellIdentifier   @"ServiceConfirmTableViewCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexAddOrder,
};

@interface BAFOrderConfirmViewController ()<UITableViewDelegate, UITableViewDataSource,ServiceConfirmTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableVIEW;
@property (strong, nonatomic) IBOutlet UIView *mainHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *headerlabel;
@property (weak, nonatomic) IBOutlet UILabel *headerText;
@property (strong, nonatomic) NSMutableDictionary *orderDic;
@property (strong, nonatomic) NSMutableArray *serviceArr;
//@property (strong, nonatomic) NSMutableArray *parkArr;
//@property (strong, nonatomic) NSMutableArray *pickArr;
@property (nonatomic, strong) NSIndexPath *selectIndexpath;

@property (nonatomic, strong) IBOutlet UILabel *feeLabel;
//@property (nonatomic, strong) UIButton *detailFeeBtn;
@end


@implementation BAFOrderConfirmViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
    self.serviceArr = [NSMutableArray array];
    if ([self.orderDic objectForKey:OrderParamTypeService]) {
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
        self.serviceArr = [NSMutableArray arrayWithArray:arr];
    }
    
    [self.mainHeaderView setFrame:CGRectMake(0, 0, screenWidth, 50)];
    self.mainTableVIEW.tableHeaderView = self.mainHeaderView;
    self.headerlabel.text = [NSString stringWithFormat:@"%@     %@      %@",[self.orderDic objectForKey:OrderParamTypeContact_name],[self.orderDic objectForKey:OrderParamTypeContact_phone],[self.orderDic objectForKey:OrderParamTypeCar_license_no]];
    self.mainTableVIEW.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableVIEW.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    
    [self configTotoalfee];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavigationTitle:@"确认信息"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFOrderServiceViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}
- (IBAction)detailfeeAction:(id)sender {
    NSLog(@"明细");
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    [popView configViewWithData:[self configTotoalfee] type:kPopViewControllerTypeTipsshow];
    [self presentViewController:popView animated:NO completion:nil];
}
- (IBAction)submitOrder:(id)sender {
    NSLog(@"提交预约");
    [self addOrderRequest];
}

- (NSArray *)configTotoalfee
{
    NSMutableArray *mutArr = [NSMutableArray array];
    NSInteger totalFee = 0;
    NSInteger firstdayfee = [[self.orderDic objectForKey:OrderParamTypeParkFeeFirstDay] integerValue];
    NSInteger dayfee = [[self.orderDic objectForKey:OrderParamTypeParkFeeDay] integerValue];
    NSInteger days = -1;
    if ([self.orderDic objectForKey:OrderParamTypePark_day]) {
        days = [[self.orderDic objectForKey:OrderParamTypePark_day] integerValue];
    }
    if (days>=0) {
        totalFee = firstdayfee + dayfee*days;
    }else{
        totalFee = firstdayfee;
    }
    if ([self.orderDic objectForKey:OrderParamTypeService]) {
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
        self.serviceArr = [NSMutableArray arrayWithArray:arr];
        for (NSString *str in self.serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"=>"];
            totalFee += [detailArr[3] integerValue];
        }
    }
    self.feeLabel.text = [NSString stringWithFormat:@"预计费用：¥%ld元",totalFee/100];
    
    [mutArr addObject:[NSArray arrayWithObjects:@"预计费用",[NSString stringWithFormat:@"¥%ld元",totalFee/100], nil]];
    
    if (days>0) {
        [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元+%ld元*%ld天)",firstdayfee/100,dayfee/100,days],[NSString stringWithFormat:@"¥%ld元",(firstdayfee + dayfee*days)/100], nil]];
    }else{
        [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元)",firstdayfee/100],[NSString stringWithFormat:@"¥%ld元",firstdayfee/100], nil]];
    }
    
    if ([self.orderDic objectForKey:OrderParamTypeService]) {
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
        self.serviceArr = [NSMutableArray arrayWithArray:arr];
        for (NSString *str in self.serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"=>"];
            totalFee += [detailArr[3] integerValue];
            
            [mutArr addObject:[NSArray arrayWithObjects:detailArr[2],[NSString stringWithFormat:@"¥%ld元",[detailArr[3] integerValue]/100], nil]];
        }
    }
    
    
    return mutArr;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            NSString *totalStr = [NSString stringWithFormat:@"位置：%@",[self.orderDic objectForKey:OrderParamTypeParkLocation]];
            CGSize titleSize = [totalStr boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                      context:nil].size;
            return titleSize.height+10;
        }else{
            return 30.0f;//104
        }
    }else if (indexPath.section == 1){
        return 30.0f;
    }else{
        return 40.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30.0f;
    }else if (section == 1){
        return 30.0f;
    }else{
        return 30.0f;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, screenWidth-24, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor colorWithHex:0x585c64];
    if (section == 0) {
        label.text = @"停车信息";
    }
    if (section == 1) {
        label.text = @"取车信息";
    }
    if (section == 2) {
        label.text = @"服务项目";
    }
    [sectionFooterView addSubview:label];

    return sectionFooterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.orderDic objectForKey:OrderParamTypeService]) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 4;
    }else if(section == 1) {
        if ([self.orderDic objectForKey:OrderParamTypeBack_flight_no]) {
            return 4;
        }
        return 3;
    }else{
        return self.serviceArr.count;//根据内容返回多少
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1 ) {
        OrderConfirmTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderConfirmTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderConfirmTableViewCell" owner:nil options:nil] firstObject];
        }
        NSString *totalStr = @"";
        NSString *str = @"";
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                if ([self.orderDic objectForKey:OrderParamTypePark]) {
                    str = [self.orderDic objectForKey:OrderParamTypePark];
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"停车场：%@",str];
            }
            if (indexPath.row == 1) {
//                FB694B
                totalStr = [NSString stringWithFormat:@"位置：%@",[self.orderDic objectForKey:OrderParamTypeParkLocation]];
            }
            
            if (indexPath.row == 2) {
                if ([self.orderDic objectForKey:OrderParamTypeGoTime]) {
                    str = [self.orderDic objectForKey:OrderParamTypeGoTime];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSString* dateString = [formatter stringFromDate:(NSDate *)str];
                    str = dateString;
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"停车时间：%@",str];
            }
            if (indexPath.row == 3){
                if ([self.orderDic objectForKey:OrderParamTypeTerminal]) {
                    str = [self.orderDic objectForKey:OrderParamTypeTerminal];
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"出发航站楼：%@",str];
            }
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[totalStr rangeOfString:str]];
            cell.confirmContentLabel.attributedText = mutStr;
            
        }else{
            if (indexPath.row == 0) {
                if ([self.orderDic objectForKey:OrderParamTypeTime]) {
                    str = [self.orderDic objectForKey:OrderParamTypeTime];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSString* dateString = [formatter stringFromDate:(NSDate *)str];
                    str = dateString;
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"取车时间：%@",str];
            }
            if (indexPath.row == 1) {
                if ([self.orderDic objectForKey:OrderParamTypeBackTerminal]) {
                    str = [self.orderDic objectForKey:OrderParamTypeBackTerminal];
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"返程航站楼：%@",str];
            }
            if ([self.orderDic objectForKey:OrderParamTypeBack_flight_no]) {
                if (indexPath.row == 2) {
                    str = [self.orderDic objectForKey:OrderParamTypeBack_flight_no];
                    totalStr = [NSString stringWithFormat:@"返程航班号：%@",str];
                }
                if (indexPath.row == 3) {
                    if ([self.orderDic objectForKey:OrderParamTypeCompany]) {
                        str = [self.orderDic objectForKey:OrderParamTypeCompany];
                    }else{
                        str = @"1";
                    }
                    totalStr = [NSString stringWithFormat:@"同行人数：%@",str];
                }
            }else{
                if (indexPath.row == 2) {
                    if ([self.orderDic objectForKey:OrderParamTypeCompany]) {
                        str = [self.orderDic objectForKey:OrderParamTypeCompany];
                    }else{
                        str = @"1";
                    }
                    totalStr = [NSString stringWithFormat:@"同行人数：%@",str];
                }
            }
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:[totalStr rangeOfString:str]];
            cell.confirmContentLabel.attributedText = mutStr;
        }
        cell.confirmContentLabel.numberOfLines = 0;
        return cell;
    }else{
        ServiceConfirmTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ServiceConfirmTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ServiceConfirmTableViewCell" owner:nil options:nil] firstObject];
            cell.delegate = self;
        }
        cell.serviceStr = [self.serviceArr objectAtIndex:indexPath.row];
        return cell;
    }
    
}

- (void)closeBtnActionDelegate:(ServiceConfirmTableViewCell *)cell
{
    self.selectIndexpath = [self.mainTableVIEW indexPathForCell:cell];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"确定取消么" message:nil delegate:self cancelButtonTitle:@"不取消了" otherButtonTitles:@"确定取消",nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        //确定取消
        [self.serviceArr removeObjectAtIndex:self.selectIndexpath.row];
        [self.orderDic setValue:[self.serviceArr componentsJoinedByString:@"&"] forKey:OrderParamTypeService];
        [[NSUserDefaults standardUserDefaults] setObject:self.orderDic forKey:OrderDefaults];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self configTotoalfee];
        [self.mainTableVIEW reloadData];
    }else if (buttonIndex == 0){
        //不取消了
    }
}

#pragma mark request
- (void)addOrderRequest
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    if ([self.orderDic objectForKey:OrderParamTypeCity]) {
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeCity] componentsSeparatedByString:@"&"];
        [mutDic setObject:arr[1] forKey:@"city_id"];
    }
    if ([self.orderDic objectForKey:OrderParamTypePark]) {
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypePark] componentsSeparatedByString:@"&"];
        [mutDic setObject:arr[1] forKey:@"park_id"];
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if ([self.orderDic objectForKey:OrderParamTypeGoTime]) {
        NSString *str = [self.orderDic objectForKey:OrderParamTypeGoTime];
        NSString* dateString = [formatter stringFromDate:(NSDate *)str];
        [mutDic setObject:dateString  forKey:@"plan_park_time"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeTerminal]) {
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeTerminal] componentsSeparatedByString:@"&"];
        [mutDic setObject:arr[1] forKey:@"leave_terminal_id"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeTime]) {
        NSString *str = [self.orderDic objectForKey:OrderParamTypeTime];
        NSString* dateString = [formatter stringFromDate:(NSDate *)str];
        [mutDic setObject:dateString  forKey:@"plan_pick_time"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeBackTerminal]) {
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeBackTerminal] componentsSeparatedByString:@"&"];
        [mutDic setObject:arr[1] forKey:@"back_terminal_id"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeCompany]) {
        [mutDic setObject:[self.orderDic objectForKey:OrderParamTypeCompany] forKey:@"leave_passenger_number"];
    }else{
        [mutDic setObject:@"1" forKey:@"leave_passenger_number"];
    }
    if ([self.orderDic objectForKey:OrderParamTypePetrol]) {
        [mutDic setObject:[self.orderDic objectForKey:OrderParamTypePetrol] forKey:@"petrol"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeContact_name]) {
        [mutDic setObject:[self.orderDic objectForKey:OrderParamTypeContact_name] forKey:@"contact_name"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeContact_gender]) {
//        联系人性别:unknown-未知，male- 男，female-女
         //0 未知 1男 2女
        NSInteger sexInt = [[self.orderDic objectForKey:OrderParamTypeContact_gender] integerValue];
        NSString *sexStr = @"unknown";
        switch (sexInt) {
            case 0:
                sexStr = @"unknown";
                break;
            case 1:
                sexStr = @"male";
                break;
            case 2:
                sexStr = @"female";
                break;
        }
        [mutDic setObject:sexStr forKey:@"contact_gender"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeContact_phone]) {
        [mutDic setObject:[self.orderDic objectForKey:OrderParamTypeContact_phone] forKey:@"contact_phone"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeCar_license_no]) {
        [mutDic setObject:[self.orderDic objectForKey:OrderParamTypeCar_license_no] forKey:@"car_license_no"];
    }
    if ([self.orderDic objectForKey:OrderParamTypeBack_flight_no]) {
        [mutDic setObject:[self.orderDic objectForKey:OrderParamTypeBack_flight_no] forKey:@"back_flight_no"];
    }
    [mutDic setObject:@"user_ios" forKey:@"order_source"];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [mutDic setObject:userInfo.clientid forKey:@"client_id"];
    
    NSInteger days = -1;
    if ([self.orderDic objectForKey:OrderParamTypePark_day]) {
        days = [[self.orderDic objectForKey:OrderParamTypePark_day] integerValue];
    }
    if (days<0) {
        [mutDic setObject:@"0" forKey:@"park_day"];
    }else{
        [mutDic setObject:[NSString stringWithFormat:@"%ld",days] forKey:@"park_day"];
    }
    
    
    if ([self.orderDic objectForKey:OrderParamTypeService]) {
        NSMutableArray *mutArr = [NSMutableArray array];
        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
        for (NSString *serviceStr in arr) {
            NSArray *serviceArr = [serviceStr componentsSeparatedByString:@"=>"];
            [mutArr addObject:[NSString stringWithFormat:@"%@=>%@",serviceArr[0],serviceArr[1]]];
        }
        [mutDic setObject:mutArr forKey:OrderParamTypeService];
    }
    
    [orderReq addOrderRequestWithNumberIndex:kRequestNumberIndexAddOrder delegte:self param:mutDic];
}


#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexAddOrder) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self showTipsInView:self.view message:@"预约成功" offset:self.view.center.x+100];
            SuccessViewController *successVC = [[SuccessViewController alloc]init];
            successVC.type = kSuccessViewControllerTypeSuccess;
            [self.navigationController pushViewController:successVC animated:YES];
        }else{
            [self showTipsInView:self.view message:[obj objectForKey:@"message"] offset:self.view.center.x+100];
            SuccessViewController *successVC = [[SuccessViewController alloc]init];
            successVC.type = kSuccessViewControllerTypeFailure;
            [self.navigationController pushViewController:successVC animated:YES];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}
@end
