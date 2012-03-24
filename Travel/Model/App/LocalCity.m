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
@synthesize downloadFlag = _downloadFlag;

+ (LocalCity*)localCityWith:(int)cityId downloadProgress:(float)downloadProgress downloadFlag:(int)downloadFlag
{
    LocalCity *localCity = [[[LocalCity alloc] init] autorelease];
    localCity.cityId = cityId;
    localCity.downloadProgress = downloadProgress;
    return localCity;
}

- (NSString*)description
{
    NSString *description = [NSString stringWithFormat:@"cityId:%d downloadProgress:%0.1f downloadFlag:%d", _cityId, _downloadProgress, _downloadFlag];

    return description;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.cityId forKey:@"cityId"];
    [aCoder encodeFloat:self.downloadProgress forKey:@"downloadProgress"];
    [aCoder encodeInt:self.downloadFlag forKey:@"downloadFlag"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityId = [aDecoder decodeIntForKey:@"cityId"];
        self.downloadProgress = [aDecoder decodeFloatForKey:@"downloadProgress"];
        self.downloadFlag = [aDecoder decodeIntForKey:@"downloadFlag"];
    }
    
    return self;
}

@end
