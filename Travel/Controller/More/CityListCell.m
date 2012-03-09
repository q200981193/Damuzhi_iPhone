//
//  CityListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityListCell.h"

@interface CityListCell ()

@end

@implementation CityListCell
@synthesize cityNameLable;
@synthesize updateButton;
@synthesize deleteButton;
@synthesize sizeOfDataLabel;


+ (NSString*)getCellIdentifier
{
    return @"CityListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)dealloc {
    [cityNameLable release];
    [updateButton release];
    [deleteButton release];
    [sizeOfDataLabel release];
    [super dealloc];
}
@end
