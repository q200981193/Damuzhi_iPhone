//
//  CityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LocalCity.h"

@implementation LocalCity

@synthesize cityId= _cityId;
@synthesize downloadProgress = _downloadProgress;
@synthesize downloadingFlag = _downloadingFlag;
@synthesize downloadDoneFlag = _downloadDoneFlag;

+ (LocalCity*)localCityWith:(int)cityId downloadProgress:(float)downloadProgress downloadingFlag:(bool)downloadingFlag downloadDoneFlag:(bool)downloadDoneFlag
{
    LocalCity *localCity = [[[LocalCity alloc] init] autorelease];
    localCity.cityId = cityId;
    localCity.downloadProgress = downloadProgress;
    localCity.downloadingFlag = downloadingFlag; 
    localCity.downloadDoneFlag = downloadDoneFlag;
    return localCity;
}

- (NSString*)description
{
    NSString *description = [NSString stringWithFormat:@"cityId:%d downloadProgress:%0.1f downloadingFlag:%d downloadDoneFlag", _cityId, _downloadProgress, _downloadingFlag, _downloadDoneFlag];

    return description;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.cityId forKey:KEY_LOCAL_CITY_ID];
    [aCoder encodeFloat:self.downloadProgress forKey:KEY_DOWNLOAD_PROGRESS];
    [aCoder encodeInt:self.downloadingFlag forKey:KEY_DOWNLOADING_FLAG];
    [aCoder encodeInt:self.downloadingFlag forKey:KEY_DOWNLOAD_DONE_FLAG];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityId = [aDecoder decodeIntForKey:KEY_LOCAL_CITY_ID];
        self.downloadProgress = [aDecoder decodeFloatForKey:KEY_DOWNLOAD_PROGRESS];
        self.downloadingFlag = [aDecoder decodeIntForKey:KEY_DOWNLOADING_FLAG];
        self.downloadingFlag = [aDecoder decodeIntForKey:KEY_DOWNLOAD_DONE_FLAG];
    }
    
    return self;
}

- (void)setProgress:(float)newProgress
{
    NSLog(@"progress = %f", newProgress);
    self.downloadProgress = newProgress;
}

@end
