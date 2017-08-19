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
@property (nonatomic, strong) UIView  *backgView;
@property (nonatomic, strong) UIView  *whiteView;
@property (nonatomic, strong) UIView  *topLine;
@property (nonatomic, strong) UIView  *bottomLine;
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
        NSString *str = [NSString stringWithFormat:@"评价内容:\n%@",[commentDic objectForKey:@"remark"]];
        NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [mutStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
        
        CGSize titleSize = [str boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle}
                                             context:nil].size;
        self.commentLabel.frame = CGRectMake(20, height, screenWidth-40,titleSize.height);

        [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:[str rangeOfString:@"评价内容:"]];
        self.commentLabel.attributedText = mutStr;
        height += titleSize.height+20;
    }
    self.lineView.frame = CGRectMake(0, height, screenWidth, 0.5);
    height += 0.5;
    
    self.backgView.frame = CGRectMake(0, height, screenWidth,screenHeight);
    
    if ([commentDic objectForKey:@"reply"]&&![[commentDic objectForKey:@"reply"] isEqual:[NSNull null]]) {
        
        if (![[commentDic objectForKey:@"reply"] isEqualToString:@""]) {
            NSString *str = [NSString stringWithFormat:@"泊安飞回复:\n%@",[commentDic objectForKey:@"reply"]];
            NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:str];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [mutStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            
            CGSize titleSize = [str boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle}
                                                 context:nil].size;
            self.backCommentLabel.frame = CGRectMake(20, 10, screenWidth-40,titleSize.height);
            self.whiteView.frame = CGRectMake(0, 10, screenWidth, titleSize.height+20);
            self.topLine.frame = CGRectMake(0, 0, screenWidth, 0.5);
            self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.whiteView.frame), screenWidth, 0.5);
            
            [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x3492e9],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:[str rangeOfString:@"泊安飞回复:"]];
            self.backCommentLabel.attributedText = mutStr;
        }
    }
}

- (void)setupView
{
    self.backgroundColor = [UIColor colorWithHex:0xffffff];
    [self addSubview:self.commentLabel];
    [self addSubview:self.lineView];
    [self addSubview:self.backgView];
    [self.backgView addSubview:self.whiteView];
    [self.whiteView addSubview:self.topLine];
    [self.whiteView addSubview:self.bottomLine];
    [self.whiteView addSubview:self.backCommentLabel];
//    [self.whiteView addSubview:self.backCommentLabel];
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

- (UIView *)backgView
{
    if (!_backgView) {
        _backgView = [[UIView alloc]initWithFrame:CGRectZero];
        _backgView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    }
    return _backgView;
}

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc]initWithFrame:CGRectZero];
        _whiteView.backgroundColor = [UIColor colorWithHex:0xffffff];
    }
    return _whiteView;
}


- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc]initWithFrame:CGRectZero];
        _topLine.backgroundColor = [UIColor colorWithHex:0xc9c9c9];
    }
    return _topLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = [UIColor colorWithHex:0xc9c9c9];
    }
    return _bottomLine;
}
@end
