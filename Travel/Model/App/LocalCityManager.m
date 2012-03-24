//
//  LocalCityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LocalCityManager.h"
#import "LocalCity.h"

@implementation LocalCityManager

@synthesize localCities;

- (void)dealloc
{
    [localCities release];
    [super dealloc];
}

- (void)loadLocalCities
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* data = [userDefault objectForKey:KEY_LOCAL_CITY];
    
//    self.localCities = 
}

- (LocalCity*)findLocalCity:(int)cityId
{
    
    return nil;
}

- (void)createOrUpdateLocalCity:(int)cityId downloadProgress:(float)downloadProgress downloadFlag:(int)downloadFlag
{
    LocalCity *localCity = [self.localCities objectForKey:[NSNumber numberWithInt:cityId]];
    if (localCity == nil) {
        //TODO: create a localcity
        localCity = [LocalCity localCityWith:cityId downloadProgress:downloadProgress downloadFlag:downloadFlag];
        [self.localCities setObject:localCity forKey:[NSNumber numberWithInt:cityId]];
            }
    else {
        //TODO: update a localcity
        localCity.downloadProgress = downloadProgress;
        localCity.downloadFlag = localCity.downloadFlag;
    }
    
    return;
}

- (void)saveLocalCity:(LocalCity*)city
{
    NSNumber *cityId = [NSNumber numberWithInt:city.cityId];
    
    if ([self.localCities objectForKey:cityId] == nil) {
        //TODO: add city to localcities
        
    }
    
}


@end
