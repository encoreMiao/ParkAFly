//
//  PersonalEditTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalEditTableViewCell.h"

@interface PersonalEditTableViewCell()
@property (nonatomic, assign) PersonalEditTableViewCellType type;


@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIImageView *detailIV;
@end

@implementation PersonalEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setTitle:(NSString *)title detail:(NSString *)detail type:(PersonalEditTableViewCellType)type
{
    _type = type;
    switch (type) {
        case PersonalEditTableViewCellTypeEditHead:
        {
            self.phoneLabel.hidden = YES;
            self.inputTF.hidden = NO;
            self.inputTF.userInteractionEnabled = NO;
            self.headIV.hidden = NO;
            self.detailIV.hidden = YES;
        }
            break;
        case PersonalEditTableViewCellTypeSelect:
        {
            self.phoneLabel.hidden = NO;
            self.inputTF.hidden = NO;
            self.inputTF.userInteractionEnabled = NO;
            self.headIV.hidden = YES;
            self.detailIV.hidden = NO;
        }
            break;
        case PersonalEditTableViewCellTypeEdit:
        {
            self.phoneLabel.hidden = NO;
            self.inputTF.hidden = NO;
            self.inputTF.userInteractionEnabled = YES;
            self.headIV.hidden = YES;
            self.detailIV.hidden = YES;
        }
            break;
    }
    if (title) {
        self.phoneLabel.text = title;
    }
    if (detail) {
        self.inputTF.placeholder = detail;
    }
    
    
}
- (void)updateDetail:(NSString *)detail
{
    if (detail) {
        self.inputTF.text = detail;
//        if (detail isEqualToString:@"") {
//            
//        }
    }
}

- (void)updateImage:(UIImage *)image
{
    self.headIV.image = image;
}

@end
