//
//  CommentFooterCollectionReusableView.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

typedef void (^CommetFeaderHandler) (NSString *commentRemark);

@interface CommentFooterCollectionReusableView : UICollectionReusableView
@property (nonatomic, copy) CommetFeaderHandler handler;
@end
