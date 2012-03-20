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

@implementation AppUtils

+ (NSString*)getDownloadDir
{
    return [FileUtil getFileFullPath:DIR_OF_DOWNLOAD];
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

+ (NSString*)getCityoverViewFilePath:(int)cityId
{
    return [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:FILENAME_OF_CITY_OVERVIEW_DATA]; 
}

+ (NSArray*)getPlaceFilePathList:(int)cityId
{
    NSString *palceFileDir = [[AppUtils getCityDir:cityId] stringByAppendingPathComponent:DIR_OF_PLACE_DATA];
    NSArray *filenameList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:palceFileDir error:nil];
    NSMutableArray *filePathList = [[NSMutableArray alloc] init];
    
    for (NSString *filename in filenameList) {
        BOOL flag = YES;
        NSString *fullPath = [palceFileDir stringByAppendingPathComponent:filename];
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
    if (cityId == DEFAULT_CITY_ID) {
        return [[AppUtils getZipDir] stringByAppendingPathComponent:DEFAULT_CITY_ZIP];
    }
    
    return @"";
}

+ (NSString*)getAppFilePath
{
    return [[AppUtils getAppDir] stringByAppendingFormat:FILENAME_OF_APP_DATA];
}

+ (BOOL)hasLocalCityData:(int)cityId
{
    BOOL hasData = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[AppUtils getUnzipFlag:cityId]]) {
        hasData = YES;
    }
    
    return hasData;
}



@end