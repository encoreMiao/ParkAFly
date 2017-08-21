//
//  CommetHeaderCollectionReusableView.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CommetHeaderCollectionReusableView.h"

@interface CommetHeaderCollectionReusableView()
@property (weak, nonatomic) IBOutlet UIView *paysucessLine;
@property (weak, nonatomic) IBOutlet UILabel *paysuceessLabel;
@property (weak, nonatomic) IBOutlet UIImageView *paysuccessIMG;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationTopConstraint;
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
    
//    pingj_star2
    self.star1.image = [UIImage imageNamed:@"pingj_star2"];
    self.star2.image = [UIImage imageNamed:@"pingj_star2"];
    self.star3.image = [UIImage imageNamed:@"pingj_star2"];
    self.star4.image = [UIImage imageNamed:@"pingj_star2"];
    self.star5.image = [UIImage imageNamed:@"pingj_star2"];
}

- (void)tapStarScore1
{
    self.star1.image = [UIImage imageNamed:@"pingj_star2"];
    self.star2.image = [UIImage imageNamed:@"pingj_star1"];
    self.star3.image = [UIImage imageNamed:@"pingj_star1"];
    self.star4.image = [UIImage imageNamed:@"pingj_star1"];
    self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    if (self.handler) {
        self.handler(1);
    }
}

- (void)tapStarScore2
{
    self.star1.image = [UIImage imageNamed:@"pingj_star2"];
    self.star2.image = [UIImage imageNamed:@"pingj_star2"];
    self.star3.image = [UIImage imageNamed:@"pingj_star1"];
    self.star4.image = [UIImage imageNamed:@"pingj_star1"];
    self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    if (self.handler) {
        self.handler(2);
    }
}

- (void)tapStarScore3
{
    self.star1.image = [UIImage imageNamed:@"pingj_star2"];
    self.star2.image = [UIImage imageNamed:@"pingj_star2"];
    self.star3.image = [UIImage imageNamed:@"pingj_star2"];
    self.star4.image = [UIImage imageNamed:@"pingj_star1"];
    self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    if (self.handler) {
        self.handler(3);
    }
}

- (void)tapStarScore4
{
    self.star1.image = [UIImage imageNamed:@"pingj_star2"];
    self.star2.image = [UIImage imageNamed:@"pingj_star2"];
    self.star3.image = [UIImage imageNamed:@"pingj_star2"];
    self.star4.image = [UIImage imageNamed:@"pingj_star2"];
    self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    if (self.handler) {
        self.handler(4);
    }
}

- (void)tapStarScore5
{
    self.star1.image = [UIImage imageNamed:@"pingj_star2"];
    self.star2.image = [UIImage imageNamed:@"pingj_star2"];
    self.star3.image = [UIImage imageNamed:@"pingj_star2"];
    self.star4.image = [UIImage imageNamed:@"pingj_star2"];
    self.star5.image = [UIImage imageNamed:@"pingj_star2"];
    if (self.handler) {
        self.handler(5);
    }
}

- (void)setType:(CommetHeaderCollectionReusableViewType)type
{
    _type = type;
    self.paysuccessIMG.hidden = YES;
    self.paysucessLine.hidden = YES;
    self.paysuceessLabel.hidden = YES;
    
    switch (type) {
        case CommetHeaderCollectionReusableViewTypeCheck:
            self.userInteractionEnabled = NO;
            self.notificationTopConstraint.constant = 15;
            break;
        case CommetHeaderCollectionReusableViewTypeComment:
            self.userInteractionEnabled = YES;
            self.notificationTopConstraint.constant = 15;
            break;
        case CommetHeaderCollectionReusableViewTypePay:
            self.userInteractionEnabled = YES;
            self.notificationTopConstraint.constant = 128;
            self.paysuccessIMG.hidden = NO;
            self.paysucessLine.hidden = NO;
            self.paysuceessLabel.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    _orderDic = orderDic;
    if ([_orderDic objectForKey:@"park_name"]) {
        self.parkNameLabel.text = [_orderDic objectForKey:@"park_name"];
    }else if([_orderDic objectForKey:@"park"]){
        NSString *title = [[_orderDic objectForKey:@"park"] objectForKey:@"map_title"];
        self.parkNameLabel.text = title;
    }
    
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDateFormatter* dateFormat1 = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //优先显示实际停车时间
    NSDate *datepark = nil;
    datepark =[dateFormat dateFromString:[orderDic objectForKey:@"actual_park_time"]];
    if (!datepark) {
        datepark =[dateFormat dateFromString:[orderDic objectForKey:@"plan_park_time"]];
    }
    NSString *strpark = [dateFormat1 stringFromDate:datepark];
    self.parkTimeLabel.text = strpark;
}

- (void)setScore:(NSString *)score
{
    _score = score;
    self.star1.image = [UIImage imageNamed:@"pingj_star2"];
    self.star2.image = [UIImage imageNamed:@"pingj_star2"];
    self.star3.image = [UIImage imageNamed:@"pingj_star2"];
    self.star4.image = [UIImage imageNamed:@"pingj_star2"];
    self.star5.image = [UIImage imageNamed:@"pingj_star2"];
    if(score.integerValue == 1){
        self.star2.image = [UIImage imageNamed:@"pingj_star1"];
        self.star3.image = [UIImage imageNamed:@"pingj_star1"];
        self.star4.image = [UIImage imageNamed:@"pingj_star1"];
        self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    }else if(score.integerValue == 2){
        self.star3.image = [UIImage imageNamed:@"pingj_star1"];
        self.star4.image = [UIImage imageNamed:@"pingj_star1"];
        self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    }else if(score.integerValue == 3){
        self.star4.image = [UIImage imageNamed:@"pingj_star1"];
        self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    }else if(score.integerValue == 4){
        self.star5.image = [UIImage imageNamed:@"pingj_star1"];
    }
}
@end
