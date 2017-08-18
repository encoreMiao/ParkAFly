//
//  OrderListTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OrderListTableViewCellType) {
    //有实际时间读取实际时间
    
    //修改时提交按钮为保存，泊车时间定位到当前时间两小时之后
    kOrderListTableViewCellTypeModifyAll,//实际未停车，锁定出发航站楼、停车场项，其他信息可修改(如需修改，需联系客服或重新下单)
    kOrderListTableViewCellTypeModifyPart,//实际已停车，修改时锁定泊车时间、出发航站楼、停车场项，只能修改取车时间、返程航站楼，保存后提交  (按钮为修改？？？那取车按钮呢？)
    kOrderListTableViewCellTypeCancel,//未停车可取消
    kOrderListTableViewCellTypePay,//车场端【确认取车】后可进行支付，点击跳转到订单支付
    kOrderListTableViewCellTypeComment,//已完成订单评价：支付完成的订单可进行评价(线上支付完成的当时即可评价)
    kOrderListTableViewCellTypeCheckComment,//已完成订单查看评价。
    kOrderListTableViewCellTypeDetail,//查看订单详情
};

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

