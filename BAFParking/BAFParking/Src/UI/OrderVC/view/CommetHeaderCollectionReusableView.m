//
//  CommetHeaderCollectionReusableView.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CommetHeaderCollectionReusableView.h"

@implementation CommetHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setstarScore
{
    self.star1.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star2.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star3.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star4.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    self.star5.image = [UIImage imageNamed:@"parking_xiangq_star1"];
    
//    if (commentInfo.avg_star.integerValue == 1) {
//        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//    }
//    if (commentInfo.avg_star.integerValue == 2) {
//        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//    }
//    if (commentInfo.avg_star.integerValue == 3) {
//        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//    }
//    if (commentInfo.avg_star.integerValue == 4) {
//        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        
//    }
//    if (commentInfo.avg_star.integerValue == 5) {
//        self.star1.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star2.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star3.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star4.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//        self.star5.image = [UIImage imageNamed:@"parking_xiangq_star2"];
//    }
}

@end
