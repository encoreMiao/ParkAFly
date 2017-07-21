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

    // Configure the view for the selected state
}

- (void)setCommentInfo:(BAFParkCommentInfo *)commentInfo
{
    _commentInfo = commentInfo;
    NSString *totalUrl = [NSString stringWithFormat:@"%@%@",Server_Url, commentInfo.avatar];
//    http://parknfly.cn
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:totalUrl] placeholderImage:[UIImage imageNamed:@"btn_img"]];
//    self.headImageView.image = [UIImage imageNamed:@"btn_img"];
    
    self.phoneLabel.text = commentInfo.contact_phone;
    
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
    
    self.timeLabel.text = _commentInfo.create_time;
    
    
}
@end
