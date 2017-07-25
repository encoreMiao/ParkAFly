//
//  CommetHeaderCollectionReusableView.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CommetHeaderCollectionReusableView.h"

@interface CommetHeaderCollectionReusableView()
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@end

@implementation CommetHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.star1.userInteractionEnabled = YES;
    self.star2.userInteractionEnabled = YES;
    self.star3.userInteractionEnabled = YES;
    self.star4.userInteractionEnabled = YES;
    self.star5.userInteractionEnabled = YES;
    
    UITapGestureRecognizer* gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarScore1)];
    [self.star1 addGestureRecognizer:gesture1];
    UITapGestureRecognizer* gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarScore2)];
    [self.star2 addGestureRecognizer:gesture2];
    UITapGestureRecognizer* gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarScore3)];
    [self.star3 addGestureRecognizer:gesture3];
    UITapGestureRecognizer* gesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarScore4)];
    [self.star4 addGestureRecognizer:gesture4];
    UITapGestureRecognizer* gesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarScore5)];
    [self.star5 addGestureRecognizer:gesture5];
    
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star2"];
}

- (void)tapStarScore1
{
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    if (self.handler) {
        self.handler(1);
    }
}

- (void)tapStarScore2
{
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    if (self.handler) {
        self.handler(2);
    }
}

- (void)tapStarScore3
{
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    if (self.handler) {
        self.handler(3);
    }
}

- (void)tapStarScore4
{
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    if (self.handler) {
        self.handler(4);
    }
}

- (void)tapStarScore5
{
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    if (self.handler) {
        self.handler(5);
    }
}

- (void)setType:(CommetHeaderCollectionReusableViewType)type
{
    _type = type;
    switch (type) {
        case CommetHeaderCollectionReusableViewTypeCheck:
            self.userInteractionEnabled = NO;
            break;
        case CommetHeaderCollectionReusableViewTypeComment:
            self.userInteractionEnabled = YES;
            break;
        default:
            break;
    }
}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    _orderDic = orderDic;
    self.parkNameLabel.text = [_orderDic objectForKey:@"park_name"];
    self.parkTimeLabel.text = [_orderDic objectForKey:@"actual_park_time"];
}

- (void)setScore:(NSString *)score
{
    _score = score;
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star2"];
    if(score.integerValue == 1){
        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    }else if(score.integerValue == 2){
        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    }else if(score.integerValue == 3){
        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
        self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    }else if(score.integerValue == 4){
        self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    }
}
@end
