//
//  CommentViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/1.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentCollectionViewCell.h"
#import "CommetHeaderCollectionReusableView.h"
#import "HRLOrderInterface.h"
#import "HRLogicManager.h"
#import "GCPlaceholderTextView.h"
#import "UIImage+Color.h"
#import "CommentFooterCollectionReusableView.h"
#import "CommentCheckCollectionReusableView.h"
#import <IQKeyboardManager.h>

#define CommentViewControllerCellIdentifier        @"CommentViewControllerCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCommentTag,
    kRequestNumberIndexComment,
    kRequestNumberIndexViewComment,
};

@interface CommentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
@property (strong, nonatomic) UICollectionView              *mycollectionview;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layoutForComment;
@property (nonatomic, strong) NSMutableArray                *commentTagArr;

@property (nonatomic, strong) CommentFooterCollectionReusableView *commentfooterView;
@property (nonatomic ,strong) CommentCheckCollectionReusableView *commentcheckfooterView;
@property (nonatomic, strong) UIView *checkfooterView;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSMutableDictionary *commentDic;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentTagArr = [NSMutableArray array];
    self.commentDic = [NSMutableDictionary dictionary];
    
    self.mycollectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layoutForComment];
    _mycollectionview.scrollEnabled = NO;
    _mycollectionview.backgroundColor = [UIColor clearColor];
    [_mycollectionview registerNib:[UINib nibWithNibName:@"CommentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CommentViewControllerCellIdentifier];
    self.mycollectionview.delegate = self;
    self.mycollectionview.dataSource = self;
    [self.view addSubview:self.mycollectionview];
    
    [self.mycollectionview registerNib:[UINib nibWithNibName:@"CommetHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    self.layoutForComment.headerReferenceSize = CGSizeMake(screenWidth, 180);
    
    self.selectIndexPath = nil;
    self.score = 5;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.view.backgroundColor = [UIColor colorWithHex:0xffffff];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavigationTitle:@"评价"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
    
    self.mycollectionview.frame = CGRectMake(0,0, screenWidth, screenHeight);
    
    if (self.type == kCommentViewControllerTypeComment) {
        [self commentTagRequest];
        self.commentfooterView = [[CommentFooterCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
        [self.mycollectionview registerClass:[CommentFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        self.layoutForComment.footerReferenceSize = CGSizeMake(screenWidth, 220);
    }else{
        self.commentcheckfooterView = [[CommentCheckCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
        [self.mycollectionview registerClass:[CommentCheckCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        self.layoutForComment.footerReferenceSize = CGSizeMake(screenWidth, 220);
    
        [self viewCommentRequestWithOrderId:[self.orderDic objectForKey:@"id"]];
    }
}

- (void)commentAction:(NSString *)remark
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSString stringWithFormat:@"%ld",self.score] forKey:@"score"];
    [params setValue:[self.commentTagArr objectAtIndex:self.selectIndexPath.row] forKey:@"tags"];
    
    [params setValue:[self.orderDic objectForKey:@"id"] forKey:@"order_id"];
    [params setValue:[self.orderDic objectForKey:@"park_id"] forKey:@"park_id"];
    BAFUserInfo *userInfo = [[BAFUserModelManger sharedInstance] userInfo];
    [params setValue:userInfo.ctel forKey:@"contact_phone"];
    if (remark) {
        [params setValue:remark forKey:@"remark"];
    }
    [self commentRequestWithParams:params];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - request
- (void)commentTagRequest
{
    id <HRLOrderInterface> orderReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [orderReq commentListRequestWithNumberIndex:kRequestNumberIndexCommentTag delegte:self];
}

- (void)commentRequestWithParams:(NSDictionary *)params
{
    id <HRLOrderInterface> commentReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [commentReq createCommentRequestWithNumberIndex:kRequestNumberIndexComment delegte:self param:params];
}

- (void)viewCommentRequestWithOrderId:(NSString *)orderid
{
    id <HRLOrderInterface> commentReq = [[HRLogicManager sharedInstance] getOrderReqest];
    [commentReq viewCommentRequestWithNumberIndex:kRequestNumberIndexViewComment delegte:self order_id:orderid];
}
#pragma mark - REQUEST
-(void)onJobComplete:(int)aRequestID Object:(id)obj
{
    if (aRequestID == kRequestNumberIndexCommentTag) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self.commentTagArr removeAllObjects];
            self.commentTagArr = [NSMutableArray arrayWithArray:[obj objectForKey:@"data"]];
            [self.mycollectionview  reloadData];
        }
    }
    
    if (aRequestID == kRequestNumberIndexComment) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            [self showTipsInView:self.view message:@"感谢您的评价，发表成功!" offset:self.view.center.x+100];
        }else{
            [self showTipsInView:self.view message:[obj objectForKey:@"message"] offset:self.view.center.x+100];
        }
    }
    
    if (aRequestID == kRequestNumberIndexViewComment) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            obj = (NSDictionary *)obj;
        }
        if ([[obj objectForKey:@"code"] integerValue]== 200) {
            self.commentDic = [obj objectForKey:@"data"];
            [self commentTagRequest];
        }else{
            [self showTipsInView:self.view message:[obj objectForKey:@"message"] offset:self.view.center.x+100];
        }
    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
//    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.commentTagArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CommentViewControllerCellIdentifier forIndexPath:indexPath];
    cell.commentLabel.text = [self.commentTagArr objectAtIndex:indexPath.row];
    if (self.type == kCommentViewControllerTypeCommentCheck) {
        cell.userInteractionEnabled = NO;
        //查看
        NSString *tags = [self.commentDic objectForKey:@"tags"];
        if (![tags isEqual:[NSNull null]]
            &&tags.length>0
            &&[[self.commentTagArr objectAtIndex:indexPath.row]isEqualToString:tags])
        {
            [cell  setCommentCollectionSelected:YES];
        }else{
            [cell  setCommentCollectionSelected:NO];
        }
    }else if (self.type == kCommentViewControllerTypeComment){
        cell.userInteractionEnabled = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCollectionViewCell *cell = (CommentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCommentCollectionSelected:YES];
    self.selectIndexPath = indexPath;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCollectionViewCell *cell = (CommentCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setCommentCollectionSelected:NO];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        CommetHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.handler = ^(NSInteger score){
            self.score = score;
        };
        headerView.orderDic = self.orderDic;
        if (self.type == kCommentViewControllerTypeComment) {
            headerView.type = CommetHeaderCollectionReusableViewTypeComment;
        }else if (self.type == kCommentViewControllerTypeCommentCheck){
            headerView.score = [self.commentDic objectForKey:@"score"];
            headerView.type = CommetHeaderCollectionReusableViewTypeCheck;
        }
        reusableView = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter)
    {
        if (self.type == kCommentViewControllerTypeComment) {
            CommentFooterCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
            footerView.handler = ^(NSString *remark){
                [self commentAction:remark];
            };
            reusableView = footerView;
        }else{
            CommentCheckCollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
            if (self.commentDic) {
                footerView.commentDic = self.commentDic;
            }
            reusableView = footerView;
        }
        
    }
    return reusableView;
}


- (UICollectionViewFlowLayout *)layoutForComment
{
    if (!_layoutForComment) {
        CGFloat itemTotolWidth = screenWidth-20*2-22;
        CGFloat itemWidth = itemTotolWidth/2.0f;
        CGFloat itemHeight  = 31.0f;
        _layoutForComment = [[UICollectionViewFlowLayout alloc] init];
        _layoutForComment.minimumLineSpacing = 15;
        _layoutForComment.minimumInteritemSpacing = 22;
        _layoutForComment.itemSize = CGSizeMake(itemWidth, itemHeight);
        _layoutForComment.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return _layoutForComment;
}



@end
