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
+ (CommonNetworkOutput*)querySpotList:(int)type cityId:(int)cityId lang:(int)lang;
+ (CommonNetworkOutput*)queryAppData:(int)type lang:(int)lang;

@end
