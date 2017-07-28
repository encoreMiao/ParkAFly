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
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) UIView  *bgView;
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

- (void)setCommentDic:(NSDictionary *)commentDic
{
    _commentDic = commentDic;
    
    CGFloat height = 30;
    if ([commentDic objectForKey:@"remark"]&&![[commentDic objectForKey:@"remark"] isEqual:[NSNull null]]) {
        self.commentLabel.text = [commentDic objectForKey:@"remark"];
        
        CGSize titleSize = [self.commentLabel.text boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                             context:nil].size;
        self.commentLabel.frame = CGRectMake(20, height, screenWidth-40,titleSize.height);
        height += titleSize.height+20;
    }
    self.lineView.frame = CGRectMake(0, height, screenWidth, 0.5);
    height += 0.5;
    
    if ([commentDic objectForKey:@"reply"]&&![[commentDic objectForKey:@"reply"] isEqual:[NSNull null]]) {
        NSString *str = [NSString stringWithFormat:@"泊安飞回复:\n%@",[commentDic objectForKey:@"reply"]];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
        CGSize titleSize = [self.backCommentLabel.text boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                                context:nil].size;
        self.backCommentLabel.frame = CGRectMake(20, height+20, screenWidth-40,titleSize.height);
        height += titleSize.height+20;
        
        [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:[str rangeOfString:@"泊安飞回复:"]];
        self.backCommentLabel.attributedText = mutStr;
    }
}

- (void)setupView
{
    [self addSubview:self.commentLabel];
    [self addSubview:self.lineView];
//    [self addSubview:self.bgView];
    [self addSubview:self.backCommentLabel];
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _commentLabel.textColor = [UIColor colorWithHex:0x323232];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _commentLabel;
}

- (UILabel *)backCommentLabel
{
    if (!_backCommentLabel) {
        _backCommentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _backCommentLabel.textColor = [UIColor colorWithHex:0x323232];
        _backCommentLabel.backgroundColor = [UIColor clearColor];
        _backCommentLabel.numberOfLines = 0;
        _backCommentLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _backCommentLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UILabel alloc]initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHex:0xc9c9c9];
    }
    return _lineView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UILabel alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    }
    return _bgView;
}
@end
