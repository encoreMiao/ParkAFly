//
//  ServiceConfirmTableViewCell.m
//  BAFParking
//
//  Created by mengmeng on 2017/5/29.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ServiceConfirmTableViewCell.h"
#import "BAFOrderServiceViewController.h"

@interface ServiceConfirmTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@end

@implementation ServiceConfirmTableViewCell

- (IBAction)closeBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closeBtnActionDelegate:)]) {
        [self.delegate closeBtnActionDelegate:self];
    }
}

- (IBAction)cancelButtonClicked:(id)sender {
    
}

- (void)setServiceStr:(NSString *)serviceStr
{
    _serviceStr = serviceStr;
    NSArray *arr = [serviceStr componentsSeparatedByString:@"=>"];
    self.serviceLabel.text = arr[2];
    if ([arr[0] integerValue] == 5) {
        self.serviceLabel.text = [NSString stringWithFormat:@"%@(型号-%@)",self.serviceLabel.text,[[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults] objectForKey:OrderParamTypePetrol]];
    }

    if ([serviceStr containsString:@"自行往返航站楼"]) {
        self.costLabel.text = [NSString stringWithFormat:@"-¥%ld",[arr[3] integerValue]/100];
    }else{
        self.costLabel.text = [NSString stringWithFormat:@"¥%ld",[arr[3] integerValue]/100];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
