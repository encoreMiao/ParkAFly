//
//  RightsTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "RightsTableViewCell.h"

@interface RightsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *rightsTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightsNumber;
@property (weak, nonatomic) IBOutlet UILabel *rightsStatus;
@property (weak, nonatomic) IBOutlet UILabel *rightsUpdateTime;
@property (weak, nonatomic) IBOutlet UIButton *detailbutton;
@end

@implementation RightsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.detailbutton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.detailbutton.layer.borderWidth = 0.5f;
    self.detailbutton.layer.cornerRadius = 10.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)useNotiAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(useNotiActionDelegate:)])
    {
        [self.delegate useNotiActionDelegate:self];
    }
}

- (void)setAccountInfo:(BAFEquityAccountInfo *)accountInfo
{
    _accountInfo = accountInfo;
    self.rightsTitle.text = accountInfo.type_name;
    self.rightsNumber.text = accountInfo.card_no;
    NSString *str = accountInfo.status;
    if ([str isEqualToString:@"normal"]) {
        str = @"使用状态：正常";
    }else if ([str isEqualToString:@"inactive"]) {
        str = @"使用状态：未激活";
    }else if ([str isEqualToString:@"invalid"]) {
        str = @"使用状态：无效";
    }
    self.rightsStatus.text = str;
    
    self.rightsUpdateTime.text = [NSString stringWithFormat:@"使用期限：%@ - %@",accountInfo.begin_time, accountInfo.end_time];
    
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
