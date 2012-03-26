//
//  CityManager.h
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.pb.h"

#define KEY_LOCAL_CITY_ID @"localCityId"
#define KEY_DOWNLOAD_PROGRESS @"downloadProgress"
#define KEY_DOWNLOADING_FLAG @"downloadingFlag"
#define KEY_DOWNLOAD_DONE_FLAG @"downloadDoneFlag"


@interface LocalCity : NSObject <NSCoding>

@property (assign, nonatomic) int cityId;
@property (assign, nonatomic) float downloadProgress;
@property (assign, nonatomic) bool downloadingFlag;
@property (assign, nonatomic) bool downloadDoneFlag;

+ (LocalCity*)localCityWith:(int)cityId;
@end
