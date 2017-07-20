//
//  OrderDetailStatusTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/9.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderDetailStatusTableViewCell.h"

@interface OrderDetailStatusTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *orderOperatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation OrderDetailStatusTableViewCell
//65
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOperatorDic:(NSDictionary *)operatorDic
{
    _operatorDic = operatorDic;
    NSString *action = [operatorDic objectForKey:@"action"];
    if ([action isEqualToString:@"park_appoint"]) {
        self.orderOperatorLabel.text = @"预约泊车成功，订单已分派，形成改变请及时修改您的预约信息。";
    }
    if ([action isEqualToString:@"cancel"]) {
        self.orderOperatorLabel.text = @"订单已取消";
    }
    if ([action isEqualToString:@"park"]) {
        self.orderOperatorLabel.text = @"车辆已停放至车场，停车开始计费，如回程时间改变，请及时修改您的取车时间";
    }
    if ([action isEqualToString:@"pick_sure"]) {
        self.orderOperatorLabel.text = @"取车时间已确认，停车结束计费，订单费用可在线支付或交现金给工作人员";
    }
    if ([action isEqualToString:@"finish"]) {
        self.orderOperatorLabel.text = @"取车成功！感谢使用泊安飞服务，业务咨询或意见反馈，可致电4008138666联系客服。";
    }
    if ([action isEqualToString:@"wash_car"]) {
        self.orderOperatorLabel.text = @"已为您的爱车洗车";
    }
    if ([action isEqualToString:@"fill_oil"]) {
        self.orderOperatorLabel.text = @"已为您的爱车代加油100元";
    }
    self.timeLabel.text = [self.operatorDic objectForKey:@"create_time"];
    
}

@end
