//
//  PopFeeShowTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/27.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopFeeShowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *popfeetitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *popfeeMoneyLabel;
@end

