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
#import "AppConstants.h"
#import "AppUtils.h"

@implementation AppManager

static AppManager* _defaultAppManager = nil;
@synthesize app = _app;
@synthesize cityList = _cityList;

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
    [_cityList release];
    [super dealloc];
}

- (void)loadAppData
{
    // TODO: check if there is a copy data for app in document dir, if yes, return;
    NSData *localAppData = [NSData dataWithContentsOfFile:[AppUtils getAppFilePath]];
    PPDebug(@"app data file path = %@", [AppUtils getAppFilePath]);
    if(localAppData != nil)
    {
        App *localApp = [App parseFromData:localAppData];
        self.app = localApp;
    }
    
}

- (void)updateAppData:(App*)appData
{
    PPDebug(@"Updating app data......");
    self.app = appData;    
    [[appData data] writeToFile:[AppUtils getAppFilePath] atomically:YES];
}

- (City*)getCity:(int)cityId
{
    for (City *city in _app.citiesList) {
        if(city.cityId == cityId)
        {
            return city;
        }
    }
    
    return nil;
}

- (City*)getTestCity:(int)cityId
{
    for (City *testCity in _app.testCitiesList) {
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

- (NSArray*)getCityList
{
    return _app.citiesList;
}

- (NSArray*)getCityIdList
{
    NSMutableArray *cityIdList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.citiesList) {
        NSNumber *cityId = [[[NSNumber alloc] initWithInt:city.cityId] autorelease];
        [cityIdList addObject:cityId]; 
    }
    
    return cityIdList;
}

- (NSArray*)getCityNameList
{
    NSMutableArray *cityNameList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.citiesList) {
        [cityNameList addObject:city.cityName]; 
    }
    
    return cityNameList;
}

- (NSArray*)getTestCityNameList
{
    NSMutableArray *cityNameList = [[[NSMutableArray alloc] init] autorelease];
    for (City *city in _app.testCitiesList) {
        [cityNameList addObject:city.cityName]; 
    }
    
    return cityNameList;
}

- (NSString*)getCityName:(int)cityId
{
    NSString *cityName = NSLS(@"未知");;
    for (City *city in _app.citiesList) {
        if (city.cityId == cityId) {
            cityName = city.cityName;
        }   
    }
    
    return cityName;
}

- (NSString*)getCityLatestVersion:(int)cityId
{
    NSString *cityName = NSLS(@"未知");;
    for (City *city in _app.testCitiesList) {
        if (city.cityId == cityId) {
            cityName = city.cityName;
        }   
    }
    
    return cityName;
}

- (NSString*)getCountryName:(int)cityId
{
    NSString *countryName = NSLS(@"未知");;
    for (City *city in _app.testCitiesList) {
        if (city.cityId == cityId) {
            countryName = city.countryName;
        }   
    }
    
    return countryName;
}

- (int)getCityDataSize:(int)cityId
{
    int dataSize = 0;
    for (City *city in _app.testCitiesList) {
        if (city.cityId == cityId) {
            dataSize = city.dataSize;
        }   
    }
    
    return dataSize;
}

- (NSString*)getCityDownloadUrl:(int)cityId
{
    NSString *url = NSLS(@"未知");;
    for (City *city in _app.testCitiesList) {
        if (city.cityId == cityId) {
            url = city.downloadUrl;
        }   
    }
    
    return url;
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

- (NSString*)getCategoryName:(int)categoryId
{
    NSString *categoryName = NSLS(@"未知");
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if(placeMeta != nil)
    {
        categoryName = placeMeta.name;
    }
    
    return categoryName;
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
    NSString *subCategoryName = NSLS(@"未知");
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
    NSString *providedServiceName = NSLS(@"未知");
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
    NSString *providedServiceIcon = NSLS(@"未知");
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

- (int)getCurrentCityId
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSNumber* city = [userDefault objectForKey:KEY_CURRENT_CITY];
    if (city == nil){
        return BUILDIN_CITY_ID;
    }
    else {
        return [city intValue];
    }
}

- (NSString*)getCurrentCityName
{
    int cityId = [self getCurrentCityId];
    return [self getCityName:cityId];
}

- (void)setCurrentCityId:(int)newCityId
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults]; 
    [userDefault setObject:[NSNumber numberWithInt:newCityId] forKey:KEY_CURRENT_CITY];
    [userDefault synchronize];
}

- (NSArray*)buildSpotSortOptionList
{
    NSMutableArray *spotSortOptions = [[[NSMutableArray alloc] init] autorelease];    
    [spotSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"大拇指推荐高至低") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_RECOMMEND]]];
    [spotSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"距离近至远") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR]]];
    [spotSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"门票价格高到低") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP]]];
    
    return spotSortOptions;
}

- (NSArray*)buildHotelSortOptionList
{
    NSMutableArray *hotelSortOptions = [[[NSMutableArray alloc] init] autorelease];    
    [hotelSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"大拇指推荐高至低") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_RECOMMEND]]];
    [hotelSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"星级高至低") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_STARTS]]];
    [hotelSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"价格高至低") 
                                                           forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP]]];
    [hotelSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"价格低至高") 
                                                            forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE]]];
    [hotelSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"距离近至远") 
                                                            forKey:[NSNumber numberWithInt:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR]]];
    return hotelSortOptions;
}

- (NSArray*)buildRestaurantSortOptionList
{
    NSMutableArray *hestaurantSortOptions = [[[NSMutableArray alloc] init] autorelease];    
    [hestaurantSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"大拇指推荐高至低") 
                                                            forKey:[NSNumber numberWithInt:SORT_BY_RECOMMEND]]];
    [hestaurantSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"价格高至低") 
                                                            forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP]]];
    [hestaurantSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"价格低至高") 
                                                            forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE]]];
    [hestaurantSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"距离近至远") 
                                                            forKey:[NSNumber numberWithInt:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR]]];
    return hestaurantSortOptions;
}

- (NSArray*)buildShoppingSortOptionList
{
    NSMutableArray *shoppingtSortOptions = [[[NSMutableArray alloc] init] autorelease];    
    [shoppingtSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"大拇指推荐高至低") 
                                                                 forKey:[NSNumber numberWithInt:SORT_BY_RECOMMEND]]];;
    [shoppingtSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"距离近至远") 
                                                                 forKey:[NSNumber numberWithInt:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR]]];
    return shoppingtSortOptions;
}

- (NSArray*)buildEntertainmentSortOptionList
{
    NSMutableArray *entertainmentSortOptions = [[[NSMutableArray alloc] init] autorelease];    
    [entertainmentSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"大拇指推荐高至低") 
                                                                 forKey:[NSNumber numberWithInt:SORT_BY_RECOMMEND]]];
    [entertainmentSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"价格高至低") 
                                                                 forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_EXPENSIVE_TO_CHEAP]]];
    [entertainmentSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"价格低至高") 
                                                                 forKey:[NSNumber numberWithInt:SORT_BY_PRICE_FORM_CHEAP_TO_EXPENSIVE]]];
    [entertainmentSortOptions addObject:[NSDictionary dictionaryWithObject:NSLS(@"距离近至远") 
                                                                 forKey:[NSNumber numberWithInt:SORT_BY_DESTANCE_FROM_NEAR_TO_FAR]]];
    return entertainmentSortOptions;
}

- (NSArray*)getSubCategoryList:(int)categoryId
{
    NSMutableArray *subCategoryList = [[[NSMutableArray alloc] init] autorelease];    
    [subCategoryList addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部") forKey:[NSNumber numberWithInt:ALL_CATEGORY]]];
    
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *subCategory in [placeMeta subCategoryListList]) {
            [subCategoryList addObject:[NSDictionary dictionaryWithObject:subCategory.name 
                                                                   forKey:[NSNumber numberWithInt:subCategory.id]]];
        }
    }
    
    return subCategoryList;
}

- (NSArray*)getProvidedServiceList:(int)categoryId
{
    NSMutableArray *providedServiceList = [[[NSMutableArray alloc] init] autorelease];
    [providedServiceList addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部")
                                                               forKey:[NSNumber numberWithInt:ALL_CATEGORY]]];
    
    PlaceMeta *placeMeta = [self getPlaceMeta:categoryId];
    if (placeMeta !=nil) {
        for (NameIdPair *providedService in [placeMeta providedServiceListList]) {
            [providedServiceList addObject:[NSDictionary dictionaryWithObject:providedService.name 
                                                                   forKey:[NSNumber numberWithInt:providedService.id]]];
        }
    }
    
    return providedServiceList;
}

- (NSArray*)getSortOptionList:(int32_t)categoryId
{
    NSArray *array = nil;
    switch (categoryId) {
        case PLACE_TYPE_SPOT:            
            array = [self buildSpotSortOptionList];
            break;
            
        case PLACE_TYPE_HOTEL:
            array = [self buildHotelSortOptionList];
            break;
            
        case PLACE_TYPE_RESTAURANT:
            array = [self buildRestaurantSortOptionList];
            break;
            
        case PLACE_TYPE_SHOPPING:
            array = [self buildShoppingSortOptionList];
            break;
            
        case PLACE_TYPE_ENTERTAINMENT:
            array = [self buildEntertainmentSortOptionList];
            break;
            
        default:
            break;
    }
    
    return array;
}

- (NSArray*)getHotelPriceList;
{
    NSMutableArray *hotelPriceList = [[[NSMutableArray alloc] init] autorelease];    
    [hotelPriceList addObject:[NSDictionary dictionaryWithObject:NSLS(@"全部") 
                                                           forKey:[NSNumber numberWithInt:ALL_CATEGORY]]];
    
    [hotelPriceList addObject:[NSDictionary dictionaryWithObject:NSLS(@"500以下") 
                                                          forKey:[NSNumber numberWithInt:PRICE_BELOW_500]]];
    
    [hotelPriceList addObject:[NSDictionary dictionaryWithObject:NSLS(@"500-1000") 
                                                          forKey:[NSNumber numberWithInt:PRICE_500_1000]]];
    
    [hotelPriceList addObject:[NSDictionary dictionaryWithObject:NSLS(@"1000-1500") 
                                                          forKey:[NSNumber numberWithInt:PRICE_1000_1500]]];
    
    [hotelPriceList addObject:[NSDictionary dictionaryWithObject:NSLS(@"1500以上") 
                                                          forKey:[NSNumber numberWithInt:PRICE_MORE_THAN_1500]]];
    
    return hotelPriceList;
}

@end
