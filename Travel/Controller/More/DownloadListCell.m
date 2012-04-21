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
#import "Reachability.h"
#import "SSZipArchive.h"

@implementation DownloadListCell
@synthesize cityNameLabel;
@synthesize updateButton;
@synthesize deleteButton;
@synthesize dataSizeLabel;
@synthesize defaultLabel;
@synthesize updateProgressView;
@synthesize updatePercentLabel;
@synthesize pauseBtn;
@synthesize activityIndicator;

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
    
    [updateProgressView release];
    [pauseBtn release];
    [activityIndicator release];
    [updatePercentLabel release];
    [super dealloc];
}

- (void)setCellData:(City*)city
{
    self.city = city;
    
    self.cityNameLabel.text = [NSString stringWithFormat:NSLS(@"%@.%@"), _city.countryName, _city.cityName];
    [self.defaultLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMAGE_CITY_DEFAULT_BTN]]];

    if (DEFAULT_CITY_ID == _city.cityId) {
        self.deleteButton.hidden = YES;
        self.defaultLabel.hidden = NO;
     }
    else {
        self.deleteButton.hidden = NO;
        self.defaultLabel.hidden = YES;
    }
        
    [self setApperance:city];
}

- (void)setApperance:(City*)city
{
    LocalCity *localCity = [[LocalCityManager defaultManager] getLocalCity:city.cityId];
    
    switch (localCity.updateStatus) {
        case UPDATING:            
        case UPDATE_PAUSE:
            [self setUpdateAppearance:localCity];
            break;
            
        default:
            [self setDefaultAppearance];          
            break;
    }
}

- (void)setDefaultAppearance
{
    dataSizeLabel.hidden = NO;
    self.dataSizeLabel.text = [self getCityDataSizeString];
    
    if ([_city.latestVersion isEqualToString:[[PackageManager defaultManager] getCityVersion:_city.cityId]]) {
        updateButton.hidden = YES;
    }
    else {
        updateButton.hidden = NO;
    }
    
    updateProgressView.hidden = YES;
    updatePercentLabel.hidden = YES;
    pauseBtn.hidden = YES;
    activityIndicator.hidden = YES;   
}

- (void)setUpdateAppearance:(LocalCity*)localCity
{
    dataSizeLabel.hidden = YES;
    updateButton.hidden = YES;
    
    updateProgressView.hidden = NO;
    updatePercentLabel.hidden = NO;
    [self setupdateProgress:localCity.downloadProgress];
    
    pauseBtn.hidden = NO;
    
    if (localCity.updateStatus == UPDATING) {
        pauseBtn.selected = NO;
        activityIndicator.hidden = NO;  
    }
    else {
        pauseBtn.selected = YES;
        activityIndicator.hidden = YES;            
    }
}

                                       
- (void)setupdateProgress:(float)progress
{
    updateProgressView.progress = progress;
    float persent = progress*100;
    updatePercentLabel.text = [NSString stringWithFormat:@"%2.f%%", persent];
}

- (NSString*)getCityDataSizeString
{
    return [NSString stringWithFormat:@"%0.2fM", _city.dataSize/1024.0/1024.0];
}

#define DELETE_BTN_ALERT 1
#define UPDATE_BTN_ALERT 2

- (IBAction)clickDeleteBtn:(id)sender {
    //TODO: delete city
    NSString *message = NSLS(@"删除城市数据后再次打开需要重新下载，确认删除?");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:NSLS(message) delegate:self cancelButtonTitle:NSLS(@"取消") otherButtonTitles:@"确定",nil];
    alert.tag = DELETE_BTN_ALERT;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case DELETE_BTN_ALERT:
            if (buttonIndex == 1) {
                [self dealWithDeleteAlert];
            }
            break;
            
        case UPDATE_BTN_ALERT:
            
            break;
        default:
            break;
    }
}

- (void)dealWithDeleteAlert
{
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

- (IBAction)clickUpdateBtn:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
        // user is using Mobile Network
        NSString *message = NSLS(@"您现在使用非WIFI网络下载，将会占用大量流量，是否继续下载?");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:NSLS(message) delegate:self cancelButtonTitle:NSLS(@"取消") otherButtonTitles:@"确定",nil];
        [alert show];
        [alert release];
    }
    else {
        // Download city data.
        [[CityDownloadService defaultService] update:_city delegate:self];
        
        // Call delegate method to do some addition work.
        if (_downloadListCellDelegate && [_downloadListCellDelegate respondsToSelector:@selector(didStartUpdate:)]) {
            [_downloadListCellDelegate didStartUpdate:_city];
        } 
    }
}


@end
