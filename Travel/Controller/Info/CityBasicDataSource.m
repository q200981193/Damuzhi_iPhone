//
//  CityBasicDataSource.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityBasicDataSource.h"
#import "InfoManager.h"

@implementation CityBasicDataSource

- (NSArray*)getImages
{
    NSLog(@"CityBasicDataSource <getImages>");
//    InfoManager* manager = [InfoManager defaultManager];
//    NSArray* array = [[manager getCityBasic] imagesList];
    return [[[InfoManager defaultManager] getCityBasic] imagesList];
}

- (NSString*)getHtmlFilePath
{
    return [[[InfoManager defaultManager] getCityBasic] html];
}

+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource
{
    CityBasicDataSource* obj = [[[CityBasicDataSource alloc] init] autorelease];
    return obj;
}


@end
