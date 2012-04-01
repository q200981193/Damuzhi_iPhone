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
    
    if ([AppUtils validateUrl:[images objectAtIndex:0]]) {
        return images;
    }
    else
    {
        NSMutableArray *imagePathList = [[NSMutableArray alloc] init];
        for (NSString *image in images) {
            NSString *imagePath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:image]; 
            [imagePathList addObject:imagePath];
        }
        return imagePathList;
    }
}

- (NSURL*)getHtmlFileURL
{
    NSURL *url = nil;
    NSString *html = [[CityOverViewManager defaultManager] getCityBasicHtml];
    if ([AppUtils validateUrl:html]) {
        url = [NSURL URLWithString:html];
    }
    else{
        NSString *htmlPath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:html]; 
        url = [NSURL fileURLWithPath:htmlPath];
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
