//
//  CityListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "DownloadListCell.h"
#import "AppManager.h"
#import "LocaleUtils.h"
#import "ImageName.h"
#import "PackageManager.h"
#import "PPDebug.h"
#import "AppConstants.h"
#import "AppUtils.h"
#import "LocalCityManager.h"

@implementation DownloadListCell
@synthesize cityNameLabel;
@synthesize updateButton;
@synthesize deleteButton;
@synthesize dataSizeLabel;
@synthesize defaultLabel;

@synthesize city = _city;
@synthesize downloadListCellDelegate = _downloadListCellDelegate;

+ (NSString*)getCellIdentifier
{
    return @"DownloadListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)dealloc {
    [cityNameLabel release];
    [updateButton release];
    [deleteButton release];
    [dataSizeLabel release];
    [defaultLabel release];
    [_city release];
    [_downloadListCellDelegate release];
    
    [super dealloc];
}

- (void)setCellData:(City*)city
{
    self.city = city;
    
    [self.defaultLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMAGE_CITY_DEFAULT_BTN]]];
    self.cityNameLabel.text = [NSString stringWithFormat:NSLS(@"%@.%@"), _city.countryName, _city.cityName];
    self.dataSizeLabel.text = [self getCityDataSizeString];

    if (DEFAULT_CITY_ID == _city.cityId) {
        self.deleteButton.hidden = YES;
        self.defaultLabel.hidden = NO;
     }
    else {
        self.deleteButton.hidden = NO;
        self.defaultLabel.hidden = YES;
    }
    
    if (![city.latestVersion isEqualToString:[[PackageManager defaultManager] getCityVersion:city.cityId]]) {
        CGRect rect = CGRectMake(0, 0, 16, 17);
        UIImageView *view = [[UIImageView alloc] initWithFrame:rect];
        [view setImage:[UIImage imageNamed:IMAGE_CITY_REFRESH_BTN]];
        view.center = CGPointMake(updateButton.frame.size.width/2, updateButton.frame.size.height/2);
        [self.updateButton addSubview:view];
        [view release];
        
        self.updateButton.hidden = NO;
    }
    else {
        self.updateButton.hidden = YES;
    }
}

- (NSString*)getCityDataSizeString
{
    return [NSString stringWithFormat:@"%0.2fM", _city.dataSize/1024.0/1024.0];
}

- (IBAction)clickDeleteBtn:(id)sender {
    //TODO: delete city
    NSString *message = NSLS(@"删除城市数据后再次打开需要重新下载，确认删除?");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:NSLS(message) delegate:self cancelButtonTitle:NSLS(@"取消") otherButtonTitles:@"确定",nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if ([_downloadListCellDelegate respondsToSelector:@selector(didDeleteCity:)]) {
            // Delete city data.
            [AppUtils deleteCityData:_city.cityId];
            // Remove local city info.
            [[LocalCityManager defaultManager] removeLocalCity:_city.cityId];
            
            // Call delegete method to do some addition work.
            if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didDeleteCity:)]) {
                [_downloadListCellDelegate didDeleteCity:_city];
            }
        }
        else {
            PPDebug(@"[_downloadListCellDelegate respondsToSelector:@selector(didDeleteCity:)]");
        }
    }
}

- (IBAction)clickUpdateBtn:(id)sender {
    //TODO: download a city package
    
    // Call delegete method to do some addition work.
    if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didUpdateCity:)]) {
        [_downloadListCellDelegate didUpdateCity:_city];
    }
    else {
        PPDebug(@"[_downloadListCellDelegate respondsToSelector:@selector(didUpdateCity:)]");
    }
}

@end
