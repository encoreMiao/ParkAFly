//
//  ChargeFooterCollectionReusableView.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChargeFooterCollectionReusableView;

@protocol ChargeFooterCollectionReusableViewDelegate <NSObject>
- (void)chargeActionDelegate:(ChargeFooterCollectionReusableView *)footerView;
@end

@interface ChargeFooterCollectionReusableView : UICollectionReusableView
- (IBAction)chargeAction:(id)sender;
@property (nonatomic, weak) id<ChargeFooterCollectionReusableViewDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *label;
@end
