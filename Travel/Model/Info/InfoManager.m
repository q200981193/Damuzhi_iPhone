//
//  InfoManager.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InfoManager.h"
#import "CityOverview.pb.h"

@implementation InfoManager

static InfoManager *_infoDefaultManager;

@synthesize cityBasic;
@synthesize cityOverview;

- (void)dealloc
{
    [cityOverview release];
    [cityBasic release];
    [super dealloc];
}

+ (InfoManager*)defaultManager
{
    if (_infoDefaultManager == nil){
        _infoDefaultManager = [[InfoManager alloc] init];
        [_infoDefaultManager readCityOverview:@"Hong Kong"];        
    }
    
    return _infoDefaultManager;
}

- (NSData*)readCityOverviewData:(NSString*)cityId
{
    // read from files later
    
    CityOverview_Builder* builder = [[[CityOverview_Builder alloc] init] autorelease];
    
    CommonOverview_Builder* dataBuilder = [[[CommonOverview_Builder alloc] init] autorelease];
    [dataBuilder setHtml:@"<html>City Overview</html>"];
    [dataBuilder addImages:@"1.png"];
    [dataBuilder addImages:@"2.png"];
    [dataBuilder addImages:@"3.png"];
    
    [builder setCityBasic:[dataBuilder build]];
        
    return [[builder build] data];
}

- (void)readCityOverview:(NSString*)cityId
{
    NSData* data = [self readCityOverviewData:cityId];
    self.cityOverview = [CityOverview parseFromData:data];    
}

- (CommonOverview*)getCityBasic
{    
    return self.cityOverview.cityBasic;
}

@end
