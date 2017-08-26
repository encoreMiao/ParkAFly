//
//  CommentFooterCollectionReusableView.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CommentFooterCollectionReusableView.h"
#import "UIImage+Color.h"

@interface CommentFooterCollectionReusableView ()<UITextViewDelegate>
@property (nonatomic,strong)  GCPlaceholderTextView *fTextView;
@end

@implementation CommentFooterCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _fTextView = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(20,30 ,screenWidth-40,120)];
        _fTextView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
        _fTextView.delegate = self;
        _fTextView.font = [UIFont systemFontOfSize:14.0f];
        _fTextView.placeholder = @"请输入您本次泊车过程中的感受或意见，可以为其他泊友参考...";
        _fTextView.placeholderColor = [UIColor colorWithHex:0xb0b0b0];
        [self addSubview:_fTextView];
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [commentBtn setTitle:@"发表评价" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];//88 92 100
        [commentBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0x3492e9]] forState:UIControlStateNormal];
        [commentBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0x3492e0]] forState:UIControlStateHighlighted];
        commentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [commentBtn setBackgroundColor:[UIColor clearColor]];
        commentBtn.layer.cornerRadius = 3.0f;
        [commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        commentBtn.frame = CGRectMake(20, CGRectGetMaxY(self.fTextView.frame)+30, screenWidth-40, 40);
        commentBtn.clipsToBounds = YES;
        commentBtn.layer.cornerRadius = 3.0f;
        [self addSubview:commentBtn];
    }
    return self;
}

- (void)commentAction:(UIButton *)btn
{
    NSLog(@"发表评价");
    if (self.handler) {
        if (self.fTextView.text.length>0) {
            self.handler(self.fTextView.text);
        }else{
            self.handler(nil);
        }
        
    }
}
@end
