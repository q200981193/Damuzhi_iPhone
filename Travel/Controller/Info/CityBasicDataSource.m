//
//  CityBasicDataSource.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityBasicDataSource.h"
#import "InfoManager.h"
#import "CityOverviewManager.h"
#import "AppManager.h"
#import "AppUtils.h"

@implementation CityBasicDataSource

- (NSArray*)getImages
{
    NSLog(@"CityBasicDataSource <getImages>");
    NSArray *images = [[CityOverViewManager defaultManager] getCityBasicImageList];
    if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]]) {
        NSMutableArray *imagePathList = [[NSMutableArray alloc] init];
        for (NSString *image in images) {
            NSString *imagePath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:image]; 
            [imagePathList addObject:imagePath];
        }
        return imagePathList;
    }
    else
    {
        return images;
    }
}

- (NSURL*)getHtmlFileURL
{
//    return [[[InfoManager defaultManager] getCityBasic] html];
    NSURL *url = nil;
    NSString *html = [[CityOverViewManager defaultManager] getCityBasicHtml];
    if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]]) {
        NSString *htmlPath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:html]; 
        url = [NSURL fileURLWithPath:htmlPath];
        
    }
    else{
        url = [NSURL URLWithString:html];
    }

    
    return url;
}

- (NSString*)getTitleName
{
    return NSLS(@"城市概况");
}

+ (NSObject<CommonInfoDataSourceProtocol>*)createDataSource
{
    CityBasicDataSource* obj = [[[CityBasicDataSource alloc] init] autorelease];
    
    [[CityOverViewService defaultService]findCityOverViewByCityId:nil cityId:[[AppManager defaultManager] getCurrentCityId]];

    return obj;
}


@end
