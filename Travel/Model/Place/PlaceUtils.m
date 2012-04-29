//
//  PlaceUtils.m
//  Travel
//
//  Created by haodong qiu on 12年4月11日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PlaceUtils.h"
#import "LocaleUtils.h"
#import "AppManager.h"

@implementation PlaceUtils

+ (NSString*)hotelStarToString:(int32_t)hotelStar
{
    switch (hotelStar) {
        case 1:
            return NSLS(@"一星级");
            break;
        case 2:
            return NSLS(@"二星级");
            break;
        case 3:
            return NSLS(@"三星级");
            break;
        case 4:
            return NSLS(@"四星级");
            break;
        case 5:
            return NSLS(@"五星级");
            break;
            
        default:
            break;
    }
    return nil;
}

+ (NSString*)getPriceString:(Place*)place
{
    if ([place.price intValue] > 0) {
        return [NSString stringWithFormat:@"%@%@",
                [[AppManager defaultManager] getCurrencySymbol:place.cityId],
                [place price]];
    }else {
        return NSLS(@"免费");
    }
}

+ (NSString*)getDistanceString:(Place*)place currentLocation:(CLLocation*)currentLocation
{
    if (currentLocation == nil) {
        return @"";
    }
    
    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
    CLLocationDistance distance = [currentLocation distanceFromLocation:placeLocation];
    [placeLocation release];
    
    //    NSLog(@"place name = %@", place.name);
    //    NSLog(@"place latitude = %lf, place longitude ＝ %lf", place.latitude, place.longitude);
    //    NSLog(@"current location = %@", currentLocation.description);
    //    NSLog(@"distance = %lf", distance);
    
//    if (distance > 100000.0) {
//        return @"";
//    }
    if (distance >1000.0) {
        return [NSString stringWithFormat:NSLS(@"%0.1lfKM"), distance/1000.0];
    }
    else { 
        return [NSString stringWithFormat:NSLS(@"%dM"), (int)distance];
    }
}

@end
