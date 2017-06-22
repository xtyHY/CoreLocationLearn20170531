//
//  CLVisitDemoViewController.m
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/1.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import "RegionDemoViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RegionAnnotationModel.h"

@interface RegionDemoViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLCircularRegion *region;

@end

@implementation RegionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    [self.manager requestAlwaysAuthorization];
    
    //判断是否可以监听
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        
        //监听区域中心
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(+37.33233141,-122.03121860);
        
        //监听区域的半径
        CLLocationDistance distance = 300;
        
        NSLog(@"最大监听范围 %lf", self.manager.maximumRegionMonitoringDistance);
        
        //创建监听区域对象
        self.region = [[CLCircularRegion alloc] initWithCenter:coordinate radius:distance identifier:@"regionAreaMHC"];
        
        RegionAnnotationModel *annotation = [[RegionAnnotationModel alloc] initWithRegion:self.region];
        [self.mapView addAnnotation:annotation];
        
        //启动监听
        [self.manager startMonitoringForRegion:self.region];
        
        //当前定位与监听区域的状态
        [self.manager requestStateForRegion:self.region];
    } else {
        NSLog(@"监听区域不可用");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapKit Delegate
#pragma mark - 在地图上放置大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (![annotation isKindOfClass:[RegionAnnotationModel class]]) {
        return nil;
    }
    
    //这里最好是将MKAnnotation封装一下，以及需要removeOverlay的
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"annotationView"];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
    }
    
    annotationView.annotation = annotation;
    MKCircle *cicle = [MKCircle circleWithCenterCoordinate:((RegionAnnotationModel *)annotation).region.center radius:((RegionAnnotationModel *)annotation).region.radius];
    [self.mapView addOverlay:cicle];
    
    return annotationView;
}

#pragma mark - 在地图上绘制圈
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if([overlay isKindOfClass:[MKCircle class]]) {
        // Create the view for the circular overlay.
        MKCircleRenderer *circleView = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
        circleView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.15];
        return circleView;
    }
    
    return nil;
}


#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self.consleStr appendFormat:@"进入区域--> %@\n", region];
    self.textView.text = self.consleStr;
    NSLog(@"进入区域--> %@", region);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    [self.consleStr appendFormat:@"离开区域--> %@\n", region];
    self.textView.text = self.consleStr;
    NSLog(@"离开区域--> %@", region);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    [self.consleStr appendFormat:@"区域%@定位失败--> %@",region ,error];
    self.textView.text = self.consleStr;
    NSLog(@"区域%@定位失败--> %@",region ,error);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    [self.consleStr appendFormat:@"区域开始监听--> %@",region];
    self.textView.text = self.consleStr;
    NSLog(@"区域开始监听--> %@",region);
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    [self.consleStr appendFormat:@"获取选定区域%@状态--> %li",region, state];
    self.textView.text = self.consleStr;
    NSLog(@"获取选定区域%@状态--> %li",region, state);
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    
    [self.consleStr appendFormat:@"访问位置--> %@\n", visit];
    self.textView.text = self.consleStr;
    NSLog(@"访问位置--> %@", visit);
}

- (void)dealloc {
    
    [self.manager stopMonitoringForRegion:self.region];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
