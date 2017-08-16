//
//  SuccessViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/30.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "SuccessViewController.h"
#import "BAFCenterViewController.h"
#import "BAFOrderViewController.h"
#import "BAFOrderServiceViewController.h"
#import "OrderListViewController.h"

@interface SuccessViewController ()
@property (nonatomic, strong) IBOutlet UIView *successView;
@property (nonatomic, strong) IBOutlet UIView *failureView;
@property (nonatomic, strong) IBOutlet UIView *payView;

@property (nonatomic, strong) IBOutlet UIView *rechargeSuccessView;
@property (nonatomic, strong) IBOutlet UILabel *rechargeMoneyLabel;//充值金额
@property (nonatomic, strong) IBOutlet UILabel *rechargeTimeLabel;//充值时间

@property (nonatomic, strong) IBOutlet UIView *buttonView;
@property (weak, nonatomic)   IBOutlet UIButton *contactBtn;
@property (weak, nonatomic)   IBOutlet UIButton *checktBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeL;
@property (weak, nonatomic) IBOutlet UILabel *pickTimeL;
@property (weak, nonatomic) IBOutlet UILabel *parkDayL;
@property (weak, nonatomic) IBOutlet UILabel *feeL;

@property (nonatomic, strong) IBOutlet UILabel *payMoneyLabel;//支付金额
@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactBtn.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.contactBtn.layer.borderWidth = 0.5f;
    self.checktBtn.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.checktBtn.layer.borderWidth = 0.5f;
}
- (IBAction)contactClicked:(id)sender {
    [self callPhoneNumber:@"4008138666"];
}

- (IBAction)checkOrder:(id)sender {
    OrderListViewController *vc = [[OrderListViewController alloc]init];
//    vc.orderIdStr = self.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    self.navigationItem.hidesBackButton = YES;
    [self setNavigationRightButtonWithText:@"完成" method:@selector(rightBtnClicked:)];
    
    
    switch (self.type) {
        case kSuccessViewControllerTypePay:
        {
            [self setNavigationTitle:@"现金支付"];
            self.successView.hidden = YES;
            self.failureView.hidden = YES;
            self.rechargeSuccessView.hidden = YES;
            self.payView.hidden = NO;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"待支付：%@",self.rechargeMoneyStr];
            NSMutableAttributedString *mutAtr = [[NSMutableAttributedString alloc]initWithString:str];
            [mutAtr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xfb694b],NSFontAttributeName:self.rechargeMoneyLabel.font} range:[str rangeOfString:self.rechargeMoneyStr]];
            self.payMoneyLabel.attributedText = mutAtr;
            
            
            
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.payView.frame), screenWidth, 100)];
        }
            break;
        case kSuccessViewControllerTypeRechargeSuccess:
        {
            [self setNavigationTitle:@"充值成功"];
            self.rechargeSuccessView.hidden = NO;
            NSString *str = [NSString stringWithFormat:@"充值金额：%@",self.rechargeMoneyStr];
            NSMutableAttributedString *mutAtr = [[NSMutableAttributedString alloc]initWithString:str];
            [mutAtr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xfb694b],NSFontAttributeName:self.rechargeMoneyLabel.font} range:[str rangeOfString:self.rechargeMoneyStr]];
            self.rechargeMoneyLabel.attributedText = mutAtr;
            
            NSString *strTime = [NSString stringWithFormat:@"充值时间：%@",self.rechargeTimeStr];
            self.rechargeTimeLabel.text = strTime;
            
            self.successView.hidden = YES;
            self.failureView.hidden = YES;
            self.payView.hidden = YES;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.payView.frame), screenWidth, 100)];
        }
            break;
        case kSuccessViewControllerTypeFailure:
        {
            [self setNavigationTitle:@"预约失败"];
            self.successView.hidden = YES;
            self.failureView.hidden = NO;
            self.payView.hidden = YES;
            self.rechargeSuccessView.hidden = YES;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.failureView.frame), screenWidth, 100)];
        }
            break;
        case kSuccessViewControllerTypeSuccess:
        {
            [self setNavigationTitle:@"预约成功"];
            self.successView.hidden = NO;
            self.failureView.hidden = YES;
            self.rechargeSuccessView.hidden = YES;
            self.payView.hidden = YES;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.successView.frame), screenWidth, 100)];
            
            [self configSuccessView];
        }
            break;
        default:
            break;
    }
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (void)rightBtnClicked:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setType:(SuccessViewControllerType)type
{
    _type  =  type;
}


- (void)callPhoneNumber:(NSString *)phoneNumber {
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:callWebview];
}
- (void)callPhoneNumberWithOutAlert:(NSString *)phoneNumber{
    NSURL * telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    [[UIApplication sharedApplication] openURL:telUrl];
}

- (void)configSuccessView
{
    NSMutableDictionary *mutDic;
    mutDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
    self.contentL.text = [NSString stringWithFormat:@"%@     %@      %@",[mutDic objectForKey:OrderParamTypeContact_name],[mutDic objectForKey:OrderParamTypeContact_phone],[mutDic objectForKey:OrderParamTypeCar_license_no]];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *str;
    if ([mutDic objectForKey:OrderParamTypeGoTime]) {
        NSDate *date =[dateFormat dateFromString:[mutDic objectForKey:OrderParamTypeGoTime]];
        str = [dateFormat1 stringFromDate:date];
    }else{
        str = @"";
    }
    self.parkTimeL.text = [NSString stringWithFormat:@"预计停车时间：%@",str];
    
    if ([mutDic objectForKey:OrderParamTypeTime]) {
        NSDate *date =[dateFormat dateFromString:[mutDic objectForKey:OrderParamTypeTime]];
        str = [dateFormat1 stringFromDate:date];
    }else{
        str = @"";
    }
    self.pickTimeL.text = [NSString stringWithFormat:@"预计取车时间：%@",str];
 
    NSInteger days = -1;
    if ([mutDic objectForKey:OrderParamTypePark_day]) {
        days = [[mutDic objectForKey:OrderParamTypePark_day] integerValue];
    }
    if (days<0) {
        self.parkDayL.text = @"预计停车天数：";
    }else{
        self.parkDayL.text = [NSString stringWithFormat:@"预计停车天数：%ld天",days];
    }
    
    [self configTotalFees];
}

- (void)configTotalFees
{
    NSMutableDictionary *mutDic;
    mutDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
    NSInteger totalFee = 0;
    NSInteger firstdayfee = [[mutDic objectForKey:OrderParamTypeParkFeeFirstDay] integerValue];
    NSInteger dayfee = [[mutDic objectForKey:OrderParamTypeParkFeeDay] integerValue];
    NSInteger days = -1;
    if ([mutDic objectForKey:OrderParamTypePark_day]) {
        days = [[mutDic objectForKey:OrderParamTypePark_day] integerValue];
    }
    if (days>=0) {
        totalFee = firstdayfee + dayfee*days;
    }else{
        totalFee = firstdayfee;
    }
    if ([mutDic objectForKey:OrderParamTypeService]) {
        NSArray *arr = [[mutDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
        NSMutableArray *serviceArr = [NSMutableArray arrayWithArray:arr];
        for (NSString *str in serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"=>"];
            totalFee += [detailArr[3] integerValue];
        }
    }
    self.feeL.text = [NSString stringWithFormat:@"¥%ld",totalFee/100];
}
@end
