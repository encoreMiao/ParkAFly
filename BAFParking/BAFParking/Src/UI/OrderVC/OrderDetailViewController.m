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
#import "OrderDetailFeeTableViewCell.h"
#import "MapViewController.h"
#import "BAFOrderViewController.h"
#import "OrderListViewController.h"
#import "BAFCenterViewController.h"

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

@property (strong, nonatomic) NSString *pickPhone;
@property (strong, nonatomic) NSString *parkPhone;
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
    UINavigationController* navi = self.navigationController;
    UIViewController *vc = [navi.viewControllers objectAtIndex:(navi.viewControllers.count-2)];
    OrderListViewController *ordervc = [[OrderListViewController alloc]init];
    if ([vc isKindOfClass:[BAFCenterViewController class]]){
        NSMutableArray *vcArr = [NSMutableArray arrayWithArray:navi.viewControllers];
        [vcArr insertObject:ordervc atIndex:1];
        navi.viewControllers = vcArr;
    }
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
    NSInteger totalFee = 0;
    NSDictionary *orderFeeDetail = [self.orderDic objectForKey:@"order_fee_detail"];
    NSDictionary *orderPrice =[orderFeeDetail objectForKey:@"order_price"];
    NSDictionary *basicDic = [[orderPrice objectForKey:@"basic"] objectForKey:@"101"];
    NSInteger firstdayfee = [[basicDic objectForKey:@"first_day_price"] integerValue];
    NSInteger dayfee = [[basicDic objectForKey:@"strike_price"] integerValue];//market_price
    NSInteger days = -1;
    
    BOOL willHaveParkFee = NO;
    if ([[self.orderDic objectForKey:@"actual_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]) {
        if ([[self.orderDic objectForKey:@"plan_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]){
            willHaveParkFee = NO;
        }else{
            willHaveParkFee = YES;
        }
    }else {
        willHaveParkFee = YES;
    }
    
    if(willHaveParkFee){
        if ([orderFeeDetail objectForKey:@"park_day"]) {
            days = [[orderFeeDetail objectForKey:@"park_day"] integerValue];
        }
        days = days-1;
        if (days>=0) {
            totalFee = firstdayfee + dayfee*days;
        }else{
            totalFee = firstdayfee;
        }
    }
    
    
    if ([orderPrice objectForKey:@"single"]) {
        for (NSString *str in self.serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"&"];
            if ([str containsString:@"自行往返"]) {
                totalFee -= [detailArr[1] integerValue];
            }else{
                totalFee += [detailArr[1] integerValue];
            }
        }
    }
    [mutArr addObject:[NSArray arrayWithObjects:[self orderFeeStr],[NSString stringWithFormat:@"¥%ld",totalFee/100], nil]];

    if (willHaveParkFee) {
        if (days>0) {
            [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元+%ld元*%ld天)",firstdayfee/100,dayfee/100,days],[NSString stringWithFormat:@"¥%ld",(firstdayfee + dayfee*days)/100], nil]];
        }else{
            [mutArr addObject:[NSArray arrayWithObjects:[NSString stringWithFormat:@"车位费(首日%ld元)",firstdayfee/100],[NSString stringWithFormat:@"¥%ld",firstdayfee/100], nil]];
        }
    }

    if (self.serviceArr.count>0) {
        for (NSString *str in self.serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"&"];
            if ([str containsString:@"自行往返"]) {
                [mutArr addObject:[NSArray arrayWithObjects:detailArr[0],[NSString stringWithFormat:@"-¥%ld",[detailArr[1] integerValue]/100], nil]];
            }else{
                [mutArr addObject:[NSArray arrayWithObjects:detailArr[0],[NSString stringWithFormat:@"¥%ld",[detailArr[1] integerValue]/100], nil]];
            }
            
        }
    }
    
    
    if ([[self orderFeeStr] isEqualToString:@"预计费用"]) {
        //应支付
        [mutArr addObject:[NSArray arrayWithObjects:@"应支付",[NSString stringWithFormat:@"¥%ld",totalFee/100], nil]];
    }else{
        //支付方式
        [mutArr addObject:[NSArray arrayWithObjects:@"支付方式",@"", nil]];
        NSDictionary *payment_detailDic = [orderFeeDetail objectForKey:@"payment_detail"];
        
        NSDictionary *discount_price = [orderFeeDetail objectForKey:@"discount_price"];
        if (![discount_price isEqual:[NSNull null]]&&discount_price!=nil) {
            if (discount_price.count>0) {
                for (NSString *key in discount_price) {
                    NSArray *discount_info_dic = [discount_price objectForKey:key];
                    if (discount_info_dic.count>0) {
                        NSLog(@"%@",discount_info_dic);
                        NSString *title = [discount_info_dic[0] objectForKey:@"title"];
                        NSString *total = [discount_info_dic[0] objectForKey:@"total"];
                        [mutArr addObject:[NSArray arrayWithObjects:title, [NSString stringWithFormat:@"-¥%ld",[total integerValue]/100], nil]];
                    }
                }
            }
        }
        
        if (![payment_detailDic isEqual:[NSNull null]]&&payment_detailDic!=nil) {
            if (payment_detailDic.count>0) {
                for (NSString *key in payment_detailDic) {
                    NSString *payStr = @"";
                    NSString *pay_method = [[payment_detailDic objectForKey:key] objectForKey:@"pay_method"];
                    if ([pay_method isEqualToString:@"cash"]) {
                        payStr = @"现金支付";
                    }
                    if ([pay_method isEqualToString:@"wechat"]) {
                        payStr = @"微信支付";
                    }
                    if ([pay_method isEqualToString:@"alipay"]) {
                        payStr = @"支付宝支付";
                    }
                    if ([pay_method isEqualToString:@"personal_account"]) {
                        payStr = @"个人账户支付";
                    }
                    if ([pay_method isEqualToString:@"company_account"]) {
                        payStr = @"集团账户支付";
                    }
                    if ([pay_method isEqualToString:@"coupon_code"]) {
                        payStr = @"优惠码";
                    }
                    if ([pay_method isEqualToString:@"activity_code"]) {
                        payStr = @"权益账户";
                    }
                    NSDictionary *paydic = [payment_detailDic objectForKey:key];
                    NSString *payAmonut = [NSString stringWithFormat:@"-¥%ld",([[paydic objectForKey:@"pay_amount"] integerValue])/100];
                    [mutArr addObject:[NSArray arrayWithObjects:payStr, payAmonut, nil]];
                }
            }
        }
    }
    
//    "to_be_price" = 6000;待支付价格
//    after_discount_total_price 折扣后价格
//    actual_already_pay_price 实际支付价格
    return mutArr;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);

    //弹出详细说明
    if (self.serviceArr.count>0) {
        if (indexPath.section == 4) {
            [self detailfeeAction:nil];
        }
    }else{
        if (indexPath.section == 3) {
            [self detailfeeAction:nil];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //地理位置
            MapViewController *vc = [[MapViewController alloc]init];
            NSDictionary *dic = [self.orderDic objectForKey:@"park"];
            vc.imageStr = [dic objectForKey:@"map_pic"];
            vc.pointStr = [dic objectForKey:@"map_title"];
            vc.titleStr = [dic objectForKey:@"map_title"];
            vc.detailStr = [dic objectForKey:@"map_address"];
            CLLocationCoordinate2D coor;
            coor.latitude = [[dic objectForKey:@"map_lon"] doubleValue];
            coor.longitude = [[dic objectForKey:@"map_lat"] doubleValue];
            vc.coor = coor;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //泊车经理
        if (indexPath.row == 4) {
            NSString *phone = [self.orderDic objectForKey:@"park_manager_phone"];
            if (![phone isEqual:[NSNull null]]&& phone.length>10) {
                [self callPhoneNumber:phone];
            }
        }
    }
    
    if (indexPath.section == 2){
        //取车经理
        if (indexPath.row == 4) {
            NSString *phone = [self.orderDic objectForKey:@"pick_manager_phone"];
            if (![phone isEqual:[NSNull null]]&& phone.length>10) {
                [self callPhoneNumber:phone];
            }
        }
    }
}

- (void)callPhoneNumber:(NSString *)phoneNumber {
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:callWebview];
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
                    return [self heightForStatusRow:indexPath.row];
                }
            }
        }
    }else if (indexPath.section == 5){
        if (self.serviceArr.count >0) {
            if ([self.orderDic objectForKey:@"picture"]) {
                NSDictionary *dic = [self.orderDic objectForKey:@"picture"];
                if ([dic objectForKey:@"pick"]&&![[dic objectForKey:@"pick"] isEqual:[NSNull null]]) {
                    return 100.0f;
                }
                else if ([dic objectForKey:@"park"]&&![[dic objectForKey:@"park"] isEqual:[NSNull null]]) {
                    return 100.0f;
                }else{
                    return [self heightForStatusRow:indexPath.row];
                }
            }
        }else{
            return [self heightForStatusRow:indexPath.row];
        }
    }else if (indexPath.section == 6){
        return [self heightForStatusRow:indexPath.row];
    }
    return 0;
}

- (CGFloat)heightForStatusRow:(NSUInteger)row
{
    NSString *action = [[self.operatorArr objectAtIndex:row] objectForKey:@"action"];
    NSString *str;
    if ([action isEqualToString:@"park_appoint"]) {
        str = @"预约泊车成功，订单已分派，形成改变请及时修改您的预约信息。";
    }
    if ([action isEqualToString:@"cancel"]) {
        str = @"订单已取消";
    }
    if ([action isEqualToString:@"park"]) {
        str = @"车辆已停放至车场，停车开始计费，如回程时间改变，请及时修改您的取车时间";
    }
    if ([action isEqualToString:@"pick_sure"]) {
        str = @"取车时间已确认，停车结束计费，订单费用可在线支付或交现金给工作人员";
    }
    if ([action isEqualToString:@"finish"]) {
        str = @"取车成功！感谢使用泊安飞服务，业务咨询或意见反馈，可致电4008138666联系客服。";
    }
    if ([action isEqualToString:@"wash_car"]) {
        str = @"已为您的爱车洗车";
    }
    if ([action isEqualToString:@"fill_oil"]) {
        str = @"已为您的爱车代加油100元";
    }
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(screenWidth-48, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                              context:nil].size;
    return titleSize.height + 50;
//    self.orderOperatorLabel.text
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
                    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
                    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];
                    
                    if ([[self.orderDic objectForKey:@"actual_park_time"] isEqualToString:@"0000-00-00 00:00:00"]) {
                        str = @"";
                        if ([[self.orderDic objectForKey:@"plan_park_time"] isEqualToString:@"0000-00-00 00:00:00"]){
                            str = @"";
                        }else{
//                            str = [self.orderDic objectForKey:@"plan_park_time"];
                            NSDate *date =[dateFormat dateFromString:[self.orderDic objectForKey:@"plan_park_time"]];
                            str = [dateFormat1 stringFromDate:date];
                        }
                    }else {
                        NSDate *date =[dateFormat dateFromString:[self.orderDic objectForKey:@"actual_park_time"]];
                        str = [dateFormat1 stringFromDate:date];
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
                    
                    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                    attch.bounds = CGRectMake(0, 0, 19*0.8, 24*0.8);
                    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"     "];
                    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                    [mutStr appendAttributedString:str1];
                    [mutStr appendAttributedString:string];
                    if (indexPath.row == 0) {
                        attch.image = [UIImage imageNamed:@"btn_map"];
                        // 用label的attributedText属性来使用富文本
                        cell.confirmContentLabel.attributedText = mutStr;
                    }else if(indexPath.row == 4){
                        if (str.length>10){
                            attch.image = [UIImage imageNamed:@"btn_phone"];
                            // 用label的attributedText属性来使用富文本
                            cell.confirmContentLabel.attributedText = mutStr;
                        }
                    }
                }
            }
        }else{
            if (indexPath.row == 0) {
                NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
                NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
                [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];
                
                if ([[self.orderDic objectForKey:@"actual_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]) {
                    str = @"";
                    if ([[self.orderDic objectForKey:@"plan_pick_time"] isEqualToString:@"0000-00-00 00:00:00"]){
                        str = @"";
                    }else{
                        NSDate *date =[dateFormat dateFromString:[self.orderDic objectForKey:@"plan_pick_time"]];
                        str = [dateFormat1 stringFromDate:date];
                    }
                }else {
                    NSDate *date =[dateFormat dateFromString:[self.orderDic objectForKey:@"actual_pick_time"]];
                    str = [dateFormat1 stringFromDate:date];
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
                    str =[NSString stringWithFormat:@"%@人", [self.orderDic objectForKey:@"leave_passenger_number"]];
                }else{
                    str = @"1人";
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
                
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                attch.bounds = CGRectMake(0, 0, 19*0.8, 24*0.8);
                NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"     "];
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [mutStr appendAttributedString:str1];
                [mutStr appendAttributedString:string];
                if(indexPath.row == 4){
                    if (str.length>10){
                        attch.image = [UIImage imageNamed:@"btn_phone"];
                        // 用label的attributedText属性来使用富文本
                        cell.confirmContentLabel.attributedText = mutStr;
                    }
                }
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
            NSString *str = [self.serviceArr objectAtIndex:indexPath.row];
            cell.serviceTitleLabel.text = [[str componentsSeparatedByString:@"&"] objectAtIndex:0];
            return cell;
        }
        cell.type = OrderDetailFeeTableViewCellTypeTotalFee;
        cell.serviceTitleLabel.text = [self orderFeeStr];
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
            cell.serviceTitleLabel.text = [self orderFeeStr];
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
                if (indexPath.row == 0) {
                    cellstatus.showActive = YES;
                }else{
                    cellstatus.showActive = NO;
                }
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
                if (indexPath.row == 0) {
                    cellstatus.showActive = YES;
                }else{
                    cellstatus.showActive = NO;
                }
                return cellstatus;
            }
        }else{
            cellstatus.operatorDic = [self.operatorArr objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                cellstatus.showActive = YES;
            }else{
                cellstatus.showActive = NO;
            }
            return cellstatus;
        }
    }else if (indexPath.section == 6){
        OrderDetailStatusTableViewCell *cellstatus =  [tableView dequeueReusableCellWithIdentifier:OrderDetailStatusTableViewCellIdentifier];
        if (cellstatus == nil) {
            cellstatus = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailStatusTableViewCell" owner:nil options:nil] firstObject];
            cellstatus.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cellstatus.operatorDic = [self.operatorArr objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cellstatus.showActive = YES;
        }else{
            cellstatus.showActive = NO;
        }
        return cellstatus;
    }
    return nil;
}

- (NSString *)orderFeeStr
{
    NSString *orderStatus = [self.orderDic objectForKey:@"order_status"];
    if ([orderStatus isEqualToString:@"park_appoint"]||
        [orderStatus isEqualToString:@"approve"]) {
        //预约泊车成功
        return @"预计费用";
    }else if([orderStatus isEqualToString:@"park"]){
        //泊车成功
        return @"预计费用";
    }else if ([orderStatus isEqualToString:@"pick_appoint"]){
        //待取车
        return @"预计费用";
    }else if ([orderStatus isEqualToString:@"finish"]){
        //服务结束
        return @"订单总费用";
    }
    else if ([orderStatus isEqualToString:@"payment_sure"]){
        //已支付待确认
        return @"订单总费用";
    }
    else if ([orderStatus isEqualToString:@"pick_sure"]){
        //已确认取车
        return @"订单总费用";
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
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

- (void)configOrderDic:(NSDictionary *)dic
{
    NSMutableDictionary *mutDic;
    if ([[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"]&&(![[[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"] isEqual:[NSNull null]])) {
        mutDic = [NSMutableDictionary dictionaryWithDictionary:[[[dic objectForKey:@"order_fee_detail"]objectForKey:@"order_price"] objectForKey:@"single"]];
    }

    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *key in mutDic) {
        NSDictionary *dic = [mutDic objectForKey:key];
        NSString *string = [NSString stringWithFormat:@"%@&%@",[dic objectForKey:@"title"],[dic objectForKey:@"strike_price"]];
        [arr addObject:string];
        if ([key isEqualToString:@"202"]) {
//            [arr addObject:@"代泊服务"];
        }
        if ([key isEqualToString:@"206"]) {
//            [arr addObject:@"自行往返航站楼"];
        }
        if ([key isEqualToString:@"205"]) {
//            [arr addObject:@"洗车服务"];
        }
        if ([key isEqualToString:@"204"]) {
//            [arr addObject:@"代加油"];
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
