//
//  ParkCommentViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/31.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"

@interface ParkCommentViewController : BAFBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic, strong) NSString *parkid;
@end
