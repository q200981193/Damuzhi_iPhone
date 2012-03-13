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
    
    PPDebug(@"subCategory name = %@", subCateGoryPair.name);
    
    return subCateGoryPair.name;
}


- (NSString*)getServiceImage:(int32_t)categoryId providedServiceId:(int32_t)providedServiceId
{
    PlaceMeta *placeMeta = [self findPlaceMeta:categoryId];
    if (placeMeta == nil){
        return @"";
    }
    
    for (NameIdPair *service in placeMeta.providedServiceListList) {
        PPDebug(@"service id = %d", service.id);
        PPDebug(@"service name = %@", service.name);
        PPDebug(@"service image = %@", service.image);
    }
    
    NameIdPair *servicePair = [self findProvidedService:providedServiceId placeMeta:placeMeta];
    
    if (servicePair == nil) {
        return @"";
    }
        
    return [FileUtil getFileFullPath:[NSString stringWithFormat:@"/%@/%@", IMAGE_DIR_OF_PROVIDED_SERVICE, [NSString stringWithFormat:@"%d", servicePair.id]]];
    
    //return servicePair.image;
}

- (NSArray*)getCityList
{
    NSArray *cityList = _app.cityListList;
       
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
