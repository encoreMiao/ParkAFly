//
//  OrderDetailViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailImageTableViewCell.h"
#import "OrderDetail1TableViewCell.h"
#import "OrderDetailStatusTableViewCell.h"
#import "PopViewController.h"
#import "OrderConfirmTableViewCell.h"
#import "OrderDetail1TableViewCell.h"
#import "OrderDetailImageTableViewCell.h"
#import "OrderDetailStatusTableViewCell.h"
#import "OrderDetailFeeTableViewCell.h"

#define OrderConfirmTableViewCellIdentifier @"OrderConfirmTableViewCellIdentifier"
#define OrderDetail1TableViewCellIdentifier @"OrderDetail1TableViewCellIdentifier"
#define OrderDetailImageTableViewCellIdentifier @"OrderDetailImageTableViewCellIdentifier"
#define OrderDetailStatusTableViewCellIdentifier @"OrderDetailStatusTableViewCellIdentifier"
#define OrderDetailFeeTableViewCellIdentifier  @"OrderDetailFeeTableViewCellIdentifier"


typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexOrderDetail,
};

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSMutableDictionary *orderDic;
@property (strong, nonatomic) NSMutableArray *serviceArr;
@property (strong, nonatomic) NSMutableArray *operatorArr;
@end

@implementation OrderDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderDic = [NSMutableDictionary dictionary];
    self.serviceArr = [NSMutableArray array];
    self.operatorArr = [NSMutableArray array];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavigationTitle:@"订单详情"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
    [self orderDetailRequest];
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)detailfeeAction:(id)sender {
    DLog(@"详情");
    PopViewController *popView = [[PopViewController alloc] init];
    popView.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    popView.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.definesPresentationContext = YES;
    [popView configViewWithData:[self configTotoalfee] type:kPopViewControllerTypeTipsshow];
    [self presentViewController:popView animated:NO completion:nil];
}

- (NSArray *)configTotoalfee
{
    NSMutableArray *mutArr = [NSMutableArray array];
//    NSInteger totalFee = 0;
//    NSInteger firstdayfee = [[self.orderDic objectForKey:OrderParamTypeParkFeeFirstDay] integerValue];
//    NSInteger dayfee = [[self.orderDic objectForKey:OrderParamTypeParkFeeDay] integerValue];
//    NSInteger days = -1;
//    if ([self.orderDic objectForKey:OrderParamTypePark_day]) {
//        days = [[self.orderDic objectForKey:OrderParamTypePark_day] integerValue];
//    }
//    if (days>=0) {
//        totalFee = firstdayfee + dayfee*days;
//    }else{
//        totalFee = firstdayfee;
//    }
//    if ([self.orderDic objectForKey:OrderParamTypeService]) {
//        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
//        self.serviceArr = [NSMutableArray arrayWithArray:arr];
//        for (NSString *str in self.serviceArr) {
//            NSArray *detailArr = [str componentsSeparatedByString:@"=>"];
//            totalFee += [detailArr[3] integerValue];
//        }
//    }
//    self.feeLabel.text = [NSString stringWithFormat:@"预计费用：¥%ld元",totalFee/100];
//    
//    [mutArr addObject:[NSArray arrayWithObjects:@"预计费用",[NSString stringWithFormat:@"¥%ld元",totalFee/100], nil]];
//    
//    if (days>0) {
//        [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元+%ld元*%ld天)",firstdayfee/100,dayfee/100,days],[NSString stringWithFormat:@"¥%ld元",(firstdayfee + dayfee*days)/100], nil]];
//    }else{
//        [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元)",firstdayfee/100],[NSString stringWithFormat:@"¥%ld元",firstdayfee/100], nil]];
//    }
//    
//    if ([self.orderDic objectForKey:OrderParamTypeService]) {
//        NSArray *arr = [[self.orderDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
//        self.serviceArr = [NSMutableArray arrayWithArray:arr];
//        for (NSString *str in self.serviceArr) {
//            NSArray *detailArr = [str componentsSeparatedByString:@"=>"];
//            totalFee += [detailArr[3] integerValue];
//            
//            [mutArr addObject:[NSArray arrayWithObjects:detailArr[2],[NSString stringWithFormat:@"¥%ld元",[detailArr[3] integerValue]/100], nil]];
//        }
//    }

    return mutArr;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 135.0f;
    }else if (indexPath.section == 1||indexPath.section == 2){
        if (indexPath.section == 1&&indexPath.row == 1) {
            NSString *totalStr;
            if ([[self.orderDic objectForKey:@"park"] objectForKey:@"map_address"]) {
                totalStr = [NSString stringWithFormat:@"位置：%@",[[self.orderDic objectForKey:@"park"] objectForKey:@"map_address"]];
            }else
            {
                totalStr = [NSString stringWithFormat:@"位置：%@",@""];
            }
            CGSize titleSize = [totalStr boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                      context:nil].size;
            return titleSize.height+10;
        }else{
            return 30.0f;//104
        }
    }else if (indexPath.section == 3){
        if (self.serviceArr.count >0) {
            return 40.0f;
        }
        return 40.0f;//否则是订单费用
    }else if (indexPath.section == 4){
        if (self.serviceArr.count >0) {
            return 40.0f;
        }else{
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    return 100.0f;
                }
                else if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    return 100.0f;
                }else{
                    return 65.0f;
                }
            }
        }
    }else if (indexPath.section == 5){
        if (self.serviceArr.count >0) {
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&[[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    return 100.0f;
                }
                else if ([dic objectForKey:@"park"]&&[[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    return 100.0f;
                }else
                    return 65.0f;
            }
        }else{
            return 65.0f;
        }
    }else if (indexPath.section == 6){
        return 65.0f;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0f;
    }else if (section == 1||section == 2){
        return 30.0f;
    }else if (section == 3){
        if (self.serviceArr.count>0) {
            return 30.0f;
        }
        return 10.0f;
    }else if (section == 4){
        if (self.serviceArr.count >0) {
            return 10.0f;
        }else{
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]||![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    return 30.0f;
                }
                else if ([dic objectForKey:@"park"]||![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    return 30.0f;
                }
                return 30.0f;
            }
        }
    }else if (section == 5){
        if (self.serviceArr.count >0) {
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    return 30.0f;
                }
                else if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    return 30.0f;
                }
                return 30.0f;
            }
        }else{
            return 30.0f;
        }
    }else if (section == 6){
        return 30.0f;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    if (section == 0) {
        [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 0)];
        return sectionFooterView;
    }
    [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screenWidth-24, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor colorWithHex:0x323232];
    if (section == 1) {
        label.text = @"停车信息";
        [sectionFooterView addSubview:label];
    }
    if (section == 2) {
        label.text = @"取车信息";
        [sectionFooterView addSubview:label];
    }
    if (section == 3) {
        if (self.serviceArr.count>0) {
            label.text = @"服务项目";
            [sectionFooterView addSubview:label];
        }
        else{
            [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
        }
    }
    if (section  == 4) {
        if (self.serviceArr.count>0) {
            [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
        }else{
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    label.text = @"取车图片";
                    [sectionFooterView addSubview:label];
                }
                else  if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    label.text = @"泊车图片";
                    [sectionFooterView addSubview:label];
                }else{
                    label.text = @"订单状态";
                    [sectionFooterView addSubview:label];
                }
                
            }
        }
    }else if (section == 5){
        if (self.serviceArr.count >0) {
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    label.text = @"取车图片";
                    [sectionFooterView addSubview:label];
                }
                else if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    label.text = @"泊车图片";
                    [sectionFooterView addSubview:label];
                }else{
                    label.text = @"订单状态";
                    [sectionFooterView addSubview:label];
                }
            }
        }else{
            label.text = @"订单状态";
            [sectionFooterView addSubview:label];
        }
    }else if (section == 6){
        label.text = @"订单状态";
        [sectionFooterView addSubview:label];
    }
    return sectionFooterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionNumber = 3;
    if (self.serviceArr.count>0) {
        sectionNumber ++;
    }
    sectionNumber ++;//订单费用
    if ([self.orderDic objectForKey:@"picture"]) {
        NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
        if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
            sectionNumber ++;
        }
        else if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
            sectionNumber ++;
        }
    }
    sectionNumber ++;
    return sectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 1;
    }else if(section == 1||section == 2) {
        return 5;
    }else if(section == 3){
        if (self.serviceArr.count>0) {
            return self.serviceArr.count;//根据内容返回多少
        }
        return 1;//订单费用
    }else if(section == 4){
        if (self.serviceArr.count>0) {
            return 1;
        }else{
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    return 1;
                }
                else  if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    return 1;
                }
                return self.operatorArr.count;
            }
        }
        
    }else if (section == 5){
        if (self.serviceArr.count >0) {
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    return 1;
                }
                else if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    return 1;
                }
                return self.operatorArr.count;
            }
        }else{
            return self.operatorArr.count;
        }
    }else if (section == 6){
        return self.operatorArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        OrderDetail1TableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderDetail1TableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetail1TableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.orderDic) {
            cell.orderDic = self.orderDic;
        }
        return cell;
    }

    if (indexPath.section == 1 || indexPath.section == 2 ) {
        OrderConfirmTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderConfirmTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderConfirmTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *totalStr = @"";
        NSString *str = @"";
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
                if ([[self.orderDic objectForKey:@"park"] objectForKey:@"map_address"]&&(![[[self.orderDic objectForKey:@"park"] objectForKey:@"map_address"] isEqual:[NSNull null]])) {
                    totalStr = [NSString stringWithFormat:@"位置：%@",[[self.orderDic objectForKey:@"park"] objectForKey:@"map_address"]];
                }else{
                    totalStr = [NSString stringWithFormat:@"位置：%@",@""];
                }
                
                NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
                [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xfb694b],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:[totalStr rangeOfString:totalStr]];
                cell.confirmContentLabel.attributedText = mutStr;
            }else{
                if (indexPath.row == 0) {
                    if ([[self.orderDic objectForKey:@"park"] objectForKey:@"map_title"]&&(![[[self.orderDic objectForKey:@"park"] objectForKey:@"map_title"] isEqual:[NSNull null]])) {
                        str = [[self.orderDic objectForKey:@"park"] objectForKey:@"map_title"];
                    }else{
                        str = @"";
                    }
                    totalStr = [NSString stringWithFormat:@"停车场：%@",str];
                }
                if (indexPath.row == 2) {
                    if ([[self.orderDic objectForKey:@"actual_park_time"] isEqualToString:@"0000-00-00 00:00:00"]) {
                        str = @"";
                        if ([[self.orderDic objectForKey:@"plan_park_time"] isEqualToString:@"0000-00-00 00:00:00"]){
                            str = @"";
                        }else{
                            str = [self.orderDic objectForKey:@"plan_park_time"];
                        }
                    }else {
                        str = [self.orderDic objectForKey:@"actual_park_time"];
                    }
                    totalStr = [NSString stringWithFormat:@"停车时间：%@",str];
                }
                if (indexPath.row == 3){
                    if ([self.orderDic objectForKey:@"leave_terminal_name"]&&(![[self.orderDic objectForKey:@"leave_terminal_name"] isEqual:[NSNull null]])) {
                        str = [self.orderDic objectForKey:@"leave_terminal_name"];
                    }else{
                        str = @"";
                    }
                    totalStr = [NSString stringWithFormat:@"出发航站楼：%@",str];
                }
                
                if (indexPath.row == 4){
                    if ([self.orderDic objectForKey:@"park_manager_name"]&&[self.orderDic objectForKey:@"park_manager_phone"]&&(![[self.orderDic objectForKey:@"park_manager_phone"] isEqual:[NSNull null]])&&(![[self.orderDic objectForKey:@"park_manager_name"] isEqual:[NSNull null]])) {
                        str = [NSString stringWithFormat:@"%@   %@",[self.orderDic objectForKey:@"park_manager_name"],[self.orderDic objectForKey:@"park_manager_phone"]];
                    }else{
                        str = @"";
                    }
                    totalStr = [NSString stringWithFormat:@"泊车经理：%@",str];
                }
                if (str) {
                    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
                    [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x323232],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:[totalStr rangeOfString:str]];
                    cell.confirmContentLabel.attributedText = mutStr;
                }
            }
        }else{
            if (indexPath.row == 0) {
                if ([[self.orderDic objectForKey:@"actual_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]) {
                    str = @"";
                    if ([[self.orderDic objectForKey:@"plan_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]){
                        str = @"";
                    }else{
                        str = [self.orderDic objectForKey:@"plan_pick_time"];
                    }
                }else {
                    str = [self.orderDic objectForKey:@"actual_pick_time"];
                }
                totalStr = [NSString stringWithFormat:@"取车时间：%@",str];
            }
            if (indexPath.row == 1) {
                if ([self.orderDic objectForKey:@"back_terminal_name"]&&(![[self.orderDic objectForKey:@"back_terminal_name"] isEqual:[NSNull null]])) {
                    str = [self.orderDic objectForKey:@"back_terminal_name"];
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"返程航站楼：%@",str];
            }
            if (indexPath.row == 2) {
                if ([self.orderDic objectForKey:@"back_flight_no"]&&(![[self.orderDic objectForKey:@"back_flight_no"] isEqual:[NSNull null]])) {
                    str = [self.orderDic objectForKey:@"back_flight_no"];
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"返程航班号：%@",str];
            }
            if (indexPath.row == 3) {
                if ([self.orderDic objectForKey:@"back_passenger_number"]&&(![[self.orderDic objectForKey:@"back_passenger_number"] isEqual:[NSNull null]])) {
                    str = [self.orderDic objectForKey:@"back_passenger_number"];
                }else{
                    str = @"1";
                }
                totalStr = [NSString stringWithFormat:@"同行人数：%@",str];
            }
            if (indexPath.row == 4){
                if ([self.orderDic objectForKey:@"pick_manager_phone"]&&[self.orderDic objectForKey:@"pick_manager_name"]&&(![[self.orderDic objectForKey:@"pick_manager_phone"] isEqual:[NSNull null]])&&(![[self.orderDic objectForKey:@"pick_manager_name"] isEqual:[NSNull null]])) {
                    str = [NSString stringWithFormat:@"%@   %@",[self.orderDic objectForKey:@"pick_manager_name"],[self.orderDic objectForKey:@"pick_manager_phone"]];
                }else{
                    str = @"";
                }
                totalStr = [NSString stringWithFormat:@"取车经理：%@",str];
            }

            if (str) {
                NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
                [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x323232],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:[totalStr rangeOfString:str]];
                cell.confirmContentLabel.attributedText = mutStr;
            }
        }
        cell.confirmContentLabel.numberOfLines = 0;
        return cell;
    }
    
    if (indexPath.section == 3) {
        OrderDetailFeeTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderDetailFeeTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailFeeTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.serviceArr.count>0) {
            cell.type = OrderDetailFeeTableViewCellTypeService;
            cell.serviceTitleLabel.text = [self.serviceArr objectAtIndex:indexPath.row];
            return cell;
        }
        cell.type = OrderDetailFeeTableViewCellTypeTotalFee;
        cell.serviceTitleLabel.text = [NSString stringWithFormat:@"订单总费用啦啦啦"];
        return cell;//订单费用
    }
    
    if (indexPath.section == 4) {
        if (self.serviceArr.count>0) {
            OrderDetailFeeTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderDetailFeeTableViewCellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailFeeTableViewCell" owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.type = OrderDetailFeeTableViewCellTypeTotalFee;
            cell.serviceTitleLabel.text = [NSString stringWithFormat:@"订单总费用呵呵呵"];
            return cell;
        }else{
            OrderDetailImageTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderDetailImageTableViewCellIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailImageTableViewCell" owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            OrderDetailStatusTableViewCell *cellstatus =  [tableView dequeueReusableCellWithIdentifier:OrderDetailStatusTableViewCellIdentifier];
            if (cellstatus == nil) {
                cellstatus = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailStatusTableViewCell" owner:nil options:nil] firstObject];
                cellstatus.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    cell.imageArr = [dic objectForKey:@"pick"];
                    return cell;
                }
                else  if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    cell.imageArr = [dic objectForKey:@"park"];
                    return cell;
                }
                cellstatus.operatorDic = [self.operatorArr objectAtIndex:indexPath.row];
                return cellstatus;
            }
        }
        
        
    }else if (indexPath.section == 5){
        OrderDetailImageTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderDetailImageTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailImageTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        OrderDetailStatusTableViewCell *cellstatus =  [tableView dequeueReusableCellWithIdentifier:OrderDetailStatusTableViewCellIdentifier];
        if (cellstatus == nil) {
            cellstatus = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailStatusTableViewCell" owner:nil options:nil] firstObject];
            cellstatus.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.serviceArr.count >0) {
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    cell.imageArr = [dic objectForKey:@"pick"];
                    return cell;
                }
                else if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    cell.imageArr = [dic objectForKey:@"park"];
                    return cell;
                }
                cellstatus.operatorDic = [self.operatorArr objectAtIndex:indexPath.row];
                return cellstatus;
            }
        }else{
            cellstatus.operatorDic = [self.operatorArr objectAtIndex:indexPath.row];
            return cellstatus;
        }
    }else if (indexPath.section == 6){
        OrderDetailStatusTableViewCell *cellstatus =  [tableView dequeueReusableCellWithIdentifier:OrderDetailStatusTableViewCellIdentifier];
        if (cellstatus == nil) {
            cellstatus = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailStatusTableViewCell" owner:nil options:nil] firstObject];
            cellstatus.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellstatus.operatorDic = [self.operatorArr objectAtIndex:indexPath.row];
        return cellstatus;
    }
    return nil;
}

#pragma mark request
- (void)orderDetailRequest
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [mutDic setObject:userInfo.clientid forKey:@"client_id"];
    [orderReq orderDetailRequestWithNumberIndex:kRequestNumberIndexOrderDetail delegte:self order_id:self.orderIdStr];
}

#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexOrderDetail) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            /*
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[obj objectForKey:@"data"]];
            NSDictionary *dic1 = @{@"park":@[@"1",@"2",@"3",@"4"],
                                   @"pick":@[@"1",@"2"]};
            [dic setObject:dic1 forKey:@"picture"];*/
            self.orderDic = [obj objectForKey:@"data"];
            [self configOrderDic:self.orderDic];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

- (void)configOrderDic:(NSDictionary *)dic
{
    NSMutableDictionary *mutDic;
    if ([[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"]&&(![[[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"] isEqual:[NSNull null]])) {
        mutDic = [NSMutableDictionary dictionaryWithDictionary:[[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"]];
    }

    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in mutDic) {
        if ([key isEqualToString:@"202"]) {
            [arr addObject:@"代泊服务"];
        }
        if ([key isEqualToString:@"206"]) {
            [arr addObject:@"自行往返航站楼"];
        }
        if ([key isEqualToString:@"205"]) {
            [arr addObject:@"洗车服务"];
        }
        if ([key isEqualToString:@"204"]) {
            [arr addObject:@"代加油"];
        }
    }
    self.serviceArr = [NSMutableArray arrayWithArray:arr];
    
    if ([dic objectForKey:@"operator_log"]) {
        self.operatorArr = [NSMutableArray arrayWithArray:[dic objectForKey:@"operator_log"]];
    }
    
    [self configTotoalfee];
    [self.myTableView reloadData];
}
@end
