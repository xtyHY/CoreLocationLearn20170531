//
//  MHCB2BLocationManager.h
//  MHCB2BApp
//
//  Created by 寰宇 on 2017/4/20.
//  Copyright © 2017年 maihaoche. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CLError.h>
#import <CoreLocation/CLPlacemark.h>

typedef void(^MHCB2BLocatedPointBlock)(double latitude, double longitude, BOOL success, NSError *error);
typedef void(^MHCB2BLocatedPlacemarkBlock)(CLPlacemark *placeMark, BOOL success, NSError *error);

/** 位置获取方法类  */
@interface MHCB2BLocationManager : NSObject

@property (nonatomic, strong, readonly) CLPlacemark *placemark; //!<最后一次成功的定位信息,建议使用 +getCachedPlacemark:
@property (nonatomic, strong, readonly) NSDate *lastUpdateDate; //!<最后一次成功的时间


/** 定位管理单例获取 */
+ (instancetype)manager;

/**
 实时获取纬度、精度，会有多次回调，成功了也会刷新placemark和lastUpdateDate，可以考虑第一次获取到了就请调用stop

 @param pointBlock 纬度、精度回调
 */
+ (void)getGPSwithCoordinate2D:(MHCB2BLocatedPointBlock)pointBlock;

/**
 实时获取根据地理信息反编码出来的位置对象，会有多次回调，成功了也会刷新placemark和lastUpdateDate，可以考虑第一次获取到了就请调用stop

 @param placeMarkBlock 根据地理信息反编码出来的位置对象
 */
+ (void)getGPSwithPlacemark:(MHCB2BLocatedPlacemarkBlock)placemarkBlock;

/**
 【推荐】使用的方法，获取缓存的placemark，如果没有placemark会调用定位一下，

 @param placemarkBlock 获取缓存placemark回调
 */
+ (void)getCachedPlacemark:(MHCB2BLocatedPlacemarkBlock)placemarkBlock;

@end

/** 工具方法类  */
@interface MHCB2BLocationManager(Tool)

/** 根据CLPlacemark对象获取省份名称 */
+ (NSString *)provinceByPlacemark:(CLPlacemark *)placemark;

/** 根据CLPlacemark对象获取城市名称，如果城市名称空用省份名称(直辖市) */
+ (NSString *)cityByPlacemark:(CLPlacemark *)placemark;

@end
