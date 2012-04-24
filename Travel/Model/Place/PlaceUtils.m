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


@end
