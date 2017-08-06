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
#import "HRLParkInterface.h"
#import "HRLogicManager.h"
#import "BAFParkCommentInfo.h"
#import "BAFParkInfo.h"
#import "ParkCommentViewController.h"
#import "MapViewController.h"

#define ParkDetail1TableViewCellIdentifier      @"ParkDetail1TableViewCellIdentifier"
#define ParkDetail2TableViewCellIdentifier      @"ParkDetail2TableViewCellIdentifier"
#define ParkCommetnTableViewCellIdentifier      @"ParkCommetnTableViewCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex) {
    kRequestNumberIndexParkDetail,
    kRequestNumberIndexParkCommentList,//评论列表
};

@interface ParkDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *footerBtn;
@property (strong, nonatomic) NSMutableArray *parkCommentList;
//@property (strong, nonatomic) NSMutableDictionary *parkDetailDictionary;
@property (strong, nonatomic) BAFParkInfo *parkDetailInfo;
@end

@implementation ParkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.footerBtn setFrame:CGRectMake(0, 0, screenWidth, 44)];
    self.myTableView.tableFooterView = self.footerBtn;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationTitle:@"车场详情"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
    
    [self parkDetailRequestWithParkId:self.parkid];
    self.parkCommentList = [NSMutableArray array];
    self.parkDetailInfo = nil;
}

- (void)backMethod:(id)sender
{
    [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)footerCheckMoreAction:(id)sender {
    NSLog(@"查看更多");
    ParkCommentViewController *vc = [[ParkCommentViewController alloc]init];
    vc.parkid = self.parkid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 308.0f;
    }
    else if (indexPath.section == 1){
        if (self.parkDetailInfo) {
            NSString *totalStr = self.parkDetailInfo.map_task;
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, totalStr.length)];
            CGSize titleSize = [totalStr boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle}
                                                      context:nil].size;
            return titleSize.height+20+10;
        }
        return 0;
    }else if(indexPath.section == 2){
        if (self.parkCommentList[indexPath.row]) {
            BAFParkCommentInfo *commentInfo = self.parkCommentList[indexPath.row];
            NSString *totalStr = commentInfo.remark;
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, totalStr.length)];
            CGSize titleSize = CGSizeZero;
            if (totalStr&&![totalStr isEqualToString:@""]) {
                titleSize = [totalStr boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle}
                                                   context:nil].size;
            }
            
            CGFloat height = titleSize.height;
            
            if ([commentInfo.reply isEqualToString:@""]||
                commentInfo.reply == nil||
                [commentInfo.reply isEqual:[NSNull null]]) {
                
            }
            else{
                NSString *replyStr = [NSString stringWithFormat:@"泊安飞回复：\n%@",commentInfo.reply];
                CGSize replySize = [replyStr boundingRectWithSize:CGSizeMake(screenWidth-40, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSParagraphStyleAttributeName:paragraphStyle}
                                                   context:nil].size;
                height +=replySize.height+24;
            }
            
            
            if ([commentInfo.tags isEqualToString:@""] || !commentInfo.tags) {
                return height+20+85;
            }else{
                return height+20+115;
            }
        }
        return 0;
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, screenWidth-24, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textColor = [UIColor colorWithHex:0x323232];
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
        if (self.parkCommentList.count>=2) {
            return 2;
        }else{
            return self.parkCommentList.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ParkDetail1TableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkDetail1TableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkDetail1TableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.delegate = self;
        }
        cell.parkDetailInfo = self.parkDetailInfo;
        cell.parkCommentList = self.parkCommentList;
        WS(weakself);
        cell.handler = ^(void){
            MapViewController *vc = [[MapViewController alloc]init];
            vc.imageStr = weakself.parkDetailInfo.map_pic;
            vc.pointStr = weakself.parkDetailInfo.map_title;
            vc.titleStr = weakself.parkDetailInfo.map_content;
            vc.detailStr = weakself.parkDetailInfo.map_address;
            CLLocationCoordinate2D coor;
            coor.latitude = weakself.parkDetailInfo.map_lon.doubleValue;
            coor.longitude = weakself.parkDetailInfo.map_lat.doubleValue;
            vc.coor = coor;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
    }else if(indexPath.section == 1){
        ParkDetail2TableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkDetail2TableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkDetail2TableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.delegate = self;
        }
        if (self.parkDetailInfo) {
            NSString *totalStr = self.parkDetailInfo.map_task;
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:6];
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, totalStr.length)];
            cell.mapTaskLabel.attributedText = attributeStr;
        }
        return cell;
    }else{
        ParkCommetnTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkCommetnTableViewCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkCommetnTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.delegate = self;
        }
        cell.commentInfo = [self.parkCommentList objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 30;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - REQUEST
- (void)parkDetailRequestWithParkId:(NSString *)parkId
{
    id <HRLParkInterface> parkReq = [[HRLogicManager sharedInstance] getParkReqest];
    [parkReq parkMapDetailRequestWithNumberIndex:kRequestNumberIndexParkDetail delegte:self park_id:parkId];
}

- (void)parkCommentListRequestWithParkId:(NSString *)parkId
{
    id <HRLParkInterface> parkReq = [[HRLogicManager sharedInstance] getParkReqest];
    [parkReq parkMapCommentListRequestWithNumberIndex:kRequestNumberIndexParkCommentList delegte:self park_id:parkId];
}

#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexParkDetail) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.parkDetailInfo = [BAFParkInfo mj_objectWithKeyValues:[obj objectForKey:@"data"]];
            [self parkCommentListRequestWithParkId:self.parkid];
        }else{
            
        }
    }
    
    if (aRequestID == kRequestNumberIndexParkCommentList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            if (self.parkCommentList) {
                [self.parkCommentList removeAllObjects];
            }
            self.parkCommentList = [BAFParkCommentInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
            [self.myTableView reloadData];
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}


@end
