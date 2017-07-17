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

#define CommentViewControllerCellIdentifier        @"CommentViewControllerCellIdentifier"

typedef NS_ENUM(NSInteger,RequestNumberIndex){
    kRequestNumberIndexCommentTag,
};

@interface CommentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>
@property (strong, nonatomic) UICollectionView              *mycollectionview;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layoutForComment;
@property (nonatomic, strong) NSMutableArray                *commentTagArr;

@property (nonatomic, strong) CommentFooterCollectionReusableView *commentfooterView;
@property (nonatomic ,strong) CommentCheckCollectionReusableView *commentcheckfooterView;
@property (nonatomic, strong) UIView *checkfooterView;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentTagArr = [NSMutableArray array];
    
    self.mycollectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layoutForComment];
    _mycollectionview.scrollEnabled = NO;
    _mycollectionview.backgroundColor = [UIColor clearColor];
    [_mycollectionview registerNib:[UINib nibWithNibName:@"CommentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CommentViewControllerCellIdentifier];
    self.mycollectionview.delegate = self;
    self.mycollectionview.dataSource = self;
    [self.view addSubview:self.mycollectionview];
    
    [self.mycollectionview registerNib:[UINib nibWithNibName:@"CommetHeaderCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    self.layoutForComment.headerReferenceSize = CGSizeMake(screenWidth, 180);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNavigationTitle:@"评价"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
    [self commentTagRequest];
    
    self.mycollectionview.frame = CGRectMake(0,0, screenWidth, screenHeight);
    
    if (self.type == kCommentViewControllerTypeComment) {
        self.commentfooterView = [[CommentFooterCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
        [self.mycollectionview registerClass:[CommentFooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        self.layoutForComment.footerReferenceSize = CGSizeMake(screenWidth, 220);
    }else{
        self.commentcheckfooterView = [[CommentCheckCollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220)];
        [self.mycollectionview registerClass:[CommentCheckCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        self.layoutForComment.footerReferenceSize = CGSizeMake(screenWidth, 220);
    }
}

- (void)commentAction:(UIButton *)btn
{
    NSLog(@"发表评价");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
//    if (aRequestID == kRequestNumberIndexCancelOrder) {
//        if ([obj isKindOfClass:[NSDictionary class]]) {
//            obj = (NSDictionary *)obj;
//        }
//        if ([[obj objectForKey:@"code"] integerValue]== 200) {
//            [self orderListRequestWithOrderstatus:@"1"];
//            [self showTipsInView:self.view message:@"取消成功" offset:self.view.center.x+100];
//        }else{
//            [self showTipsInView:self.view message:@"取消失败" offset:self.view.center.x+100];
//        }
//    }
}

-(void)onJobTimeout:(int)aRequestID Error:(NSString*)message
{
    [self showTipsInView:self.view message:@"网络请求失败" offset:self.view.center.x+100];
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
//    if (indexPath.row == 0) {
//        cell.type = kWechatCollectionViewCellTypeActivity;
//    }else{
//        cell.type = kWechatCollectionViewCellTypeCommon;
//    }
    //        id item = [self itemAtIndexPath:indexPath];
    //        BOOL isCollected = [self isCollectedItemAtIndexPath:indexPath];
    //        self.configureCellBlock(cell, item, isCollected);
    return cell;
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        reusableView = headerView;
    }
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        reusableView = headerView;
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
