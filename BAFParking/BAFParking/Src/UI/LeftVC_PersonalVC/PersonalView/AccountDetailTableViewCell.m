//
//  AccountDetailTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "AccountDetailTableViewCell.h"

@interface AccountDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation AccountDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPatrInfo:(BAFClientPatrInfo *)patrInfo
{
    _patrInfo = patrInfo;
    NSString *str = [NSString stringWithFormat:@"%0.f",patrInfo.money.integerValue/100.0f];
    
//    "status": "3" //类型:1.充值;2.充值活动;3.账户余额支付;4.充值卡充值
    switch (patrInfo.status.integerValue) {
        case 1:
            self.typeLabel.text = @"充值";
            str = [NSString stringWithFormat:@"+%@",str];
            break;
        case 2:
            self.typeLabel.text = @"充值";
            str = [NSString stringWithFormat:@"+%@",str];
            break;
        case 3:
            self.typeLabel.text = @"支出";
            str = [NSString stringWithFormat:@"-%@",str];
            break;
        case 4:
            self.typeLabel.text = @"充值";
            str = [NSString stringWithFormat:@"+%@",str];
            break;
        default:
            break;
    }
    self.accountLabel.text = str;
    self.timeLabel.text = [self getTimeWithTime:patrInfo.time];
}

-(NSString*)getTimeWithTime:(NSString *)timeStr
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateStyle:NSDateFormatterMediumStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    
    NSTimeInterval interval = timeStr.doubleValue;
    // 毫秒值转化为秒
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


@end
