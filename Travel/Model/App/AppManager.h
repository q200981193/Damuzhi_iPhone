//
//  AppManager.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "App.pb.h"

#define APP_DATA_PATH @"app.dat"
#define IMAGE_DIR_OF_PROVIDED_SERVICE  @"App/Image/ProvidedService"

@interface AppManager : NSObject<CommonManagerProtocol>
{
    App* _app;
}

@property (retain, nonatomic) App *app;

- (void)loadAppData;
- (void)updateAppData:(App*)appData;

-(PlaceMeta*)findPlaceMeta:(int32_t)categoryId;

- (NSString*)getSubCategoryName:(int32_t)categoryId subCategoryId:(int32_t)subCategoryId;
- (NSString*)getServiceImage:(int32_t)categoryId providedServiceId:(int32_t)providedServiceId;
- (NSArray*)getCityList;
- (NSString*)getAppVersion;
- (NSArray*)getSubCategories:(int32_t)categoryId;

- (int)getCurrentCityId;
- (void)setCurrentCityId:(int)newCity;

@end
