//
//  OrderDetail1TableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/9.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderDetail1TableViewCell.h"

@interface OrderDetail1TableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
//哪个代表当前状态？？？
@property (nonatomic, weak) IBOutlet UIImageView *orderSuccessIV;
@property (nonatomic, weak) IBOutlet UIImageView *parkFinishedIV;
@property (nonatomic, weak) IBOutlet UIImageView *waitToGetCarIV;
@property (nonatomic, weak) IBOutlet UIImageView *getCarSuccessIV;
@property (nonatomic, weak) IBOutlet UILabel *nameDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, weak) IBOutlet UILabel *orderSuccessL;
@property (nonatomic, weak) IBOutlet UILabel *parkFinishedL;
@property (nonatomic, weak) IBOutlet UILabel *waitToGetCarL;
@property (nonatomic, weak) IBOutlet UILabel *getCarSuccessL;
@end

@implementation OrderDetail1TableViewCell
//135
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    _orderDic = orderDic;
    
    
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

@end
