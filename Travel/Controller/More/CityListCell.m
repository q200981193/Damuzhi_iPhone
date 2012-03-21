//
//  CityListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityListCell.h"
#import "AppManager.h"
#import "LocaleUtils.h"
#import "ImageName.h"
#import "PackageManager.h"


@interface CityListCell ()

@end

@implementation CityListCell
@synthesize cityNameLabel;
@synthesize updateButton;
@synthesize deleteButton;
@synthesize dataSizeLabel;


+ (NSString*)getCellIdentifier
{
    return @"CityListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)setCellData:(City*)city
{
    self.cityNameLabel.text = [[city.countryName stringByAppendingString:NSLS(@".")] stringByAppendingString:city.cityName];
    
    float dataSize = city.dataSize/1024.0/1024.0;
    self.dataSizeLabel.text = [[NSString alloc] initWithFormat:@"%0.1fM", dataSize];
    
    if ([[AppManager defaultManager] getCurrentCityId] == city.cityId) {
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_DEFAULT_BTN]forState:UIControlStateNormal];
        [self.deleteButton setTitle:NSLS(@"默认") forState:UIControlStateNormal];
    }
    else {
        [self.deleteButton setBackgroundImage:[UIImage imageNamed:IMAGE_CITY_DEL_BTN]forState:UIControlStateNormal];
        [self.deleteButton setTitle:NSLS(@"删除") forState:UIControlStateNormal];
    }
    
    if (![city.latestVersion isEqualToString:[[PackageManager defaultManager] getCityVersion:city.cityId]]) {
        CGRect rect = CGRectMake(0, 0, 16, 17);
        UIImageView *view = [[UIImageView alloc] initWithFrame:rect];
        [view setImage:[UIImage imageNamed:IMAGE_CITY_REFRESH_BTN]];
        
        [self.updateButton addSubview:view];
    }
    
    
    
}


- (void)dealloc {
    [cityNameLabel release];
    [updateButton release];
    [deleteButton release];
    [dataSizeLabel release];
    [dataSizeLabel release];
    [cityNameLabel release];
    [super dealloc];
}
@end
