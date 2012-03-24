//
//  LocalCityManager.h
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "LocalCity.h"

#define  KEY_LOCAL_CITY @"KEY_LOCAL_CITY"

@interface LocalCityManager : NSObject <CommonManagerProtocol>

@property (nonatomic, retain) NSMutableDictionary *localCities;

- (LocalCity*)getLocalCity:(int)cityId;
- (void)removeLocalCity:(int)cityId;
- (LocalCity*)createLocalCity:(int)cityId;

- (void)updateLocalCity:(int)cityId downloadProgress:(float)downloadProgress;
- (void)updateLocalCity:(int)cityId downloadingFlag:(bool)downloadingFlag;
- (void)updateLocalCity:(int)cityId downloadDoneFlag:(bool)downloadDoneFlag;

@end
