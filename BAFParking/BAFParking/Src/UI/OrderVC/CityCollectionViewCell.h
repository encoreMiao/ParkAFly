//
//  CityCollectionViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/8/21.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
- (void)setCityCollectionSelected:(BOOL)citySelected;
@end
