//
//  PersonalEditTableViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonalEditTableViewCellType)
{
    PersonalEditTableViewCellTypeEditHead,
    PersonalEditTableViewCellTypeSelect,
    PersonalEditTableViewCellTypeEdit,
};

@interface PersonalEditTableViewCell : UITableViewCell
- (void)setTitle:(NSString *)title detail:(NSString *)detail type:(PersonalEditTableViewCellType)type;
- (void)updateDetail:(NSString *)detail;
- (void)updateImage:(UIImage *)image;
@end
