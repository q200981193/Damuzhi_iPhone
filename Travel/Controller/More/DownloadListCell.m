//
//  DownloadListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "DownloadListCell.h"
#import "AppUtils.h"
#import "AppService.h"

@interface DownloadListCell ()

@end

@implementation DownloadListCell

@synthesize city = _city;
@synthesize downloading = _downloading;

@synthesize downloadFlagButton;
@synthesize dataSizeLabel;
@synthesize downloadProgressView;
@synthesize downloadPersentLabel;
@synthesize downloadButton;
@synthesize onlineButton;
@synthesize cityNameLabel;

+ (NSString*)getCellIdentifier
{
    return @"DownloadListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)setCellData:(City*)city downloading:(NSNumber*)downloading
{
    self.city = city;
    self.downloading = downloading;
    
    
    self.cityNameLabel.text = _city.cityName;
    
    if (![_downloading boolValue]) {
        self.dataSizeLabel.hidden = NO;
        self.downloadPersentLabel.hidden = YES;
        self.downloadProgressView.hidden = YES;
        
        float dataSize = city.dataSize/1024.0/1024.0;
        self.dataSizeLabel.text = [[NSString alloc] initWithFormat:@"%0.1fM", dataSize];
    }
    else {
        self.dataSizeLabel.hidden = YES;
        self.downloadPersentLabel.hidden = NO;
        self.downloadProgressView.hidden = NO;
    }
    
    return;
}

- (void)dealloc {
    [_city release];
    [_downloading release];
    [downloadFlagButton release];
    [downloadProgressView release];
    [downloadPersentLabel release];
    [downloadButton release];
    [onlineButton release];
    [cityNameLabel release];
    [dataSizeLabel release];
    [cityNameLabel release];
    [dataSizeLabel release];
    [downloadPersentLabel release];
    [super dealloc];
}

- (IBAction)clickDownload:(id)sender {
    [self.downloading initWithBool:YES];
    self.dataSizeLabel.hidden = YES;
    self.downloadPersentLabel.hidden = NO;
    self.downloadProgressView.hidden = NO;
    
    NSLog(@"cityDataURL = %@", _city.downloadUrl);
    
    [[AppService defaultService] downloadCity:_city];
}

@end
