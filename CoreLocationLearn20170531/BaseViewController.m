//
//  BaseViewController.m
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/1.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.consleStr = [[NSMutableString alloc] init];
    
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:(CGRect){0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*0.5-32}];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    return _mapView;
}

- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:(CGRect){0, CGRectGetHeight(self.view.frame)*0.5-32, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*0.5-32}];
    }
    return _textView;
}

- (void)dealloc {
    
    [self.mapView removeFromSuperview];
    
    [self.manager stopUpdatingHeading];
    [self.manager stopUpdatingLocation];
    [self.manager stopMonitoringVisits];
    [self.manager stopMonitoringSignificantLocationChanges];

    self.mapView = nil;
    self.manager = nil;
}

@end
