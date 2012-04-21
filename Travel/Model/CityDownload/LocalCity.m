//
//  CityManager.m
//  Travel
//
//  Created by 小涛 王 on 12-3-23.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LocalCity.h"
#import "ASIHTTPRequest.h"
#import "AppManager.h"

@implementation LocalCity

@synthesize cityId= _cityId;
@synthesize downloadProgress = _downloadProgress;
@synthesize downloadStatus = _downloadStatus;
@synthesize updateStatus = _updateStatus;
@synthesize downloadType = _downloadType;
@synthesize delegate = _delegate;

+ (LocalCity*)localCityWith:(int)cityId
{
    LocalCity *localCity = [[[LocalCity alloc] init] autorelease];
    localCity.cityId = cityId;
    return localCity;
}

- (NSString*)description
{
    return nil;
}

- (void)dealloc
{
    [_delegate release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.cityId forKey:KEY_LOCAL_CITY_ID];
    [aCoder encodeFloat:self.downloadProgress forKey:KEY_DOWNLOAD_PROGRESS];
    [aCoder encodeInt:self.downloadStatus forKey:KEY_DOWNLOADING_STATUS];
    [aCoder encodeInt:self.updateStatus forKey:KEY_UPDATE_STATUS];
    [aCoder encodeInt:self.downloadType forKey:KEY_DOWNLOAD_TYPE];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityId = [aDecoder decodeIntForKey:KEY_LOCAL_CITY_ID];
        self.downloadProgress = [aDecoder decodeFloatForKey:KEY_DOWNLOAD_PROGRESS];
        self.downloadStatus = [aDecoder decodeIntForKey:KEY_DOWNLOADING_STATUS];
        self.updateStatus = [aDecoder decodeIntForKey:KEY_UPDATE_STATUS];
        self.downloadType = [aDecoder decodeIntForKey:KEY_DOWNLOAD_TYPE];
    }
    
    return self;
}

- (void)setProgress:(float)newProgress
{
    NSLog(@"progress = %f", newProgress);
    self.downloadProgress = newProgress;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    switch (_downloadType) {
        case TYPE_DOWNLOAD:
            _downloadStatus = DOWNLOAD_SUCCEED;
            break;
            
        case TYPE_UPDATE:
            _updateStatus = UPDATE_SUCCEED;
            break;
            
        default:
            break;
    }    
    
    if (_delegate && [_delegate respondsToSelector:@selector(didFinishDownload:)]) {
        [_delegate didFinishDownload:[[AppManager defaultManager] getCity:self.cityId]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    switch (_downloadType) {
        case TYPE_DOWNLOAD:
            _downloadStatus = DOWNLOAD_FAILED;
            break;
            
        case TYPE_UPDATE:
            _updateStatus = UPDATE_FAILED;
            break;
            
        default:
            break;
    }    
    
    if (_delegate && [_delegate respondsToSelector:@selector(didFailDownload:error::)]) {
        [_delegate didFailDownload:[[AppManager defaultManager] getCity:self.cityId] error:[request error]];
    }
}

@end
