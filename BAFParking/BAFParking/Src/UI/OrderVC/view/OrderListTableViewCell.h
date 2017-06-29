//
//  OrderListTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderListTableViewCell;

@protocol OrderListTableViewCellDelegate <NSObject>
- (void)orderBtnActionTag:(NSInteger)btnTag cell:(OrderListTableViewCell *)cell;
@end

@interface OrderListTableViewCell : UITableViewCell
@property (nonatomic, assign) id<OrderListTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSDictionary *orderDic;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@end

