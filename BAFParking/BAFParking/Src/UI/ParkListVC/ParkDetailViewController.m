//
//  ParkDetailViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/8.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkDetailViewController.h"
#import "ParkDetail1TableViewCell.h"
#import "ParkDetail2TableViewCell.h"
#import "ParkCommetnTableViewCell.h"

#define ParkDetail1TableViewCellIdentifier      @"ParkDetail1TableViewCellIdentifier"
#define ParkDetail2TableViewCellIdentifier      @"ParkDetail2TableViewCellIdentifier"
#define ParkCommetnTableViewCellIdentifier      @"ParkCommetnTableViewCellIdentifier"

@interface ParkDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *footerBtn;
@end

@implementation ParkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.footerBtn setFrame:CGRectMake(0, 0, screenWidth, 44)];
    self.myTableView.tableFooterView = self.footerBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 308.0f;
    }
    return 308.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 30;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 30)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth-24, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor colorWithHex:0x585c64];
    if (section == 0) {
        return nil;
    }
    if (section == 1) {
        label.text = @"停车场介绍";
    }
    if (section == 2) {
        label.text = @"全部评价";
    }
    [sectionFooterView addSubview:label];
    return sectionFooterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0||section == 1) {
        return 1;
    }
    else{
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ParkDetail1TableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkDetail1TableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkDetail1TableViewCell" owner:nil options:nil] firstObject];
            //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.delegate = self;
            
        }
        return cell;
    }else if(indexPath.section == 1){
        ParkDetail2TableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkDetail2TableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkDetail2TableViewCell" owner:nil options:nil] firstObject];
            //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.delegate = self;
            
        }
        return cell;
    }else{
        ParkCommetnTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkCommetnTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkCommetnTableViewCell" owner:nil options:nil] firstObject];
            //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.delegate = self;
            
        }
        return cell;
    }
//    PersonalEditTableViewCellType type;
//    if (section == 0) {
//        if (row == 0) {
//            type = PersonalEditTableViewCellTypeEditHead;sx
//        }else if (row == 1||row == 3){
//            type = PersonalEditTableViewCellTypeEdit;
//        }else{
//            type = PersonalEditTableViewCellTypeSelect;
//        }
//        NSArray *arr = [self.identityArr objectAtIndex:row];
//        [cell setTitle:arr[0] detail:arr[1] type:type];
//    }
//    else{
//        if (row == 0||row == 2) {
//            type = PersonalEditTableViewCellTypeEdit;
//        }else{
//            type = PersonalEditTableViewCellTypeSelect;
//        }
//        NSArray *arr = [self.carArr objectAtIndex:row];
//        [cell setTitle:arr[0] detail:arr[1] type:type];
//    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (self.type == kBAFOrderViewControllerTypeOrder) {
    //        [self orderCellClickedDelegate:[tableView cellForRowAtIndexPath:indexPath]];
    //    }else if(self.type == kBAFOrderViewControllerTypeModifyAll){
    //        if (indexPath.section == 2||indexPath.section == 3 ||(indexPath.section == 0&&indexPath.row == 0)) {
    //            [self orderCellClickedDelegate:[tableView cellForRowAtIndexPath:indexPath]];
    //        }else{
    //            [self showTipsInView:self.view message:@"如需更改，请取消订单充新下单" offset:self.view.center.x+100];
    //        }
    //    }else if(self.type == kBAFOrderViewControllerTypeModifyPart){
    //        if (indexPath.section != 1&&indexPath.section != 0) {
    //            [self orderCellClickedDelegate:[tableView cellForRowAtIndexPath:indexPath]];
    //        }else{
    //            [self showTipsInView:self.view message:@"如需更改，请取消订单充新下单" offset:self.view.center.x+100];
    //        }
    //    }
}

- (IBAction)footerCheckMoreAction:(id)sender {
    NSLog(@"查看更多");
}


@end
