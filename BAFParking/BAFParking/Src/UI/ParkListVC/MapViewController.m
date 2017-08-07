//
//  MapViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/8/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "MapViewController.h"
#import "UIImageView+WebCache.h"

@interface MapViewController ()<BMKMapViewDelegate>
{
    BMKPointAnnotation* pointAnnotation;
}
@property (nonatomic, strong) BMKMapView* mapView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *bottomeTitleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *bottomButton;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.view = self.mapView;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.imageView];
    [self.bottomView addSubview:self.bottomeTitleLabel];
    [self.bottomView addSubview:self.detailLabel];
    [self.view addSubview:self.bottomButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationTitle:@"车场位置示意图"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
     _mapView.delegate = self;
    
    [_mapView setZoomLevel:20];
    [self addPointAnnotation];
    
    self.bottomeTitleLabel.text = _titleStr;
    self.detailLabel.text = _detailStr;
    NSString *urlStr = [NSString stringWithFormat:@"Uploads/Picture/%@",self.imageStr];
    NSString *totalUrl = REQURL(urlStr);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:totalUrl] placeholderImage:[UIImage imageNamed:@"parking_loading_img"]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     _mapView.delegate = nil;
}

- (void)backMethod:(id)sender
{
    [self.navigationController  popViewControllerAnimated:YES];
}

//添加标注
- (void)addPointAnnotation
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        pointAnnotation.coordinate = self.coor;
        pointAnnotation.title = self.pointStr;
//        pointAnnotation.subtitle = @"此Annotation可拖拽!";
    }
    [_mapView addAnnotation:pointAnnotation];
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
            [_mapView setCenterCoordinate:annotationView.annotation.coordinate animated:YES];
        }
        return annotationView;
    }
    return nil;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.frame = CGRectMake(20,screenHeight-100-64-86, screenWidth-40, 86);
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.borderColor = [[UIColor colorWithHex:0xc9c9c9] CGColor];
    }
    return _bottomView;
}

- (UIButton *)bottomButton
{
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomButton.backgroundColor = [UIColor colorWithHex:0x3492e9];
        _bottomButton.frame = CGRectMake(20, screenHeight-50-64-40, screenWidth-40, 40);
        [_bottomButton setTitle:@"开始导航" forState:UIControlStateNormal];
    }
    return _bottomButton;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.frame = CGRectMake(12, 12, 62*1.5, 62);
    }
    return _imageView;
}

- (UILabel *)bottomeTitleLabel
{
    if (!_bottomeTitleLabel) {
        _bottomeTitleLabel = [[UILabel alloc]init];
        _bottomeTitleLabel.frame = CGRectMake(62*1.5+12+12,12, self.bottomView.frame.size.width-94, 20);
        _bottomeTitleLabel.font = [UIFont systemFontOfSize:16];
        _bottomeTitleLabel.textColor = [UIColor colorWithHex:0x323232];
    }
    return _bottomeTitleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.frame = CGRectMake(62*1.5+12+12,32, self.bottomView.frame.size.width-94, 44);
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines = 0;
        _detailLabel.textColor = [UIColor colorWithHex:0x969696];
    }
    return _detailLabel;
}

@end
