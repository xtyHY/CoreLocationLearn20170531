//
//  HeadingDemoViewController.m
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/1.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import "HeadingDemoViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HeadingDemoViewController ()<CLLocationManagerDelegate>

@end

@implementation HeadingDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    [self.manager startUpdatingHeading];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollowWithHeading;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    [self.consleStr appendFormat:@"指向位置更新-->%@\n",newHeading];
    self.textView.text = self.consleStr;
    NSLog(@"指向位置更新-->%@\n",newHeading);
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
