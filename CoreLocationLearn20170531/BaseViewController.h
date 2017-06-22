//
//  BaseViewController.h
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/1.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableString *consleStr;
@property (nonatomic, strong) CLLocationManager *manager;

@end
