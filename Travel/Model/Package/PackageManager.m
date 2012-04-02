//
//  PackageManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PackageManager.h"
#import "AppUtils.h"
#import "AppManager.h"

@implementation PackageManager

@synthesize packageList = _packageList;

static PackageManager *_instance = nil;

+ (id)defaultManager
{
    if (_instance == nil) {
        _instance = [[PackageManager alloc] init];
        //_instance.packageList = [_instance readAllPackages];
    }
    
    _instance.packageList = [_instance readAllPackages];
    return _instance;
}

- (void)dealloc
{
    [_packageList release];
    [super dealloc];
}

- (NSString*)getCityVersion:(int)cityId
{
    NSString *cityVersion = @"";
    for (Package *package in _packageList) {
        if (cityId == package.cityId) {
            cityVersion = package.version;
        }
    }
    
    return cityVersion;
}

- (LanguageType)getLanguageType:(int)cityId
{
    for (Package *package in _packageList) {
        if (cityId == package.cityId) {
            return package.language;
        }
    }
    
    return 0;
}

- (NSArray*)readAllPackages
{
    NSMutableArray * packageList = [[[NSMutableArray alloc] init] autorelease];
    NSArray *cityIdList = [[AppManager defaultManager] getCityIdList];
    
    //for all city, loop
    for (NSNumber *cityId in cityIdList) {
        //a city is exist when a unzip flag and the city packagefile both exist;
        if ([AppUtils hasLocalCityData:[cityId intValue]]) {
            NSString *packageFilePath = [AppUtils getPackageFilePath:[cityId intValue]];
            
//            NSLog(@"path = %@", packageFilePath);
            if ([[NSFileManager defaultManager] fileExistsAtPath:packageFilePath]) {
                NSData *packageData = [NSData dataWithContentsOfFile:packageFilePath];
                Package *package = [Package parseFromData:packageData]; 
                [packageList addObject:package];
                
            }
        }
    }
    
    return packageList;
}

- (NSArray*)getLocalCityList
{
    NSMutableArray *cityList = [[[NSMutableArray alloc] init] autorelease];
    for (Package *package in _packageList) {
        City *city = [[AppManager defaultManager] getCity:package.cityId];
        if (city != nil) {
            [cityList addObject:city];
        }
    }
    
    return cityList;
}

//- (NSArray*)getOnlineCityList
//{
//    NSMutableArray *onlineCityList = [[[NSMutableArray alloc] init] autorelease];
//    NSArray *cityList = [[AppManager defaultManager] getCityList];
//    NSArray *localCityList = [self getLocalCityList];
//    for (City *city in cityList) {
//        if (NSNotFound == [localCityList indexOfObject:city]) {
//            [onlineCityList addObject:city];
//        }
//    }
//    
//    return onlineCityList;
//}

@end
