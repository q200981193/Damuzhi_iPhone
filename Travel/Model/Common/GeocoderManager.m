//
//  GeocoderManager.m
//  Travel
//
//  Created by haodong qiu on 12年4月26日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "GeocoderManager.h"
#import "PPDebug.h"

@implementation GeocoderManager
@synthesize geocoder = _geocoder;

- (void)dealloc
{
    [_geocoder release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

- (void)findCityName:(CLLocation *)location delegate:(id<GeocoderManagerDelegate>)delegate
{
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        PPDebug(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            if (delegate && [delegate respondsToSelector:@selector(failFindCityName:)]) {
                [delegate failFindCityName:error];
            }
        }else {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            if (delegate && [delegate respondsToSelector:@selector(didFindCityName:)]) {
                 [delegate didFindCityName:placemark.locality];
            }
        }
    }];
}

@end
