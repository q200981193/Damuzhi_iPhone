//
//  ResendService.m
//  Travel
//
//  Created by haodong qiu on 12年5月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ResendService.h"
#import "ResendManager.h"
#import "UserManager.h"
#import "TravelNetworkRequest.h"
#import "JSON.h"
#import "LogUtil.h"

static ResendService *_defaultResendService = nil;


@interface ResendService()

- (void)resendAddFavorite:(NSString *)placeId 
                longitude:(NSString *)longitude 
                 latitude:(NSString *)latitude;

- (void)resendDeleteFavorite:(NSString *)placeId;

@end



@implementation ResendService

+ (ResendService *)defaultService
{
    if (_defaultResendService == nil){
        _defaultResendService = [[ResendService alloc] init];                
    }
    
    return _defaultResendService;
}

- (void)resendAddFavorite:(NSString *)placeId 
                longitude:(NSString *)longitude 
                 latitude:(NSString *)latitude
{
    NSString* userId = [[UserManager defaultManager] getUserId];    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        CommonNetworkOutput* output = [TravelNetworkRequest addFavoriteByUserId:userId placeId:placeId  longitude:longitude latitude:latitude];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* jsonDict = [output.textData JSONValue];
            NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
            
            if (result != nil && 0 == result.intValue){
                [[ResendManager defaultManager] removePlaceFromResendFavoriteLists:placeId];
                 PPDebug(@"<ResendService> resendAddFavorite success!");
            }else {
                PPDebug(@"<ResendService> resendAddFavorite faild, resultCode:%d, result:%d", output.resultCode, result.intValue);
            }
        });
    });
}

- (void)resendDeleteFavorite:(NSString *)placeId
{
    NSString* userId = [[UserManager defaultManager] getUserId];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        CommonNetworkOutput *output = [TravelNetworkRequest deleteFavoriteByUserId:userId placeId:placeId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary* jsonDict = [output.textData JSONValue];
            NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
            if (result != nil && 0 == result.intValue){
                [[ResendManager defaultManager] removePlaceFromResendFavoriteLists:placeId];
                PPDebug(@"<ResendService> resendDeleteFavorite success!");
            }else {
                PPDebug(@"<ResendService> resendDeleteFavorite faild, resultCode:%d, result:%d", output.resultCode, result.intValue);
            }
        });
    });
}

- (void)resendFavorite
{
    NSMutableDictionary *favoriteList = [[ResendManager defaultManager] allFavorite];
    NSArray *placeIdList = [favoriteList allKeys];
    
    for (NSString *placeId in placeIdList) {
        NSDictionary *dic = [favoriteList objectForKey:placeId];
        NSNumber *type = [dic objectForKey:FAVORITE_TYPE_KEY];
        
        if (type.intValue == AddFavorite) {
            NSString *longitude = [dic objectForKey:FAVORITE_LATITUDE_KEY];
            NSString *latitude = [dic objectForKey:FAVORITE_LATITUDE_KEY];
            [self resendAddFavorite:placeId longitude:longitude latitude:latitude];
        }
        
        else if (type.intValue == RemoveFavorite){
            [self resendDeleteFavorite:placeId];
        }
    }
}

@end
