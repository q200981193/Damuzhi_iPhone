//
//  PlaceUtils.h
//  Travel
//
//  Created by haodong qiu on 12年4月11日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.pb.h"

@interface PlaceUtils : NSObject

+ (NSString*)hotelStarToString:(int32_t)hotelStar;
+ (NSString*)getPriceString:(Place*)place;


@end
