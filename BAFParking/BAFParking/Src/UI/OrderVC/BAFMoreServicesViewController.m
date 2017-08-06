//
//  BAFMoreServicesViewController.m
//  BAFParking
//
//  Created by mengmeng on 2017/6/13.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFMoreServicesViewController.h"
#import "BAFOrderServiceViewController.h"
#import "OrderFooterView.h"
#import "MoreServicesTableViewCell.h"
#import "BAFParkServiceInfo.h"


#define MoreServicesTableViewCellIdentifier  @"MoreServicesTableViewCellIdentifier"

@interface BAFMoreServicesViewController ()<OrderFooterViewDelegate,UITableViewDelegate, UITableViewDataSource,MoreServicesTableViewCellDelegate>
@property (nonatomic, strong) IBOutlet OrderFooterView *footerView;
@property (nonatomic, strong) IBOutlet UITableView  *mainTableView;

@property (nonatomic, strong) NSMutableDictionary *dicDatasource;
@end

@implementation BAFMoreServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.dicDatasource = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:OrderDefaults]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationTitle:@"预约停车"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
}

- (void)setupView
{
    self.footerView.delegate = self;
    self.mainTableView.tableFooterView = self.footerView;
    self.mainTableView.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
}

- (void)backMethod:(id)sender
{
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFOrderServiceViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

- (void)nextStepButtonDelegate:(id)sender
{
    if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
        NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
        NSString *str = nil;
        if ([self.more_serviceDic.allKeys containsObject:@"204"]) {
            NSDictionary *dic = [self.more_serviceDic objectForKey:@"204"];
            str = [NSString stringWithFormat:@"%@=>%@=>%@=>%@",[dic objectForKey:@"charge_id"],[dic objectForKey:@"remark"],[dic objectForKey:@"title"],[dic objectForKey:@"strike_price"]];
        }
        if (str&&[arr containsObject:str]) {
            if (![self.dicDatasource objectForKey:OrderParamTypePetrol]) {
                [self showTipsInView:self.view message:@"请选择汽油型号" offset:self.view.center.x+100];
                return;
            }
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:self.dicDatasource forKey:OrderDefaults];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[BAFOrderServiceViewController class]]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRatIndexPath:indexPath];
}

- (CGFloat)heightForRatIndexPath:(NSIndexPath *)indexpath
{
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:subTitle];
//    //    UIFont *dinFont = [UIFont fontWithName:kDefaultFontName size:14];
//    //    NSMutableAttributedString *attributeStr = [self truncateNumberAndEngInString:subTitle font:dinFont];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:3];
//    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, subTitle.length)];
//    ,NSParagraphStyleAttributeName:paragraphStyle}
//    self.memberSubLabel.attributedText = attributeStr;

    NSString *str;
    CGFloat height;
    if ([[self.more_serviceDic.allKeys objectAtIndex:indexpath.section] isEqualToString:@"204"]) {
        str = [self.service_description objectForKey:@"fuel_description"];
        height = 90.0f;
    }else{
        str = [self.service_description objectForKey:@"car_wash_description"];
        height = 60.0f;
    }
    CGSize titleSize = [str boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
//                                                         ,NSParagraphStyleAttributeName:paragraphStyle}
                                              context:nil].size;
    CGSize titleUnit = [@"hh" boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                        //                                                         ,NSParagraphStyleAttributeName:paragraphStyle}
                                         context:nil].size;

    
    return height+ (titleSize.height/titleUnit.height)*(titleUnit.height+4)+20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9.5f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHex:0xf5f5f5]];
    [sectionFooterView setFrame:CGRectMake(0, 0, screenWidth, 9.5f)];
    return sectionFooterView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.more_serviceDic.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoreServicesTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:MoreServicesTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MoreServicesTableViewCell" owner:nil options:nil] firstObject];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BAFParkServiceInfo *serviceInfo;
    serviceInfo = [BAFParkServiceInfo mj_objectWithKeyValues:[self.more_serviceDic objectForKey:[self.more_serviceDic.allKeys objectAtIndex:indexPath.section]]];
    NSString *description;
    NSString *str = [NSString stringWithFormat:@"%@=>%@=>%@=>%@",serviceInfo.charge_id,serviceInfo.remark,serviceInfo.title,serviceInfo.strike_price];
    if ([[self.more_serviceDic.allKeys objectAtIndex:indexPath.section] isEqualToString:@"204"]) {
        //代加油
        cell.type = kMoreServicesTableViewCellType204;
        description = [self.service_description objectForKey:@"fuel_description"];
        if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
            NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
            if ([arr containsObject:str]) {
                [cell setShow:YES];
            }
        }
    }else{
        cell.type = KMoreServicesTableViewCellType205;
        if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
            NSArray *arr = [[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"];
            if ([arr containsObject:str]) {
                [cell setShow:YES];
            }
        }
        description = [self.service_description objectForKey:@"car_wash_description"];
    }
    [cell setServiceInfo:serviceInfo andDescription:description];
    return cell;
}

- (void)setMore_serviceDic:(NSMutableDictionary *)more_serviceDic
{
    _more_serviceDic = [more_serviceDic copy];
    [self.mainTableView reloadData];
}

- (void)fuelSelectedAction:(MoreServicesTableViewCell *)tableviewCell
{
    if (tableviewCell.show) {
        if (tableviewCell.type == kMoreServicesTableViewCellType204) {
            [self.dicDatasource setObject:tableviewCell.fuelStr forKey:OrderParamTypePetrol];
            
            NSString *str = [NSString stringWithFormat:@"%@=>%@=>%@=>%@",tableviewCell.serviceInfo.charge_id,tableviewCell.serviceInfo.remark,tableviewCell.serviceInfo.title,tableviewCell.serviceInfo.strike_price];
            if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:[[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"]];
                if (![arr containsObject:str]) {
                    [arr addObject:str];
                }
                str = [arr componentsJoinedByString:@"&"];
                [self.dicDatasource setObject:str forKey:OrderParamTypeService];
            }else{
                [self.dicDatasource setObject:str forKey:OrderParamTypeService];
            }
        }
    }
}

- (void)moreServiceTableViewCellAction:(MoreServicesTableViewCell *)tableviewCell
{
    [tableviewCell setShow:!tableviewCell.show];
    NSString *str = [NSString stringWithFormat:@"%@=>%@=>%@=>%@",tableviewCell.serviceInfo.charge_id,tableviewCell.serviceInfo.remark,tableviewCell.serviceInfo.title,tableviewCell.serviceInfo.strike_price];
    if (tableviewCell.show) {
        if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"]];
            if (![arr containsObject:str]) {
                [arr addObject:str];
            }
            str = [arr componentsJoinedByString:@"&"];
            [self.dicDatasource setObject:str forKey:OrderParamTypeService];
        }else{
            [self.dicDatasource setObject:str forKey:OrderParamTypeService];
        }
    }
    else{
        if ([self.dicDatasource objectForKey:OrderParamTypeService]) {
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[[self.dicDatasource objectForKey:OrderParamTypeService] componentsSeparatedByString:@"&"]];
            if ([arr containsObject:str]) {
                [arr removeObject:str];
            }
            if (arr.count>0) {
                NSString *str = [arr componentsJoinedByString:@"&"];
                [self.dicDatasource setObject:str forKey:OrderParamTypeService];
            }
            else{
                [self.dicDatasource removeObjectForKey:OrderParamTypeService];
            }
        }
        if (tableviewCell.type == kMoreServicesTableViewCellType204) {
            if ([self.dicDatasource objectForKey:OrderParamTypePetrol]) {
                [self.dicDatasource removeObjectForKey:OrderParamTypePetrol];
            }
        }
    }
}
@end
