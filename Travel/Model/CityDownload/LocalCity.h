//
//  CityManager.h
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.pb.h"

#define KEY_LOCAL_CITY @"KEY_LOCAL_CITY"

#define STATUS_NONE -1

#define DOWNLOADING 1
#define DOWNLOAD_PAUSE 2
#define DOWNLOAD_SUCCEED 3
#define DOWNLOAD_FAILED 4

#define UPDATING 1
#define UPDATE_PAUSE 2
#define UPDATE_SUCCEED 3
#define UPDATE_FAILED 4

#define REQUEST_TYPE_DOWNLOAD 1
#define REQUEST_TYPE_UPDATE 2

#define KEY_LOCAL_CITY_ID @"KEY_LOCAL_CITY_ID"
#define KEY_DOWNLOAD_PROGRESS @"KEY_DOWNLOAD_PROGRESS"
#define KEY_DOWNLOADING_STATUS @"KEY_DOWNLOADING_STATUS"
#define KEY_UPDATE_STATUS @"KEY_UPDATE_STATUS"

#define KEY_REQUEST_TYPE @"KEY_REQUEST_TYPE"

@protocol LocalCityDelegate <NSObject>

@optional
- (void)didFinishDownload:(City*)city;
- (void)didFailDownload:(City*)city error:(NSError *)error;
- (void)didFinishUpdate:(City*)city;
- (void)didFailUpdate:(City*)city error:(NSError*)error;

@end

@interface LocalCity : NSObject <NSCoding>

@property (retain, nonatomic) NSObject<LocalCityDelegate> *delegate;
@property (assign, nonatomic) int cityId;
@property (assign, nonatomic) float downloadProgress;
@property (assign, nonatomic) int downloadStatus;
@property (assign, nonatomic) int updateStatus;

+ (LocalCity*)localCityWith:(int)cityId;
- (NSString*)description;

@end
