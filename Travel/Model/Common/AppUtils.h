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
//                 -----city--------1--------data--------
//                            |
//                            |
//                            ------2--------data--------

#import <Foundation/Foundation.h>

@interface AppUtils

//interface for create dir
+ (NSString*)getDownloadDir;
+ (NSString*)getAppDir;
+ (NSString*)getZipDir;
+ (NSString*)getCityDir:(int)cityId;

//interface for ...
+ (NSString*)getCityoverViewFilePath:(int)cityId;
+ (NSArray*)getPlaceFilePathList:(int)cityId;

//interface for ...
+ (NSString*)getUnzipFlag:(int)cityId;

+ (NSString*)getZipFilePath:(int)cityId;
+ (NSString*)getAppFilePath;

+ (BOOL)hasLocalCityData:(int)cityId;



@end
