//
//  GeocoderManager.h
//  Travel
//
//  Created by haodong qiu on 12年4月26日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol GeocoderManagerDelegate<NSObject>

- (void)didFindCityName:(NSString *)cityName;
- (void)failFindCityName:(NSError*)error;

@end

@interface GeocoderManager : NSObject

@property (nonatomic, retain) CLGeocoder *geocoder;

- (void)findCityName:(CLLocation *)location delegate:(id<GeocoderManagerDelegate>)oneDelegate;

@end
