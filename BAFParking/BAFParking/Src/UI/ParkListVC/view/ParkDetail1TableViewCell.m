//
//  ParkDetail1TableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkDetail1TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BAFParkCommentInfo.h"

@interface ParkDetail1TableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *parkImage;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@end


@implementation ParkDetail1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setParkDetailInfo:(BAFParkInfo *)parkDetailInfo
{
    _parkDetailInfo = parkDetailInfo;
    if (parkDetailInfo) {
        NSString *urlStr = [NSString stringWithFormat:@"Uploads/Picture/%@",self.parkDetailInfo.map_pic];
        NSString *totalUrl = REQURL(urlStr);
        [self.parkImage sd_setImageWithURL:[NSURL URLWithString:totalUrl]];
        
        self.parkNameLabel.text = self.parkDetailInfo.map_address;
        
        NSString *carFee = [NSString stringWithFormat:@"车位费：%@",self.parkDetailInfo.map_price];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:carFee];
        [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xfb694b],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:[carFee rangeOfString:self.parkDetailInfo.map_price]];
        self.feeLabel.attributedText = mutStr;
        
        NSString *mapAddress = [NSString stringWithFormat:@"地址：%@",self.parkDetailInfo.map_address];
        NSMutableAttributedString *mutAddressStr = [[NSMutableAttributedString alloc]initWithString:mapAddress];
        [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x323232],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:[carFee rangeOfString:self.parkDetailInfo.map_address]];
        self.addressLabel.attributedText = mutAddressStr;
    }
}

- (void)setParkCommentList:(NSArray *)parkCommentList
{
    _parkCommentList = parkCommentList;
    if (parkCommentList.count>=1) {
        BAFParkCommentInfo *commentInfo = _parkCommentList[0];
        NSString *str = [NSString stringWithFormat:@"%.1f分  %ld条评价",commentInfo.avg_score.floatValue,_parkCommentList.count];
        self.scoreLabel.text = str;
        
        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];

        if (commentInfo.avg_star.integerValue == 1) {
            self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        }
        if (commentInfo.avg_star.integerValue == 2) {
            self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        }
        if (commentInfo.avg_star.integerValue == 3) {
            self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        }
        if (commentInfo.avg_star.integerValue == 4) {
            self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            
        }
        if (commentInfo.avg_star.integerValue == 5) {
            self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
            self.star5.image = [UIImage imageNamed:@"parking_xiangq_star2"];
        }
    }
    
}

- (IBAction)addressAction:(id)sender {
    DLog(@"地图页面");
}


@end
