//
//  CommentCheckCollectionReusableView.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CommentCheckCollectionReusableView.h"

@interface CommentCheckCollectionReusableView()
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *backCommentLabel;
@end

@implementation CommentCheckCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end
