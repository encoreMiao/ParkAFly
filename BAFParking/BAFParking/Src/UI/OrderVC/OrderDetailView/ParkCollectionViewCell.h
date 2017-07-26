//
//  ParkCollectionViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/26.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *parkImageview;
- (void)setParkImage:(NSString *)parkImageStr;
@end
