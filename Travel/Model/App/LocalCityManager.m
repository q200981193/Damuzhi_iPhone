//
//  LocalCityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LocalCityManager.h"
#import "AppUtils.h"

@implementation LocalCityManager

@synthesize localCities = _localCities;

#pragma mark -
#pragma mark: default manager implementation
static LocalCityManager *_defaultManager = nil;

+ (id)defaultManager
{
    if (_defaultManager == nil) {
        _defaultManager = [[LocalCityManager alloc] init];
    }
    
    return _defaultManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.localCities = [[NSMutableDictionary alloc] init];
        [self loadLocalCities];
        for (LocalCity *localCity in [_localCities allValues]) {
            localCity.downloadingFlag = NO;
        }
    }
    
    return self;
}

- (void)dealloc
{
    [_localCities release];
    [super dealloc];
}

#pragma mark -
#pragma mark: load and save localcities
- (void)loadLocalCities
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSData* data = [userDefault objectForKey:KEY_LOCAL_CITIES];
    
    if (data != nil){
        //TODO: parase data to localcities
        self.localCities = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }    
}

- (void)save
{
    //TODO: save localcities
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.localCities];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:KEY_LOCAL_CITIES];
    [userDefaults synchronize];
}

#pragma mark -
#pragma mark: for entire localcity access
- (LocalCity*)getLocalCity:(int)cityId
{
    return [_localCities objectForKey:[NSNumber numberWithInt:cityId]];
}

- (LocalCity*)createLocalCity:(int)cityId
{
    LocalCity *localCity = [self.localCities objectForKey:[NSNumber numberWithInt:cityId]];
    if (localCity == nil) {
        //TODO: if localCity not exist, create a localCity        
        localCity = [LocalCity localCityWith:cityId];
        [self.localCities setObject:localCity forKey:[NSNumber numberWithInt:cityId]];
    }
    
    return localCity;
}

- (void)removeLocalCity:(int)cityId
{
    [self.localCities removeObjectForKey:[NSNumber numberWithInt:cityId]];
}

#pragma mark -
#pragma mark: access a localCity's property

- (void)updateLocalCity:(int)cityId downloadProgress:(float)downloadProgress
{
    LocalCity *localCity = [self.localCities objectForKey:[NSNumber numberWithInt:cityId]];
    if (localCity != nil) {
        localCity.downloadProgress = downloadProgress;
    }
    
    return;
}

- (void)updateLocalCity:(int)cityId downloadingFlag:(float)downloadingFlag
{
    LocalCity *localCity = [self.localCities objectForKey:[NSNumber numberWithInt:cityId]];
    if (localCity != nil) {
        localCity.downloadingFlag = downloadingFlag;
    }
    
    return;
}

- (void)updateLocalCity:(int)cityId downloadDoneFlag:(float)downloadDoneFlag
{
    LocalCity *localCity = [self.localCities objectForKey:[NSNumber numberWithInt:cityId]];
    if (localCity != nil) {
        localCity.downloadDoneFlag = downloadDoneFlag;
    }
    
    return;
}

@end
