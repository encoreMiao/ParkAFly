//
//  PersonalCenterTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/20.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalCenterTableViewCell.h"

@interface PersonalCenterTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImg;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

@property (assign, nonatomic) PersonalCenterCellType type;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomeLine;
@end

@implementation PersonalCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setPersonalCellType:(PersonalCenterCellType)type
{
    _type = type;
    if (_type == kPersonalCenterCellTypePersonalAccount) {
        self.cellSubTitle.hidden = NO;
    }
    else{
        self.cellSubTitle.hidden = YES;
    }
    
    if (_type == kPersonalCenterCellTypeOrder) {
        self.bottomeLine.hidden = NO;
        self.topLine.hidden = NO;
    }
    else{
        self.bottomeLine.hidden = YES;
        self.topLine.hidden = YES;
    }
}

- (void)setPersonalCenterCellWithDic:(NSDictionary *)dic
{
    [self.cellImg setImage:[UIImage imageNamed:[dic objectForKey:PersonalCellImgString]]];
    [self.cellTitle setText:[dic objectForKey:PersonalcellTitleString]];
    [self setPersonalCellType:(PersonalCenterCellType)([[dic objectForKey:PersonalCellType]intValue])];
}

@end
