//
//  MHCB2BLocationManager.m
//  MHCB2BApp
//
//  Created by 寰宇 on 2017/4/20.
//  Copyright © 2017年 maihaoche. All rights reserved.
//

#import "MHCB2BLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLError.h>

@interface MHCB2BLocationManager()<CLLocationManagerDelegate>

@property (nonatomic, copy) MHCB2BLocatedPointBlock pointBlock;
@property (nonatomic, copy) MHCB2BLocatedPlacemarkBlock placemarkBlock;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL hasUpdated;//!<防止多次回调

+ (instancetype)manager;

@end

@implementation MHCB2BLocationManager

+ (instancetype)manager {
    
    static MHCB2BLocationManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[MHCB2BLocationManager alloc] init];
    });
    
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self _update];
    }
    return self;
}

#pragma mark - CLLocationManagerDelegate
#pragma mark 定位成功回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *clocation = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    NSLog(@"定位CLLocation结果:%@", locations);
    [geocoder reverseGeocodeLocation:clocation completionHandler:^(NSArray *array, NSError *error) {
        
//        if (self.hasUpdated) {
//            return;
//        }
        NSLog(@"定位Geocode结果:%@ \n %@", array, error);
        
        NSError     *locationError = nil;
        CLPlacemark *tempPlacemark = nil;
        double latitude = 0, longitude = 0;
        BOOL succuess;
        
        if (array.count > 0) {
            latitude  = clocation.coordinate.latitude; // 维度
            longitude = clocation.coordinate.longitude;// 经度

            tempPlacemark  = [array objectAtIndex:0];
            succuess = YES;
            _placemark = tempPlacemark;
            _lastUpdateDate = [NSDate date];
        } else {
            locationError = error ? : [NSError errorWithDomain:kCLErrorDomain code:kCLErrorLocationUnknown userInfo:@{NSLocalizedFailureReasonErrorKey : @"没有定位到城市"}];
            succuess = NO;
        }
        
        
        if (self.pointBlock) {
            self.pointBlock(latitude, longitude, succuess, locationError);
        }
        
        if (self.placemarkBlock) {
            self.placemarkBlock(self.placemark, succuess, locationError);
        }
        
        [self _stop];
    }];
}

#pragma mark 定位失败回调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
//    if (self.hasUpdated) {
//        return;
//    }
//    
//    self.hasUpdated = YES;
    
    NSError *errorInfo = [MHCB2BLocationManager _canLocated];
    if (errorInfo) {
        if (self.placemarkBlock) {
            self.placemarkBlock(nil, NO, error);
        }
        if (self.pointBlock) {
            self.pointBlock(0, 0, NO, error);
        }
    }
}

#pragma mark -授权校验
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status==kCLAuthorizationStatusNotDetermined) {
        NSLog(@"地理位置-等待用户授权");
    } else if (status==kCLAuthorizationStatusAuthorizedAlways ||
               status==kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"地理位置-授权成功");
    } else {
        NSLog(@"地理位置-授权失败");
        NSDictionary *dic  = [NSBundle mainBundle].infoDictionary;
        NSString *bundleName = dic[@"CFBundleName"];
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"定位失败" message:[NSString stringWithFormat:@"获取定位信息失败，请到 设置-%@-位置 允许访问位置信息", bundleName] preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [[MHCB2BUtils getCurrentViewController] presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - private
#pragma mark 更新
- (void)_update {
    self.hasUpdated = NO;
    [self _startStanderLocating];
}

#pragma mark 停止
- (void)_stop {
    self.hasUpdated = YES;
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
}

#pragma mark 判断能否定位
+ (NSError *)_canLocated {
    BOOL locationServicesEnabled = [CLLocationManager locationServicesEnabled];
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL locationAuthorization   = (status==kCLAuthorizationStatusAuthorizedAlways ||
                                    status==kCLAuthorizationStatusAuthorizedWhenInUse ||
                                    status==kCLAuthorizationStatusNotDetermined);
    
    NSString *errorMessage = nil;
    if (!locationServicesEnabled) {//定位服务没开
        return [NSError errorWithDomain:kCLErrorDomain code:kCLErrorDenied
                               userInfo:@{NSLocalizedFailureReasonErrorKey : @"获取定位信息失败，请前往设置开启定位服务"}];
    }
    
    if (!locationAuthorization) {  //定位没有授权使用
        NSDictionary *dic  = [NSBundle mainBundle].infoDictionary;
        NSString *bundleName = dic[@"CFBundleName"];
        return [NSError errorWithDomain:kCLErrorDomain code:kCLErrorRegionMonitoringDenied
                               userInfo:@{NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"获取定位信息失败，请到 设置-%@-位置 允许访问位置信息", bundleName]}];
    }
    
    return nil;
}

#pragma mark 基本定位(在程序使用期间)
- (void)_startStanderLocating {
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    //设置 精度 和 最短触发定位距离
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5;
    [self.locationManager startUpdatingLocation];
}

#pragma mark 关键位置定位(始终)
- (void)_startMonitorLocating {
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark 获取placemark是否走缓存
+ (void)_getGPSwithPlaceMark:(MHCB2BLocatedPlacemarkBlock)placemarkBlock useCached:(BOOL)useCached {
    
    CLPlacemark *cachedPlacemark = [[self manager] placemark];
    if (cachedPlacemark && useCached) {
        if (placemarkBlock) {
            placemarkBlock(cachedPlacemark, YES, nil);
        }
    } else {
        MHCB2BLocationManager *manager = [MHCB2BLocationManager manager];
        manager.placemarkBlock = placemarkBlock;
        [manager _update];
    }
}

#pragma mark - public api
+ (void)getGPSwithCoordinate2D:(MHCB2BLocatedPointBlock)pointBlock {
    MHCB2BLocationManager *manager = [MHCB2BLocationManager manager];
    manager.pointBlock = pointBlock;
    [manager _update];
}

+ (void)getGPSwithPlacemark:(MHCB2BLocatedPlacemarkBlock)placemarkBlock {
    [self _getGPSwithPlaceMark:placemarkBlock useCached:NO];
}

+ (void)getCachedPlacemark:(MHCB2BLocatedPlacemarkBlock)placemarkBlock {
    [self _getGPSwithPlaceMark:placemarkBlock useCached:YES];
}

+ (void)stop {
    [[self manager] _stop];
}

@end

@implementation MHCB2BLocationManager(Tool)

+ (NSString *)provinceByPlacemark:(CLPlacemark *)placemark {
    
    return placemark.administrativeArea;
}

+ (NSString *)cityByPlacemark:(CLPlacemark *)placemark {
    
    NSString *cityName = placemark.locality;
    if (!cityName || !cityName.length) { // 直辖市，城市名称用省名称问题
        cityName = placemark.administrativeArea;
    }
    
    return cityName;
}

@end
