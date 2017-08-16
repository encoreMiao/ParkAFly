//
//  CommetHeaderCollectionReusableView.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommetHeaderHandler) (NSInteger score);


typedef NS_ENUM(NSInteger, CommetHeaderCollectionReusableViewType){
    CommetHeaderCollectionReusableViewTypeComment,
    CommetHeaderCollectionReusableViewTypeCheck,
    CommetHeaderCollectionReusableViewTypePay,
};

@interface CommetHeaderCollectionReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (assign, nonatomic) CommetHeaderCollectionReusableViewType type;
@property (copy, nonatomic) CommetHeaderHandler handler;

@property (strong, nonatomic) NSDictionary  *orderDic;
@property (strong, nonatomic) NSString      *score;
@end
