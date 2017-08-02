//
//  MapViewController.h
//  BAFParking
//
//  Created by 孙晓涵 on 2017/8/2.
//  Copyright © 2017年 boanfei. All rights reserved.
//

#import "BAFBaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>

@interface MapViewController : BAFBaseViewController
{
    BMKMapView* _mapView;
}
@end
