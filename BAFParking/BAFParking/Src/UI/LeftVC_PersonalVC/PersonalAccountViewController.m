//
//  PersonalAccountViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/6/17.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "PersonalAccountViewController.h"
#import "BAFCenterViewController.h"
#import "WechatCollectionViewCell.h"
#import "CardRechargeCollectionViewCell.h"
#import "ChargeFooterCollectionReusableView.h"
#import "AccountDetailViewController.h"


#define WechatCollectionViewCellIdentifier        @"WechatCollectionViewCellIdentifier"
#define CardRechargeCollectionViewCellIdentifier  @"CardRechargeCollectionViewCellIdentifier"

typedef NS_ENUM(NSInteger,PersonalAccountViewControllerType)
{
    kPersonalAccountViewControllerTypeWechat,//微信充值
    kPersonalAccountViewControllerTypeCard,//卡密充值
};


@interface PersonalAccountViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *balanceTable;//账户余额
@property (weak, nonatomic) IBOutlet UIButton *cardChargeButton;
@property (weak, nonatomic) IBOutlet UIButton *wechatChargeButton;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;

@property (strong, nonatomic) UICollectionView              *mycollectionview;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layoutForWechatType;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layoutForCardType;
@property (nonatomic, assign) PersonalAccountViewControllerType type;
@end


@implementation PersonalAccountViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerView.frame = CGRectMake(0, 0, screenWidth, 170);
    [self.view addSubview:self.headerView];
    
    self.type = kPersonalAccountViewControllerTypeWechat;
    self.wechatChargeButton.selected = YES;
    self.cardChargeButton.selected = NO;
    
    self.mycollectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layoutForWechatType];
    _mycollectionview.scrollEnabled = NO;
    _mycollectionview.backgroundColor = [UIColor clearColor];
    [_mycollectionview registerNib:[UINib nibWithNibName:@"WechatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WechatCollectionViewCellIdentifier];
    [_mycollectionview registerNib:[UINib nibWithNibName:@"CardRechargeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CardRechargeCollectionViewCellIdentifier];
    self.mycollectionview.delegate = self;
    self.mycollectionview.dataSource = self;
    [self.view addSubview:self.mycollectionview];
    
    [self.mycollectionview registerNib:[UINib nibWithNibName:@"ChargeFooterCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    [self setNavigationTitle:@"账户余额"];
    [self setNavigationRightButtonWithText:@"充值明细" method:@selector(rightBtnClicked:)];
    
    self.mycollectionview.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), screenWidth, screenHeight-170);
    
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
    AccountDetailViewController  *accountDetailVC = [[AccountDetailViewController alloc]init];
    [self.navigationController pushViewController:accountDetailVC animated:YES];
}

- (IBAction)chargeAction:(id)sender {
    NSLog(@"充值");
}

- (IBAction)chargeSelectedAction:(id)sender {
    UIButton *button = (UIButton *)sender;
    if ([button.titleLabel.text isEqualToString:@"微信充值"]) {
        self.wechatChargeButton.selected = YES;
        self.cardChargeButton.selected = NO;
         [self.mycollectionview setCollectionViewLayout:self.layoutForWechatType];
        self.type = kPersonalAccountViewControllerTypeWechat;
        self.layoutForWechatType.footerReferenceSize = CGSizeMake(screenWidth, 200);
    }else{
        self.wechatChargeButton.selected = NO;
        self.cardChargeButton.selected = YES;
        [self.mycollectionview setCollectionViewLayout:self.layoutForCardType];
        self.type = kPersonalAccountViewControllerTypeCard;
        self.layoutForCardType.footerReferenceSize = CGSizeMake(screenWidth, 200);
    }
    [self.mycollectionview reloadData];
}

- (UICollectionViewFlowLayout *)layoutForCardType
{
    if (!_layoutForCardType) {
        CGFloat itemTotolWidth = screenWidth-30;
        CGFloat itemWidth = itemTotolWidth;
        CGFloat itemHeight  = 42.0f;
        _layoutForCardType = [[UICollectionViewFlowLayout alloc] init];
        _layoutForCardType.minimumLineSpacing = 15;
        _layoutForCardType.minimumInteritemSpacing = 0;
        _layoutForCardType.itemSize = CGSizeMake(itemWidth, itemHeight);
        _layoutForCardType.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _layoutForCardType;
}


- (UICollectionViewFlowLayout *)layoutForWechatType
{
    if (!_layoutForWechatType) {
        CGFloat itemTotolWidth = screenWidth-30-30;
        CGFloat itemWidth = itemTotolWidth/3.0f;
        CGFloat itemHeight  = 62.0f;
        _layoutForWechatType = [[UICollectionViewFlowLayout alloc] init];
        _layoutForWechatType.minimumLineSpacing = 18;
        _layoutForWechatType.minimumInteritemSpacing = 15;
        _layoutForWechatType.itemSize = CGSizeMake(itemWidth, itemHeight);
        _layoutForWechatType.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _layoutForWechatType;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.type == kPersonalAccountViewControllerTypeWechat) {
        return 5;
    }else{
        return 2;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == kPersonalAccountViewControllerTypeWechat) {
        WechatCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WechatCollectionViewCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.type = kWechatCollectionViewCellTypeActivity;
        }else{
            cell.type = kWechatCollectionViewCellTypeCommon;
        }
//        id item = [self itemAtIndexPath:indexPath];
//        BOOL isCollected = [self isCollectedItemAtIndexPath:indexPath];
//        self.configureCellBlock(cell, item, isCollected);
        return cell;
    }else{
        CardRechargeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CardRechargeCollectionViewCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.type = kCardRechargeCollectionViewCellTypeCardNumber;
        }else{
            cell.type = kCardRechargeCollectionViewCellTypeCode;
        }
//        id item = [self itemAtIndexPath:indexPath];
//        BOOL isCollected = [self isCollectedItemAtIndexPath:indexPath];
//        self.configureCellBlock(cell, item, isCollected);
        return cell;
    }
}

// 设置headerView和footerView的
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = [UIColor purpleColor];
        reusableView = footerview;
    }
    return reusableView;
}

#pragma mark - UICollectionViewDelegate
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    MBKStickerCollectionView *collectionV = (MBKStickerCollectionView *)collectionView;
//    //    if (collectionV.cellIndexPath.section == 0) {
//    MBKStickerItemModel *model = [(MBKCollectionDataSource *)collectionV.dataSource itemAtIndexPath:indexPath];
//    NSString *sticker = [model.imgUrl urlencode]; //贴纸图片链接
//    NSString *stickerName = [model.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//贴纸名称
//    NSString *amount = model.collectedNum;
//    BOOL own = [(MBKCollectionDataSource *)collectionV.dataSource isCollectedItemAtIndexPath:indexPath];//是否获得(true false)
//    //        NSString *h5host = @"https://integration-m.mobike.com";
//    NSString *h5host = ((configs *)[[MBKSettingStore sharedInstance]getConfigInfo]).h5BaseUrl;
//    NSString *urlStr = [NSString stringWithFormat:@"%@/app/pages/treasure_hunt_sticker/index.html?sticker=%@&stickerName=%@&amount=%@&own=%@",h5host,sticker,stickerName,amount,own?@"true":@"false"];
//    MBKWebViewController *webView = [[MBKWebViewController alloc] initWithUrlString:urlStr andTitle:nil];
//    webView.view.backgroundColor = [[UIColor colorWithHex:0x262930] colorWithAlphaComponent:1];
//    webView.myWebView.mj_h = screenHeight;
//    webView.myWebView.mj_y = -64;
//    [self pushViewControllerA:webView animated:YES];
//    //    }
//}
@end
