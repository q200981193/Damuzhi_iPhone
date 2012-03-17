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
    // TODO: copy app data to document dir
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
    self.app = appData;    
    [[appData data] writeToFile:APP_DATA_PATH atomically:YES];
}

-(PlaceMeta*)findPlaceMeta:(int32_t)categoryId
{
    NSArray *placeMetas = self.app.placeMetaDataListList;
    PlaceMeta * placeMetafound = nil;
    for(PlaceMeta* placeMeta in placeMetas){
        if (categoryId == placeMeta.categoryId) {
            placeMetafound = placeMeta;
            break;
        }
    }
    
    return placeMetafound;
}


-(NameIdPair*)findSubCategory:(int32_t)subCategoryId placeMeta:(PlaceMeta*)placeMeta
{
    NSArray* subCategorys = placeMeta.subCategoryListList;
    for(NameIdPair* subCategory in subCategorys) {
        if (subCategory.id == subCategoryId) {
            return subCategory;
        }
    }
    
    return nil;
}

-(NameIdPair*)findProvidedService:(int32_t)subCategoryId placeMeta:(PlaceMeta*)placeMeta
{
    NSArray* providedServices = placeMeta.providedServiceListList;
    for(NameIdPair* providedService in providedServices) {
        if (providedService.id == subCategoryId) {
            return providedService;
        }
    }
    
    return nil;
}

- (NSArray*)getSubCategories:(int32_t)categoryId
{
    PlaceMeta *placeMeta = [self findPlaceMeta:categoryId];
    if (placeMeta == nil) {
        return nil;
    }
    
    return[placeMeta subCategoryListList];
}

- (NSString*)getSubCategoryName:(int32_t)categoryId subCategoryId:(int32_t)subCategoryId
{
    PlaceMeta *placeMeta = [self findPlaceMeta:categoryId];
    if (placeMeta == nil) {
        return @"";
    }

    NameIdPair *subCateGoryPair = [self findSubCategory:subCategoryId placeMeta:placeMeta];
    if(subCateGoryPair == nil){
        return @"";
    }
    
    PPDebug(@"subCategory name = %@", subCateGoryPair.name);
    
    return subCateGoryPair.name;
}


- (NSString*)getServiceImage:(int32_t)categoryId providedServiceId:(int32_t)providedServiceId
{
    return [FileUtil getFileFullPath:[NSString stringWithFormat:@"/%@/%@", IMAGE_DIR_OF_PROVIDED_SERVICE, [NSString stringWithFormat:@"%d.png", providedServiceId]]];
}

- (NSArray*)getCityList
{
    NSArray *cityList = self.app.cityListList;
       
    return cityList;
}

- (NSString*)getAppVersion
{
    return self.app.dataVersion;
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

- (NSArray*)buildSpotSortOptions
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

- (NSArray*)getSortOptions:(int32_t)categoryId
{
    NSArray *array = nil;
    switch (categoryId) {
        case PLACE_TYPE_SPOT:            
            array = [self buildSpotSortOptions];
            break;
            
        case PLACE_TYPE_HOTEL:
            break;
            
        default:
            break;
    }
    
    return array;
}



@end
