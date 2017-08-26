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
#import "HRLOrderInterface.h"
#import "HRLogicManager.h"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexOrderFeeRequest,
};

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
@property (strong, nonatomic) NSDictionary      *feeDic;


@property (assign, nonatomic) NSInteger daystochange;
@end

@implementation SuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contactBtn.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.contactBtn.layer.borderWidth = 0.5f;
    self.checktBtn.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.checktBtn.layer.borderWidth = 0.5f;
    
    self.daystochange = 0;
    self.feeDic = [NSMutableDictionary dictionary];
    
    self.contactBtn.clipsToBounds = YES;
    self.contactBtn.layer.cornerRadius = 3.0f;
    
    self.checktBtn.clipsToBounds = YES;
    self.checktBtn.layer.cornerRadius = 3.0f;
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
    self.navigationItem.hidesBackButton  = YES;
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
            if (self.isEdit) {
                [self setNavigationTitle:@"修改成功"];
            }else{
                [self setNavigationTitle:@"预约成功"];
            }
            self.successView.hidden = NO;
            self.failureView.hidden = YES;
            self.rechargeSuccessView.hidden = YES;
            self.payView.hidden = YES;
            [self.view addSubview:self.buttonView];
            self.buttonView.hidden = NO;
            [self.buttonView setFrame:CGRectMake(0, CGRectGetMaxY(self.successView.frame), screenWidth, 100)];
            
            [self configSuccessView];
            
            if (self.orderId) {
                [self orderFeeRequest];
            }
        }
            break;
        default:
            break;
    }
}

- (void)backMethod:(id)sender
{
    if (self.type != kSuccessViewControllerTypePay) {
        for (UIViewController *tempVC in self.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
                [self.navigationController popToViewController:tempVC animated:YES];
            }
        }
    }else{
        for (UIViewController *tempVC in self.navigationController.viewControllers) {
            if ([tempVC isKindOfClass:[OrderListViewController class]]) {
                ((OrderListViewController *)tempVC).isNeedtoRefresh = YES;
                [self.navigationController popToViewController:tempVC animated:YES];
            }
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
    
    NSDate *datepark =[dateFormat dateFromString:[mutDic objectForKey:@"actual_park_time"]];
    NSDate *datepick =[dateFormat dateFromString:[mutDic objectForKey:@"actual_pick_time"]];
    BOOL isActualParkTime = YES;
    BOOL isActualPickTime = YES;
    if (!datepark) {
        datepark =[dateFormat dateFromString:[mutDic objectForKey:@"plan_park_time"]];
        isActualParkTime = NO;
    }
    if (!datepick) {
        datepick =[dateFormat dateFromString:[mutDic objectForKey:@"plan_pick_time"]];
        isActualPickTime = NO;
    }
    
    NSString *strpark;
    if (datepark) {
        strpark = [dateFormat1 stringFromDate:datepark];
    }else{
        strpark = @"";
    }
    
    NSString *strpick;
    if (datepick) {
        strpick = [dateFormat1 stringFromDate:datepick];
    }else{
        strpick = @"";
    }
    

    if (isActualParkTime) {
        self.parkTimeL.text = [NSString stringWithFormat:@"实际泊车时间：%@",strpark];
    }else{
        self.parkTimeL.text = [NSString stringWithFormat:@"预计泊车时间：%@",strpark];
    }
    
    if (isActualPickTime) {
        self.pickTimeL.text = [NSString stringWithFormat:@"实际取车时间：%@",strpick];
    }else{
        self.pickTimeL.text = [NSString stringWithFormat:@"预计取车时间：%@",strpick];
    }
}

- (void)configTotalFees
{
    NSMutableDictionary *mutDic;
    mutDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
    NSInteger totalFee = 0;
    NSInteger firstdayfee = [[mutDic objectForKey:OrderParamTypeParkFeeFirstDay] integerValue];
    NSInteger dayfee = [[mutDic objectForKey:OrderParamTypeParkFeeDay] integerValue];
    NSInteger days = -1;
    if ([mutDic objectForKey:OrderParamTypeTime]) {
        if ([mutDic objectForKey:OrderParamTypePark_day]) {
            days = [[mutDic objectForKey:OrderParamTypePark_day] integerValue];
        }else {
            days = self.daystochange;
        }
        days = days-1;
        if (days>=0) {
            totalFee = firstdayfee + dayfee*days;
        }else{
            totalFee = firstdayfee;
        }
    }
    
    if ([mutDic objectForKey:OrderParamTypeService]) {
        NSArray *arr = [[mutDic objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
        NSMutableArray *serviceArr = [NSMutableArray arrayWithArray:arr];
        for (NSString *str in serviceArr) {
            NSArray *detailArr = [str componentsSeparatedByString:@"=>"];
            if ([str containsString:@"自行往返航站楼"]) {
                totalFee -= [detailArr[3] integerValue];
            }else{
                totalFee += [detailArr[3] integerValue];
            }
        }
    }else{
        totalFee = [[[self.feeDic objectForKey:@"order_price"]objectForKey:@"before_discount_total_price"] integerValue];
    }
    
    if (totalFee<=0) {
        totalFee = 0;
    }
    self.feeL.text = [NSString stringWithFormat:@"¥%ld",totalFee/100];
}

- (void)orderFeeRequest
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [orderReq orderFeeRequestWithNumberIndex:kRequestNumberIndexOrderFeeRequest delegte:self order_id:self.orderId];
}

#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexOrderFeeRequest) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.feeDic = [obj objectForKey:@"data"];
            NSInteger days = [[self.feeDic objectForKey:@"park_day"] integerValue];
            if (days<=0) {
                self.parkDayL.text = @"预计停车天数：";
            }else{
                self.parkDayL.text = [NSString stringWithFormat:@"预计停车天数：%ld天",days];
            }

            
            [self configTotalFees];
        }else{
            
        }
    }
}
@end
