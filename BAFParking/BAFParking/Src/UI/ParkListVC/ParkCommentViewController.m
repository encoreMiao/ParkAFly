//
//  ParkCommentViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/31.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "ParkCommentViewController.h"
#import "BAFParkCommentInfo.h"
#import "ParkCommetnTableViewCell.h"


#define ParkCommetnTableViewCellIdentifier  @"ParkCommetnTableViewCellIdentifier"


typedef NS_ENUM(NSInteger,RequestNumberIndex) {
    kRequestNumberIndexParkDetail,
    kRequestNumberIndexParkCommentList,//评论列表
};

@interface ParkCommentViewController ()
@property (strong, nonatomic) NSMutableArray *parkCommentList;
@end

@implementation ParkCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.parkCommentList = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationTitle:@"评价详情"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
    [self parkCommentListRequestWithParkId:self.parkid];
    
}

- (void)backMethod:(id)sender
{
    [self.navigationController  popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    if ([commentInfo.tags isEqualToString:@""] || !commentInfo.tags) {
        return titleSize.height+20+85;
    }else{
        return titleSize.height+20+115;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parkCommentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParkCommetnTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ParkCommetnTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ParkCommetnTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.delegate = self;
    }
    cell.commentInfo = [self.parkCommentList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if (aRequestID == kRequestNumberIndexParkCommentList) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            if (self.parkCommentList) {
                [self.parkCommentList removeAllObjects];
            }
            self.parkCommentList = [BAFParkCommentInfo mj_objectArrayWithKeyValuesArray:[obj objectForKey:@"data"]];
            [self.commentTableView reloadData];
        }else{
            
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

@end
