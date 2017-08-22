//
//  OrderDetailImageTableViewCell.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/7/9.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "OrderDetailImageTableViewCell.h"
#import "ParkCollectionViewCell.h"

#define ParkCollectionViewCellIdentifier   @"ParkCollectionViewCellIdentifier"

@interface OrderDetailImageTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, retain) UICollectionViewFlowLayout    *cardCollectionLayout;
@property (nonatomic, strong) UICollectionView              *pickImageCollectionView;
@end


@implementation OrderDetailImageTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageArr = [NSMutableArray array];
    [self setupView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
    [self.pickImageCollectionView reloadData];
}

- (void)setupView
{
    [self addSubview:self.buyCardCollectionView];
}

- (UICollectionView *)buyCardCollectionView
{
    if (!_pickImageCollectionView) {
        _pickImageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 100) collectionViewLayout:self.cardCollectionLayout];
        _pickImageCollectionView.scrollEnabled = YES;
        //_pickImageCollectionView.scr
        _pickImageCollectionView.delegate = self;
        _pickImageCollectionView.dataSource = self;
        _pickImageCollectionView.backgroundColor = [UIColor clearColor];
        [_pickImageCollectionView registerNib:[UINib nibWithNibName:@"ParkCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ParkCollectionViewCellIdentifier];
    }
    return _pickImageCollectionView;
}

- (UICollectionViewFlowLayout *)cardCollectionLayout
{
    if (!_cardCollectionLayout) {
        _cardCollectionLayout = [[UICollectionViewFlowLayout alloc] init];
        _cardCollectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cardCollectionLayout.minimumLineSpacing = 10;
        _cardCollectionLayout.minimumInteritemSpacing = 10;
        _cardCollectionLayout.itemSize = CGSizeMake(110, 82);
        _cardCollectionLayout.sectionInset = UIEdgeInsetsMake(5, 9, 5, 9);
    }
    return _cardCollectionLayout;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ParkCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ParkCollectionViewCellIdentifier forIndexPath:indexPath];
    NSDictionary *imageDic = self.imageArr[indexPath.row];
    [cell setParkImage:[imageDic objectForKey:@"name"]];
    return cell;
}
@end
