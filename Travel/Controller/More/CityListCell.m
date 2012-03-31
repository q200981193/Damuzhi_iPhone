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
#import "PPDebug.h"


@interface CityListCell ()

@end

@implementation CityListCell
@synthesize cityNameLabel;
@synthesize updateButton;
@synthesize deleteButton;
@synthesize dataSizeLabel;
@synthesize defaultLabel;

@synthesize cityCellDelegate;
@synthesize city = _city;

+ (NSString*)getCellIdentifier
{
    return @"CityListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}
#define TAG_DEFAULT 0
#define TAG_DELETE  1

- (void)setCellData:(City*)city
{
    self.city = city;
    self.cityNameLabel.text = [[city.countryName stringByAppendingString:NSLS(@".")] stringByAppendingString:city.cityName];
    
    float dataSize = city.dataSize/1024.0/1024.0;
    self.dataSizeLabel.text = [[NSString alloc] initWithFormat:@"%0.1fM", dataSize];
    
//    if ([[AppManager defaultManager] getCurrentCityId] == city.cityId) {

    if (NO) {
        self.deleteButton.hidden = YES;
        self.defaultLabel.hidden = NO;
        [self.defaultLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMAGE_CITY_DEFAULT_BTN]]];
     }
    else {
        self.deleteButton.hidden = NO;
        self.defaultLabel.hidden = YES;
    }
    
    if (![city.latestVersion isEqualToString:[[PackageManager defaultManager] getCityVersion:city.cityId]]) {
        CGRect rect = CGRectMake(0, 0, 16, 17);
        UIImageView *view = [[UIImageView alloc] initWithFrame:rect];
        [view setImage:[UIImage imageNamed:IMAGE_CITY_REFRESH_BTN]];
        
        [self.updateButton addSubview:view];
    }
}

- (IBAction)clickDeleteBtn:(id)sender {
    //TODO: delete city
    if ([self.cityCellDelegate respondsToSelector:@selector(deleteCity:)]) {
        [self.cityCellDelegate deleteCity:_city];
    }
    else {
        PPDebug(@"self.deletCityDelegate cannot respondsTo deleteCity");
    }
}

- (IBAction)clickUpdateBtn:(id)sender {
    //TODO: download a city package
    

}

- (void)dealloc {
    [cityNameLabel release];
    [updateButton release];
    [deleteButton release];
    [dataSizeLabel release];
    [dataSizeLabel release];
    [cityNameLabel release];
    [defaultLabel release];
    [_city release];
    
    [super dealloc];
}
@end
