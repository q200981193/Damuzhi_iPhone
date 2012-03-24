//
//  CityManager.h
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "App.pb.h"

#define NO_DOWNLOAD 0;
#define DOWNLOADING 1;
#define DOWNLOAD_DONE 2;

@interface LocalCity : NSObject <NSCoding>

@property (assign, nonatomic) int cityId;
@property (assign, nonatomic) float downloadProgress;
@property (assign, nonatomic) int downloadFlag;

+ (LocalCity*)localCityWith:(int)cityId downloadProgress:(float)downloadProgress downloadFlag:(int) downloadFlag;

@end
