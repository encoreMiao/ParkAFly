//
//  ServiceConfirmTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ServiceConfirmTableViewCell.h"

@interface ServiceConfirmTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation ServiceConfirmTableViewCell

- (IBAction)cancelButtonClicked:(id)sender {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
