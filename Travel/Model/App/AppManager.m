//
//  AppManager.m
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppManager.h"
#import "App.pb.h"
#import "ImageName.h"
#import "LogUtil.h"
#import "FileUtil.h"
#import "CommonPlace.h"
#import "LocaleUtils.h"

@implementation AppManager

static AppManager* _defaultAppManager = nil;
@synthesize app = _app;

+ (id)defaultManager
{
    if (_defaultAppManager == nil){
        _defaultAppManager = [[AppManager alloc] init];
    }
    return _defaultAppManager;
}

-(void)dealloc
{
    [_app release];
    [super dealloc];
}

- (void)loadAppData
{
    // TODO: check if there is a copy data for app in document dir, if yes, return;

    
    // copy app data to document dir
    PPDebug(@"Loading app data......");
    [FileUtil copyFileFromBundleToAppDir:@"app.dat" appDir:APP_DATA_PATH overwrite:NO];
    NSData *localData = [NSData dataWithContentsOfFile:[FileUtil getFileFullPath:APP_DATA_PATH]];
    if(localData != nil)
    {
        App *localApp = [App parseFromData:localData];
        self.app = localApp;
    }
}

- (void)updateAppData:(App*)appData
{
    PPDebug(@"Updating app data......");
    self.app = appData;    
    [[appData data] writeToFile:APP_DATA_PATH atomically:YES];
}

// for debug
- (void)printAppData
{
//    message App {
//        required string dataVersion = 1;                // 数据的版本，如1.0
//        repeated City cityList = 2;                     // 正式启用城市列表
//        repeated City testCityList = 3;                 // 测试实用测试列表
//        repeated PlaceMeta placeMetaDataList = 4;       // 每种地点分类的相关数据
//        optional string helpHtml = 11;                  // 帮助说明的HTML文件路径
//    }
    
    PPDebug(@"dataVersion = %@", _app.dataVersion);
    

}

- (City*)getCity:(int)cityId
{
    for (City *city in _app.cityListList) {
        if(city.cityId == cityId)
        {
            return city;
        }
    }
    
    return nil;
}

- (City*)getTestCity:(int)cityId
{
    for (City *testCity in _app.testCityListList) {
        if(testCity.cityId == cityId)
        {
            return testCity;
        }
    }
    
    return nil;
}

-(NSString*)getAppDataVersion
{
    return _app.dataVersion;
}

- (NSString*)getHelpHtml
{
    return _app.helpHtml;
}

- (NSArray*)getCityNameList
{
    NSMutableArray *cityNameList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.cityListList) {
        [cityNameList addObject:city.cityName]; 
    }
    
    return cityNameList;
}

- (NSArray*)getTestCityNameList
{
    NSMutableArray *cityNameList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.testCityListList) {
        [cityNameList addObject:city.cityName]; 
    }
    
    return cityNameList;
}

- (NSString*)getCityName:(int)cityId
{
    NSString *cityName = @"";
    for (City *city in _app.cityListList) {
        if (city.cityId == cityId) {
            cityName = cityName;
        }   
    }
    
    return cityName;
}

- (NSString*)getCityLatestVersion:(int)cityId
{
    NSString *cityName = @"";
    for (City *city in _app.testCityListList) {
        if (city.cityId == cityId) {
            cityName = cityName;
        }   
    }
    
    return cityName;
}

- (PlaceMeta*)getPlaceMeta:(int)categoryId
{
    for (PlaceMeta *placeMeta in _app.placeMetaDataListList) {
        if (placeMeta.categoryId == categoryId) {
            return placeMeta;
        }
    }
    
    return nil;
}

- (NSArray*)getSubCategoryNameList:(int)categoryId
{
    NSMutableArray *subCategoryNameList = [[[NSMutableArray alloc] init] autorelease];
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *subCategory in placeMeta.subCategoryListList) {
            [subCategoryNameList addObject:subCategory.name];
        }
    }

    return subCategoryNameList;
}

- (NSArray*)getProvidedServiceNameList:(int)categoryId
{
    NSMutableArray *providedServiceNameList = [[[NSMutableArray alloc] init] autorelease];
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedServiceName in placeMeta.subCategoryListList) {
            [providedServiceNameList addObject:providedServiceName.name];
        }
    }
    
    return providedServiceNameList;
}

- (NSArray*)getProvidedServiceIconList:(int)categoryId
{
    NSMutableArray *providedServiceIconList = [[[NSMutableArray alloc] init] autorelease];
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedServiceIcon in placeMeta.subCategoryListList) {
            [providedServiceIconList addObject:providedServiceIcon.name];
        }
    }
    
    return providedServiceIconList;
}

- (NSString*)getSubCategotyName:(int)categoryId subCategoryId:(int)subCategoryId;
{
    NSString *subCategoryName = @"";
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *subCategory in placeMeta.subCategoryListList) {
            if (subCategory.id == subCategoryId) {
                subCategoryName = subCategory.name;
            }
        }
    }
    
    return subCategoryName;
}

- (NSString*)getProvidedServiceName:(int)categoryId providedServiceId:(int)providedServiceId;
{
    NSString *providedServiceName = @"";
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedService in placeMeta.providedServiceListList) {
            if (providedService.id == providedServiceId) {
                providedServiceName = providedService.name;
            }
        }
    }
    
    return providedServiceName;
}

- (NSString*)getProvidedServiceIcon:(int)categoryId providedServiceId:(int)providedServiceId;
{
    NSString *providedServiceIcon = @"";
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedService in placeMeta.providedServiceListList) {
            if (providedService.id == providedServiceId) {
                providedServiceIcon = providedService.image;
            }
        }
    }
    
    return providedServiceIcon;
}

#define DEFAULT_CITY_ID 1   // 1 for @"香港"
#define KEY_CURRENT_CITY @"curretn_city"

- (int)getCurrentCityId
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber* city = [userDefault objectForKey:KEY_CURRENT_CITY];
    if (city == nil){
        return DEFAULT_CITY_ID;
    }
    else {
        return [city intValue];
    }
}

- (void)setCurrentCityId:(int)newCityId
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithInt:newCityId] forKey:KEY_CURRENT_CITY];
    [userDefault synchronize];
}

- (NSArray*)buildSpotSortOptionList
{
    NSMutableArray *spotSortOptions = [[NSMutableArray alloc] init];    
    [spotSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"大拇指推荐高至低") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_RECOMMEND]]];
    [spotSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"距离近至远") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR]]];
    [spotSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"门票价格高到低") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP]]];
    
    return spotSortOptions;
}

- (NSArray*)getSortOptionList:(int32_t)categoryId
{
    NSArray *array = nil;
    switch (categoryId) {
        case PLACE_TYPE_SPOT:            
            array = [self buildSpotSortOptionList];
            break;
            
        case PLACE_TYPE_HOTEL:
            break;
            
        default:
            break;
    }
    
    return array;
}

@end
