//
//  GeocodeDemoViewController.m
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/2.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import "GeocodeDemoViewController.h"

@interface GeocodeDemoViewController ()

@property (nonatomic, strong) UITextField *placeText;
@property (nonatomic, strong) UITextField *coordinateText1;
@property (nonatomic, strong) UITextField *coordinateText2;
@property (nonatomic, strong) NSMutableString *consleStr;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation GeocodeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.placeText = [[UITextField alloc] initWithFrame:(CGRect){10, 10, self.view.frame.size.width-20, 50}];
    self.placeText.placeholder = @"地址名称";
    self.placeText.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.placeText];
    
    self.coordinateText1 = [[UITextField alloc] initWithFrame:(CGRect){10, 70, self.view.frame.size.width-20, 50}];
    self.coordinateText1.placeholder = @"维度,精度1";
    self.coordinateText1.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.coordinateText1];
    
    self.coordinateText2 = [[UITextField alloc] initWithFrame:(CGRect){10, 130, self.view.frame.size.width-20, 50}];
    self.coordinateText2.placeholder = @"维度,经度2";
    self.coordinateText2.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:self.coordinateText2];
    
    UIButton *covert1 = [[UIButton alloc] initWithFrame:(CGRect){10, 190, 100, 40}];
    [covert1 setTitle:@"编码" forState:UIControlStateNormal];
    [covert1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [covert1 addTarget:self action:@selector(clickGeocoder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:covert1];
    
    UIButton *covert2 = [[UIButton alloc] initWithFrame:(CGRect){120, 190, 100, 40}];
    [covert2 setTitle:@"反编码1" forState:UIControlStateNormal];
    [covert2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [covert2 addTarget:self action:@selector(clickRevGeocoder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:covert2];
    
    UIButton *covert3 = [[UIButton alloc] initWithFrame:(CGRect){230, 190, 100, 40}];
    [covert3 setTitle:@"距离(1和2)" forState:UIControlStateNormal];
    [covert3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [covert3 addTarget:self action:@selector(clickDistance) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:covert3];
    
    self.consleStr = [NSMutableString string];
    
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickGeocoder {
    if (self.placeText.text.length) {
        [self geocodePlaceName:self.placeText.text];
    }
}

- (void)clickRevGeocoder {
    
    NSArray *textArray = [self.coordinateText1.text componentsSeparatedByString:@","];
    
    if (textArray.count >= 2) {
        CGFloat latitude = [textArray[0] doubleValue];
        CGFloat longtitude = [textArray[1] doubleValue];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longtitude];
        [self revGeocodeCLLocation:location];
    }
}

- (void)clickDistance {
    
    NSArray *textArray1 = [self.coordinateText1.text componentsSeparatedByString:@","];
    NSArray *textArray2 = [self.coordinateText2.text componentsSeparatedByString:@","];
    
    
    if (textArray1.count >= 2 && textArray2.count >= 2) {
        CGFloat latitude1     = [textArray1[0] doubleValue];
        CGFloat longtitude1   = [textArray1[1] doubleValue];
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longtitude1];
        
        CGFloat latitude2     = [textArray2[0] doubleValue];
        CGFloat longtitude2   = [textArray2[1] doubleValue];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longtitude2];
        
        CLLocationDistance distance = [self countDistanceFrom:location1 to:location2];
        
        [self.consleStr appendFormat:@"距离: %lf\n", distance];
        self.textView.text = self.consleStr;
        NSLog(@"距离: %lf", distance);
    }
}

- (void)geocodePlaceName:(NSString *)placeName {
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];

//    //  范围限制
//    CLLocationDistance dist = self.searchRadiusSlider.value; // 50,000m (50km)
//    CLLocationCoordinate2D point = _selectedCoordinate;
//    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:point radius:dist identifier:@"Hint Region"];

    [geoCoder geocodeAddressString:placeName inRegion:nil completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *place = placemarks.firstObject;
        
        NSLog(@"%@", place.name);
        NSLog(@"%@", place.thoroughfare);
        NSLog(@"%@", place.subThoroughfare);
        NSLog(@"%@", place.locality);
        NSLog(@"%@", place.subLocality);
        NSLog(@"%@", place.administrativeArea);
        NSLog(@"%@", place.subAdministrativeArea);
        NSLog(@"%@", place.postalCode);
        NSLog(@"%@", place.ISOcountryCode);
        NSLog(@"%@", place.country);
        NSLog(@"%@", place.inlandWater);
        NSLog(@"%@", place.ocean);
        NSLog(@"%@", place.areasOfInterest);
        
        [self.consleStr appendFormat:@"地理编码 -> 结果:%@ \n\t错误:%@\n", placemarks, error];
        self.textView.text = self.consleStr;
        NSLog(@"地理编码 -> 结果:%@ \n\t错误:%@\n", placemarks, error);
    }];
}

- (void)revGeocodeCLLocation:(CLLocation *)location {
    
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"zh-hans"] forKey:@"AppleLanguages"];
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [self.consleStr appendFormat:@"反地理编码 -> 结果:%@ \n\t错误:%@\n", placemarks, error];
        self.textView.text = self.consleStr;
        NSLog(@"反地理编码 -> 结果:%@ \n\t错误:%@\n", placemarks, error);
    }];
    
    // 还原Device 的语言
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
    });
}

- (CLLocationDistance)countDistanceFrom:(CLLocation *)fromLocation to:(CLLocation *)toLocation {
    
    CLLocationDistance distance = [fromLocation distanceFromLocation:toLocation];
    return distance;
}

- (UITextView *)textView {
    
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:(CGRect){0, CGRectGetHeight(self.view.frame)*0.5-32, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*0.5-32}];
    }
    return _textView;
}

@end
