//
//  AppManager.m
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppManager.h"
#import "App.pb.h"

@implementation AppManager

static AppManager* _defaultAppManager = nil;

+ (id)defaultManager
{
    if (_defaultAppManager == nil){
        _defaultAppManager = [[AppManager alloc] init];
    }
    return _defaultAppManager;
}

- (App*)buildTestPlace
{
    App_Builder* app = [[[App_Builder alloc] init] autorelease];
    
    [app setDataVersion:@"Version 1.0"];
    
    City_Builder *cityBuilder1 = [[[City_Builder alloc] init] autorelease];
    [cityBuilder1 setCityId:1];
    [cityBuilder1 setCityName:@"香港"];
    City *city1 = [cityBuilder1 build];
    [app addCityList:city1];
    [app addTestCityList:city1];
    
    City_Builder *cityBuilder2 = [[[City_Builder alloc] init] autorelease];
    [cityBuilder2 setCityId:2];
    [cityBuilder2 setCityName:@"深圳"];
    City *city2 = [cityBuilder2 build];
    [app addCityList:city2];
    [app addTestCityList:city2];
    
    PlaceMeta_Builder* placeMeta = [[[PlaceMeta_Builder alloc] init] autorelease];
    
    [placeMeta setCategoryId:1];
    [placeMeta setName:@"景点"];

    NameIdPair_Builder* subCategoryNamePairBuilder1 = [[[NameIdPair_Builder alloc] init] autorelease];
    [subCategoryNamePairBuilder1 setName:@"九龙区"];
    [subCategoryNamePairBuilder1 setId:1];
    [placeMeta addSubCategoryList:[subCategoryNamePairBuilder1 build]];
    
    NameIdPair_Builder* subCategoryNamePairBuilder2 = [[[NameIdPair_Builder alloc] init] autorelease];
    [subCategoryNamePairBuilder2 setName:@"旺角区"];
    [subCategoryNamePairBuilder2 setId:2];
    [placeMeta addSubCategoryList:[subCategoryNamePairBuilder2 build]];
    
    NameIdPair_Builder* provideServiceListBuilder1 = [[[NameIdPair_Builder alloc] init] autorelease];    
    [provideServiceListBuilder1 setName:@"办公"];
    [provideServiceListBuilder1 setId:1];
    [provideServiceListBuilder1 setImage:@"office.png"];
    [placeMeta addProvidedServiceList:[provideServiceListBuilder1 build]];
    
    NameIdPair_Builder* provideServiceListBuilder2 = [[[NameIdPair_Builder alloc] init] autorelease];
    [provideServiceListBuilder2 setName:@"就餐"];
    [provideServiceListBuilder2 setId:2];
    [provideServiceListBuilder2 setImage:@"meat.png"];
    [placeMeta addProvidedServiceList:[provideServiceListBuilder2 build]];
    
    NameIdPair_Builder* provideServiceListBuilder3 = [[[NameIdPair_Builder alloc] init] autorelease];
    [provideServiceListBuilder3 setName:@"购物"];
    [provideServiceListBuilder3 setId:3];
    [provideServiceListBuilder3 setImage:@"shopping.png"];
    [placeMeta addProvidedServiceList:[provideServiceListBuilder3 build]];
    
    [app addPlaceMetaDataList:[placeMeta build]];
        
    return [app build];
}

-(PlaceMeta*)findPlaceMeta:(int32_t)categoryId app:(App*)app
{
    NSArray *placeMetas = app.placeMetaDataListList;
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
    App* app = [self buildTestPlace];
    PlaceMeta *placeMeta = [self findPlaceMeta:categoryId app:app];
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
    App* app = [self buildTestPlace];
    PlaceMeta *placeMeta = [self findPlaceMeta:categoryId app:app];
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
    App *app = [self buildTestPlace];
    NSArray *cityList = app.cityListList;
       
    return cityList;
}

@end
