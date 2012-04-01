//
//  TravelNetworkRequest.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPNetworkRequest.h"
#import "TravelNetworkConstants.h"

typedef void (^TravelNetworkResponseBlock)(NSDictionary* jsonDictionary, NSData* data, int resultCode);

@interface TravelNetworkRequest : NSObject

+ (CommonNetworkOutput*)registerUser:(int)type token:(NSString*)deviceToken;
+ (CommonNetworkOutput*)queryList:(int)type cityId:(int)cityId lang:(int)lang;
+ (CommonNetworkOutput*)queryList:(int)type lang:(int)lang;
+ (CommonNetworkOutput*)queryObject:(int)type objId:(int)objId lang:(int)lang;
+ (CommonNetworkOutput*)addFavoriteByUserId:(NSString *)userId placeId:(NSString *)placeId longitude:(NSString *)longitude latitude:(NSString *)latitude;
+ (CommonNetworkOutput*)deleteFavoriteByUserId:(NSString *)userId placeId:(NSString *)placeId;
+ (CommonNetworkOutput*)queryVersion;

@end
