//
//  CommonPlace.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    SORT_BY_RECOMMEND = 1,
    SORT_BY_DESTANCE_FROM_NEAR_TO_FAR = 2,
    SORT_BY_DESTANCE_FROM_FAR_TO_NEAR = 3,
    SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP = 4,
    SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE = 5,
    SORT_BY_HOTEL_STARTS = 6
};

@interface CommonPlace : NSObject

@end
