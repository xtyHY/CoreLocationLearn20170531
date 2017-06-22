//
//  LocationBaseDemoViewController.m
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/1.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import "LocationBaseDemoViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface LocationBaseDemoViewController ()<CLLocationManagerDelegate>

@end

@implementation LocationBaseDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //判断服务是否开启
    BOOL locService = [CLLocationManager locationServicesEnabled];
    NSLog(@"定位服务是否开启: %i", locService);
    //直接判断是否有权限
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    NSLog(@"定位权限类型: %i", authStatus);
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    
    
    //配置精度
    //定位精度，精度高，使用点多，默认kCLLocationAccuracyBest
    NSLog(@"定位精度: %lf",self.manager.desiredAccuracy);
    self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    //地图上每隔多少米才更新一次，低于这个距离的定位不会回调delegate
    self.manager.distanceFilter = 200;
    
    NSLog(@"%lf %lf %lf %lf %lf %lf",kCLLocationAccuracyBestForNavigation, kCLLocationAccuracyBest,kCLLocationAccuracyNearestTenMeters, kCLLocationAccuracyHundredMeters, kCLLocationAccuracyKilometer, kCLLocationAccuracyThreeKilometers);
    
    //获取权限
//    [self.manager requestWhenInUseAuthorization];
    
    [self.manager requestAlwaysAuthorization];
    
    //进行定位
    [self.manager startUpdatingLocation];//持续请求，需要在合适的时候使用-stopUpdatingLocation停止
    [self.manager requestLocation];//请求一次定位信息,iOS 9.0以上
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定位权限变动回调
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    [self.consleStr appendFormat:@"定位权限变更-->%i\n",status];
    self.textView.text = self.consleStr;
    NSLog(@"定位权限变更-->%i",status);
}

#pragma mark - 定位获取位置回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    
    [self.consleStr appendFormat:@"回调位置数组-->%@\n",locations];
    self.textView.text = self.consleStr;
    NSLog(@"回调位置数组-->%@\n",locations);
    
    __weak typeof(self) weakSelf = self;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [weakSelf.consleStr appendFormat:@"地理反编码信息-->%@\n错误信息:%@\n",placemarks, error];
        weakSelf.textView.text = weakSelf.consleStr;
        NSLog(@"地理反编码信息-->%@\n错误信息:%@\n",placemarks, error);
    }];
}

#pragma mark - 定位失败回调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.consleStr appendFormat:@"定位失败错误信息:%@\n", error];
    self.textView.text = self.consleStr;
    NSLog(@"定位失败错误信息:%@\n", error);
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
