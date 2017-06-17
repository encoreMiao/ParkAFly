//
//  RightsTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "RightsTableViewCell.h"

@interface RightsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *rightsTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightsNumber;
@property (weak, nonatomic) IBOutlet UILabel *rightsStatus;
@property (weak, nonatomic) IBOutlet UILabel *rightsUpdateTime;
@end

@implementation RightsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)useNotiAction:(id)sender {
    
}

@end
