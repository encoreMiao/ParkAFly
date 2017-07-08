//
//  PersonalEditViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/18.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalEditViewController.h"
#import "BAFCenterViewController.h"
#import "PersonalEditTableViewCell.h"


#define PersonalEditTableViewCellIdentifier  @"PersonalEditTableViewCellIdentifier"

@interface PersonalEditViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *identityArr;
@property (nonatomic, strong) NSMutableArray *carArr;
@end

@implementation PersonalEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.identityArr = [NSMutableArray arrayWithArray:@[@[@"头像",@"修改头像"],@[@"姓名",@"请输入姓名"],@[@"性别",@"请选择性别"],@[@"手机号码",@"请输入手机号码"],@[@"常驻城市",@"请选择常驻城市"]]];
    self.carArr = [NSMutableArray arrayWithArray:@[@[@"车牌号",@"如：京12345"],@[@"颜色",@"请选择车辆颜色"],@[@"品牌",@"请输入车辆品牌"]]];
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
    [self setNavigationTitle:@"编辑资料"];
    [self setNavigationRightButtonWithText:@"完成" method:@selector(rightBtnClicked:)];
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (void)rightBtnClicked:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFCenterViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}




#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 64.0f;
    }
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 10)];
    return sectionFooterView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    else{
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalEditTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:PersonalEditTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PersonalEditTableViewCell" owner:nil options:nil] firstObject];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
        
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    PersonalEditTableViewCellType type;
    if (section == 0) {
        if (row == 0) {
            type = PersonalEditTableViewCellTypeEditHead;
        }else if (row == 1||row == 3){
            type = PersonalEditTableViewCellTypeEdit;
        }else{
            type = PersonalEditTableViewCellTypeSelect;
        }
        NSArray *arr = [self.identityArr objectAtIndex:row];
        [cell setTitle:arr[0] detail:arr[1] type:type];
    }
    else{
        if (row == 0||row == 2) {
            type = PersonalEditTableViewCellTypeEdit;
        }else{
            type = PersonalEditTableViewCellTypeSelect;
        }
        NSArray *arr = [self.carArr objectAtIndex:row];
        [cell setTitle:arr[0] detail:arr[1] type:type];
    }
    return cell;
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


@end
