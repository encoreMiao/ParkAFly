//
//  CommentCollectionViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CommentCollectionViewCell.h"

@implementation CommentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    self.layer.borderWidth = 1.0f;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setCommentCollectionSelected:(BOOL)commentSelected
{
    if (commentSelected) {
        self.layer.borderColor = [[UIColor colorWithHex:0x3492e9] CGColor];
    }else{
        self.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    }
}

@end
