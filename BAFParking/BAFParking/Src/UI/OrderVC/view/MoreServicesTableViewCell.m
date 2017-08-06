//
//  MoreServicesTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/6/13.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "MoreServicesTableViewCell.h"
#import "UIImage+Color.h"
#import "BAFOrderServiceViewController.h"

@interface MoreServicesTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *serviceIcon;
@property (weak, nonatomic) IBOutlet UILabel *serviceTitle;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNotitionLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (weak, nonatomic) IBOutlet UIView *gastypeview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notificationTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *fuelLabel;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@end

@implementation MoreServicesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.buttonArr = [NSMutableArray array];
    
    [self.clickButton setImage:[UIImage imageNamed:@"list_chb2_item"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setServiceInfo:(BAFParkServiceInfo *)serviceInfo andDescription:(NSString *)description
{
    _serviceInfo = serviceInfo;
    self.serviceTitle.text = serviceInfo.title;
    self.serviceNotitionLabel.text = description;
    self.couponLabel.text = [NSString stringWithFormat:@"%ld元",serviceInfo.strike_price.integerValue/100];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.type) {
        case kMoreServicesTableViewCellType204:
            self.gastypeview.hidden = NO;
        {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults];
            NSArray *arr = [self.serviceInfo.remark componentsSeparatedByString:@","];
            for (int i = 0;i<arr.count;i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.layer.borderWidth = 1.f;
                btn.layer.cornerRadius = 3.0f;
                btn.layer.borderColor = [[UIColor colorWithHex:0x3492e9] CGColor];
                [btn.layer masksToBounds];
                btn.frame = CGRectMake(CGRectGetMaxX(self.fuelLabel.frame)+60*i+15*i, CGRectGetMinY(self.fuelLabel.frame)+5, 60, 56/2);
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                [btn setTitle:arr[i] forState:UIControlStateNormal];
                [self setFuelBtn:btn selected:NO];
                [self.gastypeview addSubview:btn];
                btn.tag = i;
                if ([dic objectForKey:OrderParamTypePetrol]) {
                    if ([[dic objectForKey:OrderParamTypePetrol] isEqualToString:arr[i]]) {
                        [self setFuelBtn:btn selected:YES];
                    }
                }
                [btn addTarget:self action:@selector(fuelbtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.buttonArr addObject:btn];
            }
            self.serviceIcon.image = [UIImage imageNamed:@"list_item_jiay"];
        }
            break;
        case KMoreServicesTableViewCellType205:
            self.gastypeview.hidden = YES;
            self.notificationTopConstraint.constant -=30;
            self.serviceIcon.image = [UIImage imageNamed:@"list_item_xic"];
            break;
        default:
            break;
    }
}

- (void)setShow:(BOOL)show
{
    _show = show;
    if (_show) {
        [self.clickButton setImage:[UIImage imageNamed:@"list_chb_item"] forState:UIControlStateNormal];
    }
    else{
        [self.clickButton setImage:[UIImage imageNamed:@"list_chb2_item"] forState:UIControlStateNormal];
        for (int i = 0; i<_buttonArr.count; i++) {
            UIButton *btntemp = (UIButton *)_buttonArr[i];
            btntemp.selected = NO;
            
        }
        self.fuelStr = nil;
    }
}

- (IBAction)checkButtonClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(moreServiceTableViewCellAction:)]) {
        [self.delegate moreServiceTableViewCellAction:self];
    }
}

- (void)fuelbtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    for (int i = 0; i<_buttonArr.count; i++) {
        UIButton *btntemp = (UIButton *)_buttonArr[i];
        [self setFuelBtn:btntemp selected:NO];
    }
    [self setFuelBtn:btn selected:YES];
    self.fuelStr = btn.titleLabel.text;
    self.show = YES;
    
    if ([self.delegate respondsToSelector:@selector(fuelSelectedAction:)]) {
        [self.delegate fuelSelectedAction:self];
    }

}

- (void)setFuelBtn:(UIButton *)btn selected:(BOOL)selected
{
    if (selected) {
        btn.layer.borderWidth = 0;
        [btn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHex:0x3492e9]];
    }else{
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
        [btn setTitleColor:[UIColor colorWithHex:0x323232] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithHex:0xffffff]];
    }
}
@end
