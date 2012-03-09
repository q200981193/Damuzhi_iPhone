//
//  DownloadListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "DownloadListCell.h"

@interface DownloadListCell ()

@end

@implementation DownloadListCell
@synthesize downloadFlagButton;
@synthesize downloadProgressView;
@synthesize downloadPersentLable;
@synthesize downloadButton;
@synthesize onlineButton;
@synthesize cityNameLable;

+ (NSString*)getCellIdentifier
{
    return @"DownloadListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)dealloc {
    [downloadFlagButton release];
    [downloadProgressView release];
    [downloadPersentLable release];
    [downloadButton release];
    [onlineButton release];
    [cityNameLable release];
    [super dealloc];
}

@end
