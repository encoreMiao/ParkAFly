//
//  ParkListTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/11.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Color.h"

@interface ParkListTableViewCell()
@property (nonatomic, assign) ParkListTableViewCellType type;
@property (weak, nonatomic) IBOutlet UILabel *carFeeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *parkImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *parkLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@end

@implementation ParkListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [self.selectButton setTitle:@"已选择" forState:UIControlStateSelected];
    [self.selectButton setTitleColor:[UIColor colorWithHex:kBAFCommonColor] forState:UIControlStateNormal];
    [self.selectButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateSelected];
    [self.selectButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xffffff]] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:kBAFCommonColor]] forState:UIControlStateSelected];
    self.selectButton.clipsToBounds = YES;
    self.selectButton.layer.cornerRadius = 3.0f;
    self.selectButton.layer.borderWidth = 1.0f;
    self.selectButton.layer.borderColor = ((UIColor *)[UIColor colorWithHex:kBAFCommonColor]).CGColor;
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailGesture)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCitySelected:(BOOL)selected
{
    switch (_type) {
        case kParkListTableViewCellTypeShow:
        {
            
        }
            break;
        case kParkListTableViewCellTypeSelect:
        {
            self.selectButton.selected = selected;
        }
            break;
        default:
            break;
    }
}

- (void)setParkinfo:(BAFParkInfo *)parkinfo withtype:(ParkListTableViewCellType)type
{
    _parkinfo = parkinfo;
    _type = type;
    NSString *urlStr = [NSString stringWithFormat:@"Uploads/Picture/%@",parkinfo.map_pic];
    NSString *totalUrl = REQURL(urlStr);
    [self.parkImageView sd_setImageWithURL:[NSURL URLWithString:totalUrl]];
    self.locationLabel.text = parkinfo.map_address;
    self.parkLabel.text = [NSString stringWithFormat:@"%@",parkinfo.map_title];
    NSString *carFee = [NSString stringWithFormat:@"车位费：%@",parkinfo.map_charge.strike_price];
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:carFee];
    [mutStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xfb694b],NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} range:[carFee rangeOfString:parkinfo.map_charge.strike_price]];
    self.carFeeLabel.attributedText = mutStr;
    switch (type) {
        case kParkListTableViewCellTypeShow:
        {
            [self.selectButton setTitle:@"立即预约" forState:UIControlStateNormal];
            [self.selectButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
            [self.selectButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:kBAFCommonColor]] forState:UIControlStateNormal];
            self.selectButton.clipsToBounds = YES;
            self.selectButton.layer.cornerRadius = 3.0f;
            self.selectButton.layer.borderWidth = 1.0f;
            self.selectButton.layer.borderColor = ((UIColor *)[UIColor clearColor]).CGColor;
        }
            break;
        case kParkListTableViewCellTypeSelect:
        {
            [self.selectButton setTitle:@"选择" forState:UIControlStateNormal];
            [self.selectButton setTitle:@"已选择" forState:UIControlStateSelected];
            [self.selectButton setTitleColor:[UIColor colorWithHex:kBAFCommonColor] forState:UIControlStateNormal];
            [self.selectButton setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateSelected];
            [self.selectButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xffffff]] forState:UIControlStateNormal];
            [self.selectButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:kBAFCommonColor]] forState:UIControlStateSelected];
            self.selectButton.clipsToBounds = YES;
            self.selectButton.layer.cornerRadius = 3.0f;
            self.selectButton.layer.borderWidth = 1.0f;
            self.selectButton.layer.borderColor = ((UIColor *)[UIColor colorWithHex:kBAFCommonColor]).CGColor;
        }
            break;
        default:
            break;
    }
    
}
- (IBAction)selectButtonClicked:(id)sender {
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

- (void)detailGesture{
    if ([self.delegate respondsToSelector:@selector(ParkListTableViewCellActionDelegate:actionType:)]) {
        [self.delegate ParkListTableViewCellActionDelegate:self actionType:kParkListTableViewCellActionTypeDetails];
    }
}
@end
