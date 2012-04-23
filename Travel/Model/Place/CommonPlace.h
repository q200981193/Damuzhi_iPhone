//
//  CommonPlace.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALL_CATEGORY   (-1)

enum{
    SORT_BY_RECOMMEND = 1,
    SORT_BY_DESTANCE_FROM_NEAR_TO_FAR = 2,
    SORT_BY_DESTANCE_FROM_FAR_TO_NEAR = 3,
    SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP = 4,
    SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE = 5,
    SORT_BY_STARTS = 6
};

enum{
    PRICE_BELOW_500 = 1,
    PRICE_500_1000 = 2,
    PRICE_1000_1500 = 3,
    PRICE_MORE_THAN_1500 = 4
};

@interface CommonPlace : NSObject

@end
