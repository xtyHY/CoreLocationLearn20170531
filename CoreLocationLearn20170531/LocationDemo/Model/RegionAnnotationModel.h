//
//  RegionAnnotationModel.h
//  CoreLocationLearn20170531
//
//  Created by 寰宇 on 2017/6/2.
//  Copyright © 2017年 devhy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface RegionAnnotationModel : NSObject <MKAnnotation>

@property (nonatomic, strong, readonly) CLCircularRegion *region;
- (instancetype)initWithRegion:(CLCircularRegion *)region;

@end
