//
//  RegionAnnotationModel.m
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/2.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import "RegionAnnotationModel.h"

@implementation RegionAnnotationModel

- (instancetype)initWithRegion:(CLCircularRegion *)region {
    self = [super init];
    if (self) {
        _region = region;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return _region.center;
}

- (NSString *)title {
    
    return @"title";
}

- (NSString *)subtitle {
    
    return @"subTitle";
}

@end
