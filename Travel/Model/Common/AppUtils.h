//
//  AppUtils.h
//  Travel
//
//  Created by 小涛 王 on 12-3-19.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

// App dir struct 
// -----document--------download--------001_ZhHans_1.0.zip
//                |
//                |
//                 -----zip--------001_ZhHans_1.0.zip 
//                |
//                |
//                 -----city--------1--------data--------overview.dat
//                |           |
//                |           |
//                |            ------2-------data--------
//                |  
//                 -----app.dat
//                |   
//                 -----help.html

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface AppUtils

//interface for create dir
+ (NSString*)getDownloadDir;
+ (NSString*)getDownloadPath:(int)cityId;
+ (NSString*)getAppDir;
+ (NSString*)getHelpHtmlDir;
+ (NSString*)getZipDir;
+ (NSString*)getCityDir:(int)cityId;
+ (NSString*)getCityDataDir:(int)cityId;

//interface for file path
+ (NSString*)getCityoverViewFilePath:(int)cityId;
+ (NSString*)getPackageFilePath:(int)cityId;
+ (NSArray*)getPlaceFilePathList:(int)cityId;

+ (NSArray*)getGuideFilePathList:(int)cityId;
+ (NSArray*)getRouteFilePathList:(int)cityId;

//interface for ...
+ (NSString*)getUnzipFlag:(int)cityId;
+ (NSString*)getZipFilePath:(int)cityId;
+ (NSString*)getAppFilePath;

+ (NSString*)getHelpHtmlFilePath;
+ (BOOL)hasLocalHelpHtml;

+ (NSString*)getProvidedServiceIconDir;
+ (NSString*)getCategoryImageDir;

+ (BOOL)hasLocalCityData:(int)cityId;
+ (BOOL)unzipCityZip:(int)cityId;
+ (NSString*)getHelpZipFilePath;


+ (void)deleteCityData:(int)cityId;


+ (NSString*)getAbsolutePath:(NSString*)absoluteDir string:(NSString*)string;
+ (NSURL*)getNSURLFromHtmlFileOrURL:(NSString*)fileOrURL;
+ (NSString*)getProvidedServiceIconPath:(int)providedServiceId;

+ (BOOL)isShowImage;
+ (void)enableImageShow:(BOOL)isShow;

+ (NSString*)getCategoryIcon:(int)categoryId;

+ (NSString*)getCategoryIndicatorIcon:(int)categoryId;
+ (NSString*)getCategoryPinIcon:(int)categoryId;
+ (UIAlertView*)showUsingCellNetworkAlertViewWithTag:(int)tag delegate:(id)delegate;
+ (UIAlertView*)showDeleteCityDataAlertViewWithTag:(int)tag delegate:(id)delegate;


@end
