//
//  OrderListTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderListTableViewCell.h"

@interface OrderListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *carlicenseL;
@property (weak, nonatomic) IBOutlet UIButton *orderstatus;
@property (weak, nonatomic) IBOutlet UILabel *parkL;
@property (weak, nonatomic) IBOutlet UILabel *parkTime;
@property (weak, nonatomic) IBOutlet UILabel *pickTime;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation OrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderstatus.tag = kOrderListTableViewCellTypeDetail;
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailGesture)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    self.parkTime.text = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"plan_park_time"]];
    self.carlicenseL.text = [orderDic objectForKey:@"car_license_no"];
    self.parkL.text = [orderDic objectForKey:@"park_name"];
    
    if (![[orderDic objectForKey:@"plan_pick_time"]isEqualToString:@"0000-00-00 00:00:00"]) {
        self.pickTime.text = [NSString stringWithFormat:@"%@",[orderDic objectForKey:@"plan_pick_time"]];
    }else{
        self.pickTime.text = @"";
    }
    
//    业务状态:预约成功-停车完成-待支付-支付待确认- 已完成
    NSString *orderStatus = [orderDic objectForKey:@"order_status"];
    if ([orderStatus isEqualToString:@"park_appoint"]||[orderStatus isEqualToString:@"approve"]) {
        //已分派泊车经理//预约泊车成功
        //此时可修改下单首页的全部信息2 修改1
        self.modifyButton.hidden = NO;
        [self.modifyButton setTitle:@"修改" forState:UIControlStateNormal];
        self.cancelButton.hidden = NO;
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        self.modifyButton.tag = kOrderListTableViewCellTypeModifyAll;
        self.cancelButton.tag = kOrderListTableViewCellTypeCancel;
        
        [self.orderstatus setTitle:@"预约成功" forState:UIControlStateNormal];
    }
    else if([orderStatus isEqualToString:@"park"]){
        //泊车成功
        //只能修改取车信息3
        self.modifyButton.hidden = YES;
        self.cancelButton.hidden = NO;
        [self.cancelButton setTitle:@"修改" forState:UIControlStateNormal];
        self.cancelButton.tag = kOrderListTableViewCellTypeModifyPart;
        
        [self.orderstatus setTitle:@"停车完成" forState:UIControlStateNormal];
        
    }else if ([orderStatus isEqualToString:@"pick_appoint"]){
        //已自动分派取车经理
        self.modifyButton.hidden = YES;
        self.cancelButton.hidden = YES;
        [self.orderstatus setTitle:@"停车完成" forState:UIControlStateNormal];
    }else if ([orderStatus isEqualToString:@"finish"]){
        //服务结束
        self.modifyButton.hidden = YES;
        self.cancelButton.hidden = YES;
        [self.cancelButton setTitle:@"查看评价" forState:UIControlStateNormal];
        self.cancelButton.tag = kOrderListTableViewCellTypeCheckComment;
        
        [self.orderstatus setTitle:@"已完成" forState:UIControlStateNormal];
    }
    else if ([orderStatus isEqualToString:@"payment_sure"]){
        //已支付待确认
        self.modifyButton.hidden = YES;
        self.cancelButton.hidden = NO;
        [self.cancelButton setTitle:@"评价" forState:UIControlStateNormal];
        self.cancelButton.tag = kOrderListTableViewCellTypeComment;
        
        [self.orderstatus setTitle:@"支付待确认" forState:UIControlStateNormal];
    }
    else if ([orderStatus isEqualToString:@"pick_sure"]){
        //已确认取车
        self.modifyButton.hidden = YES;
        self.cancelButton.hidden = NO;
        [self.cancelButton setTitle:@"支付" forState:UIControlStateNormal];
        self.cancelButton.tag = kOrderListTableViewCellTypePay;
        
        [self.orderstatus setTitle:@"待支付" forState:UIControlStateNormal];
       
    }
}

- (IBAction)modifyAction:(UIButton *)sender {
    //修改
    if ([self.delegate respondsToSelector:@selector(orderBtnActionTag:cell:)]) {
        [self.delegate orderBtnActionTag:sender.tag cell:self];
    }
}
- (IBAction)cancelAction:(UIButton *)sender {
    //取消
    if ([self.delegate respondsToSelector:@selector(orderBtnActionTag:cell:)]) {
        [self.delegate orderBtnActionTag:sender.tag cell:self];
    }
}

//订单状态
- (IBAction)orderstatusAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(orderBtnActionTag:cell:)]) {
        [self.delegate orderBtnActionTag:kOrderListTableViewCellTypeDetail cell:self];
    }
}

- (void)detailGesture{
    if ([self.delegate respondsToSelector:@selector(orderBtnActionTag:cell:)]) {
        [self.delegate orderBtnActionTag:kOrderListTableViewCellTypeDetail cell:self];
    }
}
@end
