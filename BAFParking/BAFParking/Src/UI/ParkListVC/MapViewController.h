//
//  MapViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/8/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface MapViewController : BAFBaseViewController
@property (nonatomic, assign) CLLocationCoordinate2D coor;
@property (nonatomic, strong) NSString *pointStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *detailStr;
@property (nonatomic, strong) NSString *imageStr;//parkinfo.map_pic
@end
