//
//  MapViewController.m
//  BAFParking
//
//  Created by 孙晓涵 on 2017/8/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface MapViewController ()<BMKMapViewDelegate>

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.view = mapView;
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
    [self setNavigationTitle:@"车场位置示意图"];
    [self setNavigationBackButtonWithImage:[UIImage imageNamed:@"list_nav_back"] method:@selector(backMethod:)];
    
     _mapView.delegate = self;
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


@end
