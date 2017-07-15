//
//  OrderDetail1TableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/9.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetail1TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
//哪个代表当前状态？？？
@property (nonatomic, weak) IBOutlet UIImageView *orderSuccessIV;
@property (nonatomic, weak) IBOutlet UIImageView *parkFinishedIV;
@property (nonatomic, weak) IBOutlet UIImageView *waitToGetCarIV;
@property (nonatomic, weak) IBOutlet UIImageView *getCarSuccessIV;
@property (nonatomic, weak) IBOutlet UILabel *nameDetailLabel;
@end
