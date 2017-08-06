//
//  OrderServiceTableViewCell.h
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAFParkServiceInfo.h"
@class OrderServiceTableViewCell;


@protocol OrderServiceTableViewCellDelegate <NSObject>
- (void)OrderServiceTableViewCellAction:(OrderServiceTableViewCell *)cell;
@end

typedef NS_ENUM(NSInteger,OrderServiceTableViewCellType){
    kOrderServiceTableViewCellTypeCommon,
    kOrderServiceTableViewCellTypeCommonText,
    kOrderServiceTableViewCellTypeDisclosure,
    
    kOrderServiceTableViewCellTypeMore,//更多服务
};

@interface OrderServiceTableViewCell : UITableViewCell
@property (nonatomic, strong) BAFParkServiceInfo    *serviceInfo;
@property (nonatomic, assign) OrderServiceTableViewCellType type;
@property (nonatomic, assign) BOOL  show;
@property (nonatomic, assign) id<OrderServiceTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSString *parkflyno;
@property (weak, nonatomic) IBOutlet UIView     *moreServiceView;
//@property (weak, nonatomic) IBOutlet UILabel    *moreServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *more1ServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *more1MoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel    *more2ServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel    *more2MoneyLabel;
@end
