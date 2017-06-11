//
//  ParkListTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/11.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ParkListTableViewCell()
@property (nonatomic, retain) BAFParkInfo *parkinfo;
@property (nonatomic, assign) ParkListTableViewCellType type;

@property (weak, nonatomic) IBOutlet UIImageView *parkImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *parkLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@end

@implementation ParkListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setParkinfo:(BAFParkInfo *)parkinfo withtype:(ParkListTableViewCellType)type
{
    _parkinfo = parkinfo;
    _type = type;
    [self.parkImageView sd_setImageWithURL:[NSURL URLWithString:parkinfo.map_pic]];
    self.locationLabel.text = parkinfo.map_address;
    self.parkLabel.text = [NSString stringWithFormat:@"%@\n车位费：%@",parkinfo.map_title,parkinfo.map_charge.remark];
    
    switch (type) {
        case kParkListTableViewCellTypeShow:
        {
             [self.selectButton setTitle:@"立即预约" forState:UIControlStateNormal];
        }
            break;
        case kParkListTableViewCellTypeSelect:
        {
            [self.selectButton setTitle:@"已选择" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
}
- (IBAction)selectButtonClicked:(id)sender {
    //
    switch (self.type) {
        case kParkListTableViewCellTypeSelect:
            if ([self.delegate respondsToSelector:@selector(ParkListTableViewCellActionDelegate:actionType:)]) {
                [self.delegate ParkListTableViewCellActionDelegate:self actionType:kParkListTableViewCellActionTypeSelect];
            }
            break;
        case kParkListTableViewCellTypeShow:
            if ([self.delegate respondsToSelector:@selector(ParkListTableViewCellActionDelegate:actionType:)]) {
                [self.delegate ParkListTableViewCellActionDelegate:self actionType:kParkListTableViewCellActionTypeOrder];
            }
            break;
        default:
            break;
    }
    
}
- (IBAction)locationButtonClicked:(id)sender {
    //跳转到地图页面
    if ([self.delegate respondsToSelector:@selector(ParkListTableViewCellActionDelegate:actionType:)]) {
        [self.delegate ParkListTableViewCellActionDelegate:self actionType:kParkListTableViewCellActionTypeLocation];
    }
}

@end
