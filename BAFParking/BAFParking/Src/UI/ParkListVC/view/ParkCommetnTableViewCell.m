//
//  ParkCommetnTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkCommetnTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ParkCommetnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 22.0f;
    self.commetTagLabel.layer.borderColor = [[UIColor colorWithHex:0x3492e9] CGColor];
    self.commetTagLabel.layer.borderWidth = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCommentInfo:(BAFParkCommentInfo *)commentInfo
{
    _commentInfo = commentInfo;
    NSString *totalUrl = [NSString stringWithFormat:@"%@%@",Server_Url, commentInfo.avatar];
//    http://parknfly.cn
    self.headImageView.layer.cornerRadius = 44.0/2;
    self.headImageView.layer.borderColor = [[UIColor clearColor] CGColor];
    self.headImageView.layer.borderWidth = 0.0f;
    self.headImageView.clipsToBounds = YES;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:totalUrl] placeholderImage:[UIImage imageNamed:@"btn_img"]];
    
    self.phoneLabel.text = [self numberSuitScanf:commentInfo.contact_phone];
    
    NSString *totalStr = commentInfo.remark;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, totalStr.length)];
    self.comentLabel.attributedText = attributeStr;
    
    if ([commentInfo.tags isEqualToString:@""] || !commentInfo.tags) {
        self.commetTagLabel.hidden = YES;
    }else{
        self.commetTagLabel.hidden = NO;
        self.commetTagLabel.text = commentInfo.tags;
    }
    
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    
    if (commentInfo.score.integerValue == 1) {
        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    }
    if (commentInfo.score.integerValue == 2) {
        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    }
    if (commentInfo.score.integerValue == 3) {
        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    }
    if (commentInfo.score.integerValue == 4) {
        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        
    }
    if (commentInfo.score.integerValue == 5) {
        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        self.star5.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    }
    
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:_commentInfo.create_time];
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *str = [dateFormat1 stringFromDate:date];
    self.timeLabel.text = str;

    if ([_commentInfo.reply isEqualToString:@""]||
        _commentInfo.reply == nil||
        [_commentInfo.reply isEqual:[NSNull null]]) {
        self.replylabel.text = @"";
    }
    else{
        NSString *replyStr = [NSString stringWithFormat:@"泊安飞回复：\n%@",_commentInfo.reply];
        NSMutableAttributedString *mutAttr = [[NSMutableAttributedString alloc]initWithString:replyStr];
        [mutAttr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, replyStr.length)];
        [mutAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x323232],NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle} range:[replyStr rangeOfString:_commentInfo.reply]];
        self.replylabel.attributedText = mutAttr;
    }
}

-(NSString *)numberSuitScanf:(NSString*)number{
    
//    //首先验证是不是手机号码
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\\\d{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    BOOL isOk = [regextestmobile evaluateWithObject:number];
//    if (isOk) {//如果是手机号码的话
        NSString *numberString = [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return numberString;
//    }
//    return number;
}

@end
