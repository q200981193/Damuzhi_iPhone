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

- (void)initApp:(App*)appData
{
    self.app = appData;
    PPDebug(@"dataVersion %@", _app.dataVersion);
    for (PlaceMeta* placeMeta in self.app.placeMetaDataListList) {
        for(NameIdPair *pair in placeMeta.providedServiceListList)
        {
            PPDebug(@"id = %d", pair.id);
            PPDebug(@"name = %@", pair.name);
            PPDebug(@"image = %@", pair.image);
        }
    }
}

-(PlaceMeta*)findPlaceMeta:(int32_t)categoryId
{
    NSArray *placeMetas = _app.placeMetaDataListList;
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

- (NSString*)getSubCategoryName:(int32_t)categoryId subCategoryId:(int32_t)subCategoryId
{
    //App* app = [self buildTestPlace];
    PlaceMeta *placeMeta = [self findPlaceMeta:categoryId];
    if (placeMeta == nil) {
        return @"";
    }
    
    NameIdPair *subCateGoryPair = [self findSubCategory:subCategoryId placeMeta:placeMeta];
    if(subCateGoryPair == nil){
        return @"";
    }
    
    return subCateGoryPair.name;
}


- (NSString*)getServiceImage:(int32_t)categoryId providedServiceId:(int32_t)providedServiceId
{
    PlaceMeta *placeMeta = [self findPlaceMeta:categoryId];
    if (placeMeta == nil){
        return @"";
    }
    
    NameIdPair *servicePair = [self findProvidedService:providedServiceId placeMeta:placeMeta];
    
    if (servicePair == nil) {
        return @"";
    }        
    
    return servicePair.image;
}

- (NSArray*)getCityList
{
    NSArray *cityList = _app.cityListList;
//    for (City* city in cityList) {
//        PPDebug(@"city name = %@", city.cityName);
//    }
       
    return cityList;
}

- (NSString*)getAppVersion
{
    return _app.dataVersion;
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

@end
