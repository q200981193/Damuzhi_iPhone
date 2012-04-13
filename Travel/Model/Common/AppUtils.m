//
//  AppUtils.m
//  Travel
//
//  Created by 小涛 王 on 12-3-19.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "AppUtils.h"
#import "AppConstants.h"
#import "FileUtil.h"
#import "SSZipArchive.h"
#import "PPDebug.h"

@implementation AppUtils

+ (NSString*)getDownloadDir
{
    return [FileUtil getFileFullPath:DIR_OF_DOWNLOAD];
}

+ (NSString*)getDownloadPath:(int)cityId
{
    return [[AppUtils getDownloadDir] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.zip", cityId]];
}

+ (NSString*)getAppDir
{
    return [FileUtil getFileFullPath:DIR_OF_APP];
}

+ (NSString*)getZipDir
{
    return [FileUtil getFileFullPath:DIR_OF_ZIP];
}

+ (NSString*)getCityDir:(int)cityId
{
    return [[FileUtil getFileFullPath:DIR_OF_CITY] stringByAppendingPathComponent:[[NSString alloc] initWithFormat:@"/%d", cityId]];
}

+ (NSString*)getCityDataDir:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_CITY_DATA];
}

+ (NSString*)getCityoverViewFilePath:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:FILENAME_OF_CITY_OVERVIEW_DATA]; 
}

+ (NSString*)getPackageFilePath:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:FILENAME_OF_PACKAGE_DATA];
}

+ (NSArray*)getPlaceFilePathList:(int)cityId
{
    NSString *palceFileDir = [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_PLACE_DATA];
    
    return [self getFilePathList:palceFileDir];
}

+ (NSArray*)getGuideFilePathList:(int)cityId
{
    NSString *guideDir = [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_GUIDE_DATA];
    
    return [self getFilePathList:guideDir];
}

+ (NSArray*)getRouteFilePathList:(int)cityId
{
    NSString *routeDir = [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_ROUTE_DATA];
    
    return [self getFilePathList:routeDir];
}

+ (NSArray*)getFilePathList:(NSString*)fileDir
{
    NSArray *filenameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fileDir error:nil];
    NSMutableArray *filePathList = [[[NSMutableArray alloc] init] autorelease];
    
    for (NSString *filename in filenameList) {
        BOOL flag = YES;
        NSString *fullPath = [fileDir stringByAppendingPathComponent:filename];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [filePathList addObject:fullPath];
            }
        }
    }
    
    return filePathList;
}
            
+ (NSString*)getUnzipFlag:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:FLAG_OF_UNZIP_SUCCESS];
}

+ (NSString*)getZipFilePath:(int)cityId
{
    //TODO, consturct a zip file path and return 
    NSString *zipName = [[NSString alloc] initWithFormat:@"%d.zip", cityId];
    return [[AppUtils getZipDir] stringByAppendingPathComponent:zipName];
    [zipName release];
}

+ (NSString*)getAppFilePath
{
    return [[AppUtils getAppDir] stringByAppendingPathComponent:FILENAME_OF_APP_DATA];
}


+ (NSString*)getProvidedServiceIconDir
{
    return [FileUtil getFileFullPath:DIR_OF_PROVIDED_SERVICE_IMAGE];
}

+ (NSString*)getCategoryImageDir
{
    return [FileUtil getFileFullPath:DIR_OF_CATEGORY_IMAGE];
}

+ (BOOL)hasLocalCityData:(int)cityId
{
    BOOL hasData = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getUnzipFlag:cityId]]) {
        hasData = YES;
    }
    
    return hasData;
} 

+ (void)unzipCityZip:(int)cityId
{
    [FileUtil createDir:[AppUtils getCityDir:cityId]];
    
    if ([SSZipArchive unzipFileAtPath:[AppUtils getZipFilePath:cityId]
                        toDestination:[AppUtils getCityDir:cityId]]) {
        [[NSFileManager defaultManager] createFileAtPath:[AppUtils getUnzipFlag:cityId]
                                                contents:nil
                                              attributes:nil];
    }
    
    return;
}

+ (void)deleteCityData:(int)cityId
{
    NSString *path = [AppUtils getCityDir:cityId];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    return;
}

+ (NSString*)getAbsolutePath:(NSString*)absoluteDir string:(NSString*)string
{
    if ([string hasPrefix:@"http:"]) {
        return string;
    }else{
        return [absoluteDir stringByAppendingPathComponent:string];
    }
}

+ (NSURL*)getNSURLFromHtmlFileOrURL:(NSString*)fileOrURL
{
    NSURL* url = nil;
    if ([fileOrURL hasPrefix:@"http:"]){
        url = [NSURL URLWithString:fileOrURL];           
    }
    else{
        NSString *htmlPath = fileOrURL;        
        url = [NSURL fileURLWithPath:htmlPath];
    }
    
    return url;
}

+ (NSString*)getProvidedServiceIconPath:(int)providedServiceId
{
    NSString *destinationDir = [AppUtils getProvidedServiceIconDir];
    NSString *fileName = [NSString stringWithFormat:@"%d.png", providedServiceId];
    return [destinationDir stringByAppendingPathComponent:fileName];
}



+ (BOOL)isShowImage
{
    //default return YES
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IS_SHOW_IMAGE]) {
        return YES;
    }
    return [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_SHOW_IMAGE];
}

+ (void)enableImageShow:(BOOL)isShow
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isShow forKey:KEY_IS_SHOW_IMAGE];
}

+ (NSString*)getCategoryIcon:(int)categoryId;
{
    switch (categoryId) {
        case PLACE_SPOT:
            return @"jd";
            break;
        case PLACE_HOTEL:
            return @"ht";
            break;
        case PLACE_RESTRAURANT:
            return @"cg";
            break;
        case PLACE_SHOPPING:
            return @"gw";
            break;
        case PLACE_ENTERTAINMENT:
            return @"yl";
            break;
        default:
            break;
    }
    return nil;
}

@end
