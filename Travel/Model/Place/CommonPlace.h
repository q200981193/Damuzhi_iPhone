//
//  CommonPlace.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALL_SUBCATEGORY  (-1)

enum{
    PLACE_TYPE_SPOT = 1,
    PLACE_TYPE_HOTEL = 2
};

enum{
    SORT_BY_RECOMMEND = 1,
    SORT_BY_DESTANCE_FROM_NEAR_TO_FAR = 2,
    SORT_BY_DESTANCE_FROM_FAR_TO_NEAR = 3,
    SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP = 4,
    SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE = 5,
    SORT_BY_STARTS = 6
};

//enum{
//    HOTEL_SORT_BY_RECOMMEND = 1,
//    HOTEL_SORT_BY_STAR = 2,
//    HOTEL_SORT_BY_
//    HOTEL_SORT_BY_
//    HOTEL_SORT_BY_
//  
//};

enum{
    PRICE_ALL = 1,
    PRICE_BELOW_500 = 2,
    PRICE_500_1000 = 3,
    PRICE_1000_1500 = 4,
    PRICE_MORE_THAN_1500 = 5
};

#define ALL_AREA  (-1)
#define SERVICE_ALL (-1)


@interface CommonPlace : NSObject



@end
