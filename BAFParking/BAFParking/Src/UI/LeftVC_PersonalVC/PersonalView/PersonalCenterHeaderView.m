//
//  PersonalCenterHeaderView.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalCenterHeaderView.h"
#import "UIImageView+WebCache.h"

@interface PersonalCenterHeaderView()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *levelButton;
@end

@implementation PersonalCenterHeaderView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupView];
        self.carNumberLabel.hidden = YES;
    }
    return self;
}

- (void)setupView{
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    self.phoneNumberLabel.text = userInfo.ctel;
    self.carNumberLabel.text = userInfo.carnum;
    NSString *headerStr = [NSString stringWithFormat:@"%@%@",Server_Url, userInfo.avatar];//
    //没有的时候用/Public/Weixin/images/four/logo02.png有的时候为/Uploads/user/7296/20170504/avatar_7296611
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headerStr] placeholderImage:[UIImage imageNamed:@"leftbar_info_img"]];
    
    switch (userInfo.level_id.integerValue) {
        case 1:
            [self.levelButton setImage:[UIImage imageNamed:@"leftbar_member1_img"] forState:UIControlStateNormal];
            self.carNumberLabel.hidden = YES;
            break;
        case 2:
            [self.levelButton setImage:[UIImage imageNamed:@"leftbar_member2_img"] forState:UIControlStateNormal];
            self.carNumberLabel.hidden = YES;
            break;
        case 3:
            [self.levelButton setImage:[UIImage imageNamed:@"leftbar_member3_img"] forState:UIControlStateNormal];
            self.carNumberLabel.hidden = NO;
            break;
        default:
            break;
    }
}

//代码创建的会调用该方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self addGestureOnBGView];
    }
    DLog(@"initWithFrame");
    return self;
}

//通过xib创建的控件会调用通过该方法（没有调用init方法）
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self addGestureOnBGView];
    }
    DLog(@"initWithCoder");
    return self;
}

- (void)addGestureOnBGView
{
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerViewDidTap:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)footerViewDidTap:(UITapGestureRecognizer*)gesture
{
    if ([self.delegate respondsToSelector:@selector(PersonalCenterHeaderViewDidTapWithGesture:)]) {
        [self.delegate PersonalCenterHeaderViewDidTapWithGesture:gesture];
    }
}



@end
