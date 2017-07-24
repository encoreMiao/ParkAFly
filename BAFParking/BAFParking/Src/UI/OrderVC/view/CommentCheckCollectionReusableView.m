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
        [self setupView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setOrderDic:(NSDictionary *)orderDic
{
    _orderDic = orderDic;
    
    
    if ([_orderDic objectForKey:@"remark"]&&![[_orderDic objectForKey:@"remark"] isEqual:[NSNull null]]) {
        self.commentLabel.text = [_orderDic objectForKey:@"remark"];
        
        CGSize titleSize = [self.commentLabel.text boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                            //                                                         ,NSParagraphStyleAttributeName:paragraphStyle}
                                             context:nil].size;
        self.commentLabel.frame = CGRectMake(20, 30, screenWidth-40,titleSize.height);
    }
    
    if ([_orderDic objectForKey:@"reply"]&&![[_orderDic objectForKey:@"reply"] isEqual:[NSNull null]]) {
        self.backCommentLabel.text = [_orderDic objectForKey:@"reply"];
        CGSize titleSize = [self.backCommentLabel.text boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                            //                                                         ,NSParagraphStyleAttributeName:paragraphStyle}
                                                                context:nil].size;
        self.backCommentLabel.frame = CGRectMake(20, CGRectGetMaxY(self.commentLabel.frame)+20, screenWidth-40,titleSize.height);
        
    }
}

- (void)setupView
{
    [self addSubview:self.commentLabel];
    [self addSubview:self.backCommentLabel];
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc]init];
        _commentLabel.textColor = [UIColor colorWithHex:0x323232];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _commentLabel;
}

- (UILabel *)backCommentLabel
{
    if (!_backCommentLabel) {
        _backCommentLabel = [[UILabel alloc]init];
        _backCommentLabel.textColor = [UIColor colorWithHex:0x323232];
        _backCommentLabel.backgroundColor = [UIColor clearColor];
        _backCommentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _backCommentLabel;
}

@end
