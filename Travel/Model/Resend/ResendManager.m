//
//  ResendManager.m
//  Travel
//
//  Created by haodong qiu on 12年5月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ResendManager.h"
#import "LogUtil.h"

ResendManager *_defaultResendManager = nil;

@implementation ResendManager

+ (ResendManager *)defaultManager{
    if (_defaultResendManager == nil) {
        _defaultResendManager = [[ResendManager alloc] init];
    }
    return _defaultResendManager;
}

- (void)addPlaceToResendFavoriteLists:(int32_t)placeId 
                            longitude:(Float64)longitude 
                             latitude:(Float64)latitude 
                                 type:(int)addOrRemove
{
    NSString *placeIdString = [NSString stringWithFormat:@"%d",placeId];
    NSString *longitudeString = [NSString stringWithFormat:@"%d",longitude];
    NSString *latitudeString = [NSString stringWithFormat:@"%d",latitude];
    NSNumber *addOrRemoveNumber = [NSNumber numberWithInt:addOrRemove];
    
    NSDictionary *placeDic = [[NSDictionary alloc] initWithObjectsAndKeys:longitudeString, FAVORITE_LONGITUDE_KEY, latitudeString, FAVORITE_LATITUDE_KEY, addOrRemoveNumber, FAVORITE_TYPE_KEY, nil];
    
    //get and update
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *placeDicList = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:RESEND_FAVORITE]];
    [placeDicList setObject:placeDic forKey:placeIdString];
    [placeDic release];
    
    //save
    [userDefaults setObject:placeDicList forKey:RESEND_FAVORITE];
    [userDefaults synchronize];
}

- (void)removePlaceFromResendFavoriteLists:(NSString *)placeId
{
    //get and update
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   NSMutableDictionary *placeDicList = [NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:RESEND_FAVORITE]];
    [placeDicList removeObjectForKey:placeId];
    
    //save
    [userDefaults setObject:placeDicList forKey:RESEND_FAVORITE];
    [userDefaults synchronize];
}

- (NSMutableDictionary *)allFavorite
{
    NSMutableDictionary *list = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:RESEND_FAVORITE]];
    PPDebug(@"ResendManager allFavorite: %d",[list count]);
    
    return list;
}

@end
