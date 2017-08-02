//
//  BAFCenterOrderView.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFCenterOrderView.h"


@interface BAFCenterOrderView()
@property (nonatomic, weak) IBOutlet UIView *goingView;
@property (nonatomic, weak) IBOutlet UIView *noneView;
@property (nonatomic, weak) IBOutlet UILabel *plan_park_timeL;
@property (nonatomic, weak) IBOutlet UILabel *car_license_noL;
@property (nonatomic, weak) IBOutlet UILabel *park_nameL;

//哪个代表当前状态？？？
@property (nonatomic, weak) IBOutlet UIImageView *orderSuccessIV;
@property (nonatomic, weak) IBOutlet UIImageView *parkFinishedIV;
@property (nonatomic, weak) IBOutlet UIImageView *waitToGetCarIV;
@property (nonatomic, weak) IBOutlet UIImageView *getCarSuccessIV;

@property (nonatomic, weak) IBOutlet UILabel *orderSuccessL;
@property (nonatomic, weak) IBOutlet UILabel *parkFinishedL;
@property (nonatomic, weak) IBOutlet UILabel *waitToGetCarL;
@property (nonatomic, weak) IBOutlet UILabel *getCarSuccessL;
@end


@implementation BAFCenterOrderView
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

//代码创建的会调用该方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addGestureOnBGView];
    }
    return self;
}

//通过xib创建的控件会调用通过该方法
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
//        [self addGestureOnBGView];
    }
    return self;
}

- (void)setType:(BAFCenterOrderViewType)type
{
    _type = type;
    switch (_type) {
        case kBAFCenterOrderViewTypeNone:
        {
            self.noneView.hidden = NO;
            self.goingView.hidden = YES;
        }
            break;
        case kBAFCenterOrderViewTypeGoing:
        {
            self.noneView.hidden = YES;
            self.goingView.hidden = NO;
        }
            break;
    }
}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    _orderDic = orderDic;
    if (self.type == kBAFCenterOrderViewTypeGoing) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        NSDate *date =[dateFormat dateFromString:[orderDic objectForKey:@"plan_park_time"]];
        NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *str = [dateFormat1 stringFromDate:date];
        self.plan_park_timeL.text = [NSString stringWithFormat:@"预约泊车时间:%@",str];
        self.car_license_noL.text = [orderDic objectForKey:@"car_license_no"];
        self.park_nameL.text = [orderDic objectForKey:@"park_name"];
//        "order_status" = "park_appoint";
        
        self.orderSuccessIV.image = [UIImage imageNamed:@"home_order_gray"];
        self.parkFinishedIV.image = [UIImage imageNamed:@"home_order_gray"];
        self.waitToGetCarIV.image = [UIImage imageNamed:@"home_order_gray"];
        self.getCarSuccessIV.image = [UIImage imageNamed:@"home_order_gray"];
        
        self.orderSuccessL.textColor = [UIColor colorWithHex:0x969696];
        self.parkFinishedL.textColor = [UIColor colorWithHex:0x969696];
        self.waitToGetCarL.textColor = [UIColor colorWithHex:0x969696];
        self.getCarSuccessL.textColor = [UIColor colorWithHex:0x969696];
        
        NSString *orderStatus = [orderDic objectForKey:@"order_status"];
        if ([orderStatus isEqualToString:@"park_appoint"]||
            [orderStatus isEqualToString:@"approve"]) {
            //预约泊车成功
            self.orderSuccessIV.image = [UIImage imageNamed:@"home_order_blue1"];
            self.orderSuccessL.textColor = [UIColor colorWithHex:0x3492e9];
        }else if([orderStatus isEqualToString:@"park"]){
            //泊车成功
            self.parkFinishedIV.image = [UIImage imageNamed:@"home_order_blue1"];
            self.parkFinishedL.textColor = [UIColor colorWithHex:0x3492e9];
        }else if ([orderStatus isEqualToString:@"pick_appoint"]){
            //待取车
            self.waitToGetCarIV.image = [UIImage imageNamed:@"home_order_blue1"];
            self.waitToGetCarL.textColor = [UIColor colorWithHex:0x3492e9];
        }else if ([orderStatus isEqualToString:@"pick_sure"]||
                  [orderStatus isEqualToString:@"payment_sure"]||
                  [orderStatus isEqualToString:@"finish"]){
            //取车成功
            self.getCarSuccessIV.image = [UIImage imageNamed:@"home_order_blue1"];
            self.getCarSuccessL.textColor = [UIColor colorWithHex:0x3492e9];
        }
    }
}


- (IBAction)showOrderDetail:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(showOrderDetail:)]) {
        [self.delegate showOrderDetail:sender];
    }
}

@end
