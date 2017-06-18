//
//  OrderListViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderListViewController.h"
#import "BAFCenterViewController.h"
#import "OrderListTableViewCell.h"

#define OrderListTableViewCellIdentifier   @"OrderListTableViewCellIdentifier"

@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *noneView;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (weak, nonatomic) IBOutlet UIButton *ongoingButton;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;
@property (strong, nonatomic) UIView *buttonView;
@end



@implementation OrderListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.buttonView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"我的订单"];
    
    self.ongoingButton.selected = YES;
    self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.ongoingButton.frame), screenWidth/2, 2);
    
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (IBAction)segementSelect:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"进行中"]) {
        self.ongoingButton.selected = YES;
        self.finishedButton.selected = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.buttonView.frame = CGRectMake(0,CGRectGetMaxY(self.ongoingButton.frame), screenWidth/2, 2);
        } completion:^(BOOL finished) {
            if (finished) {
            }
        }];
        
    }else{
        self.ongoingButton.selected = NO;
        self.finishedButton.selected = YES;
        [UIView animateWithDuration:0.5 animations:^{
            self.buttonView.frame = CGRectMake(screenWidth/2,CGRectGetMaxY(self.ongoingButton.frame), screenWidth/2, 2);
        } completion:^(BOOL finished) {
        }];
    }
    
}

#pragma mark - setter&getter
- (UIView *)buttonView
{
    if (!_buttonView) {
        _buttonView = [[UIView alloc] init];
        [_buttonView setBackgroundColor:[UIColor colorWithHex:0x3492e9]];
        _buttonView.userInteractionEnabled = YES;
    }
    return _buttonView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 183.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.rightsArr.count;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:OrderListTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderListTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
    }
    //    BAFParkInfo *parkinfo = ((BAFParkInfo *)[self.parkArr objectAtIndex:indexPath.row]);
    //    switch (self.type) {
    //        case kParkListViewControllerTypeShow:
    //            [cell setParkinfo:parkinfo withtype:kParkListTableViewCellTypeShow];
    //            break;
    //        case kParkListViewControllerTypeSelect:
    //            [cell setParkinfo:parkinfo withtype:kParkListTableViewCellTypeSelect];
    //            break;
    //        default:
    //            break;
    //    }
    return cell;
}


@end
