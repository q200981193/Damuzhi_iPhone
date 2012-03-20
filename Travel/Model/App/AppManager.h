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

- (NSString*)getAppDataVersion;
- (NSString*)getHelpHtml;

- (NSArray*)getCityNameList;
- (NSArray*)getTestCityNameList;

- (NSString*)getCityName:(int)cityId;
- (NSString*)getCityLatestVersion:(int)cityId;

- (NSArray*)getPlaceName:(int)categoryId;
- (NSArray*)getSubCategoryList:(int)categoryId;
- (NSArray*)getProvidedServiceList:(int)categoryId;

- (NSArray*)getSubCategotyNameList:(int)categoryId;
- (NSArray*)getProvidedServiceNameList:(int)categoryId;
- (NSArray*)getProvidedServiceIconList:(int)categoryId;

- (NSString*)getSubCategotyName:(int)categoryId subCategoryId:(int)subCategoryId;
- (NSString*)getProvidedServiceName:(int)categoryId providedServiceId:(int)providedServiceId;
- (NSString*)getProvidedServiceIcon:(int)categoryId providedServiceId:(int)providedServiceId;

- (int)getCurrentCityId;
- (NSString*)getCurrentCityName;
- (void)setCurrentCityId:(int)newCity;

- (NSArray*)getSortOptionList:(int)categoryId;

@end
