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

+ (id)defaultManager
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
    [dataBuilder addImages:@"image.jpg"];
    [dataBuilder addImages:@"image2.jpg"];
    [dataBuilder addImages:@"image3.jpg"];
    [dataBuilder addImages:@"image4.jpg"];
    [dataBuilder addImages:@"image5.jpg"];
    
    [builder setCityBasic:[dataBuilder build]];
    [builder setCurrencyId:@"HKD"];
    [builder setCurrencyName:@"港币"];
    [builder setCurrencySymbol:@"$"];
    CityOverview* overview = [builder build];

    return [overview data];
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
