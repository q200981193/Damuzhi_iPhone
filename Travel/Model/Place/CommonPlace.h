//
//  CommonPlace.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    PLACE_TYPE_SPOT = 1,
    PLACE_TYPE_HOTEL = 2
};

enum{
    SORT_BY_RECOMMEND = 1,
    SORT_BY_DESTANCE_FROM_NEAR_TO_FAR = 2,
    SORT_BY_DESTANCE_FROM_FAR_TO_NEAR = 3,
    SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP = 4,
    SORT_BY_STARTS = 5
};

enum{
    SELECT_ALL_PRICE = 0,
};

@interface CommonPlace : NSObject



@end
