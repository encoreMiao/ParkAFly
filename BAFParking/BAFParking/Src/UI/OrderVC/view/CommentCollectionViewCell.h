//
//  CommentCollectionViewCell.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CommentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
- (void)setCommentCollectionSelected:(BOOL)commentSelected;
@end
