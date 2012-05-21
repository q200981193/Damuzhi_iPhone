//
//  ResendManager.h
//  Travel
//
//  Created by haodong qiu on 12年5月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RESEND_FAVORITE     @"RESEND_FAVORITE"

#define FAVORITE_LONGITUDE_KEY     @"FAVORITE_LONGITUDE_KEY"
#define FAVORITE_LATITUDE_KEY      @"FAVORITE_LATITUDE_KEY"
#define FAVORITE_TYPE_KEY          @"FAVORITE_TYPE"

enum favoriteType
{
    AddFavorite = 0,
    RemoveFavorite = 1
};

@interface ResendManager : NSObject

+ (ResendManager *)defaultManager;

- (void)addPlaceToResendFavoriteLists:(int32_t)placeId 
                            longitude:(Float64)longitude 
                             latitude:(Float64)latitude 
                                 type:(int)addOrRemove;

- (void)removePlaceFromResendFavoriteLists:(NSString *)placeId;

- (NSMutableDictionary *)allFavorite;

@end
