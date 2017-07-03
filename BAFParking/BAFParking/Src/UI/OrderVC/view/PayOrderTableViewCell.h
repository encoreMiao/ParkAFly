//
//  PayOrderTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/3.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PayOrderTableViewCell;

@protocol PayOrderTableViewCellDelegate <NSObject>
- (void)selectBtnDelegate:(PayOrderTableViewCell *)cell;
@end

@interface PayOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImg;
@property (weak, nonatomic) id<PayOrderTableViewCellDelegate> delegate;

@property (nonatomic, assign) BOOL  show;

@end
