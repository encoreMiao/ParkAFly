//
//  ParkCollectionViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ParkCollectionViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setParkImage:(NSString *)parkImageStr
{
    NSString *urlStr = [NSString stringWithFormat:@"Uploads/order2/%@",parkImageStr];
    NSString *totalUrl = REQURL(urlStr);
    [self.parkImageview sd_setImageWithURL:[NSURL URLWithString:totalUrl] placeholderImage:[UIImage imageNamed:@"order_xiangq_photo"]];
}

@end
