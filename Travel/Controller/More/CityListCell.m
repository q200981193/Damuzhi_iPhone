//
//  DownloadListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CityListCell.h"
#import "AppUtils.h"
#import "PPDebug.h"
#import "ImageName.h"
#import "LocalCityManager.h"
#import "LocaleUtils.h"
#import "Reachability.h"
#import "CityDownloadService.h"
#import "SSZipArchive.h"
#import "AppConstants.h"

@implementation CityListCell

@synthesize city = _city;
@synthesize cityListCellDelegate = _cityListCellDelegate;
@synthesize selectCurrentCityBtn;
@synthesize dataSizeLabel;
@synthesize downloadProgressView;
@synthesize downloadPersentLabel;
@synthesize pauseDownloadBtn;
@synthesize downloadButton;
@synthesize onlineButton;
@synthesize cancelDownloadBtn;
@synthesize cityNameLabel;
@synthesize downloadDoneLabel;
@synthesize moreDetailBtn;

#pragma mark -
#pragma mark: 
- (void)dealloc {
    [_city release];
    [downloadProgressView release];
    [downloadPersentLabel release];
    [downloadButton release];
    [onlineButton release];
    [cityNameLabel release];
    [dataSizeLabel release];
    [downloadPersentLabel release];
    [downloadDoneLabel release];
    [pauseDownloadBtn release];
    [cancelDownloadBtn release];
    [moreDetailBtn release];
    [selectCurrentCityBtn release];
    [super dealloc];
}

#pragma mark -
#pragma mark: implementation of PPTableViewCellProtocol
+ (NSString*)getCellIdentifier
{
    return @"CityListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}


#pragma mark -
#pragma mark: Customize the appearance of cell.
- (void)setCellData:(City*)city
{
    self.city = city;    
    self.selectCurrentCityBtn.selected = ([[AppManager defaultManager] getCurrentCityId] == _city.cityId); 
    self.cityNameLabel.text = [NSString stringWithFormat:NSLS(@"%@.%@"), _city.countryName, _city.cityName];
    self.cityNameLabel.textColor = ([[AppManager defaultManager] getCurrentCityId] == _city.cityId)?[UIColor redColor]:[UIColor darkGrayColor];
    self.dataSizeLabel.text = [self getCityDataSizeString];
    self.downloadDoneLabel.textColor = [UIColor darkGrayColor];
    
    [self setCellAppearance];
    return;
}

- (NSString*)getCityDataSizeString
{
    return [NSString stringWithFormat:@"%0.2fM", _city.dataSize/1024.0/1024.0];
}

- (void)setCellAppearance
{ 
    LocalCity *localCity = [[LocalCityManager defaultManager] getLocalCity:_city.cityId];
    
    if(localCity==nil)
    {
        [self setDefaultAppearance];
        return;
    }
    else {
        [self setDownloadAppearance:localCity];
    }
}

- (void)setDefaultAppearance
{
    dataSizeLabel.hidden = NO;
    downloadProgressView.hidden = YES;
    downloadPersentLabel.hidden = YES;
    pauseDownloadBtn.hidden = YES;
    
    if (_city.dataSize == 0) {
        downloadButton.hidden = YES;
    }
    else {
        downloadButton.hidden = NO;
    }
    cancelDownloadBtn.hidden = YES;
    onlineButton.hidden = NO;
    
    downloadDoneLabel.hidden = YES;
    moreDetailBtn.hidden = YES;
}

- (void)setDownloadAppearance:(LocalCity*)localCity
{
    switch (localCity.downloadStatus) {
        case DOWNLOADING:
        case DOWNLOAD_PAUSE:
            [self setDownloadingAppearance:localCity];
            break;
            
        case DOWNLOAD_SUCCEED:
            if ([AppUtils hasLocalCityData:localCity.cityId]) {
                [self setDownloadSuccessAppearance];
            }
            else {
                [self setDefaultAppearance];
            }
            break;
            
        case DOWNLOAD_FAILED:
            [self setDefaultAppearance];
            break;
            
        default:
            break;
    }
}

- (void)setDownloadingAppearance:(LocalCity*)localCity
{
    dataSizeLabel.hidden = YES;
    downloadProgressView.hidden = NO;
    downloadPersentLabel.hidden = NO;
    pauseDownloadBtn.hidden = NO;
    
    downloadButton.hidden = YES;
    cancelDownloadBtn.hidden = NO;
    onlineButton.hidden = NO;
    
    downloadDoneLabel.hidden = YES;
    moreDetailBtn.hidden = YES;
    
    if (localCity.downloadStatus == DOWNLOADING) {
        pauseDownloadBtn.selected = NO;
    }
    else if(localCity.downloadStatus == DOWNLOAD_PAUSE){
        pauseDownloadBtn.selected = YES;
    }
    
    [self setDownloadProgress:localCity.downloadProgress];
}

- (void)setDownloadProgress:(float)downloadProgress
{
    downloadProgressView.progress = downloadProgress;
    float persent = downloadProgress*100;
    downloadPersentLabel.text = [NSString stringWithFormat:@"%2.f%%", persent];
}

- (void)setDownloadSuccessAppearance
{
    dataSizeLabel.hidden = NO;
    downloadProgressView.hidden = YES;
    downloadPersentLabel.hidden = YES;
    pauseDownloadBtn.hidden = YES;
    
    downloadButton.hidden = YES;
    cancelDownloadBtn.hidden = YES;
    onlineButton.hidden = YES;
    
    downloadDoneLabel.hidden = NO;
    moreDetailBtn.hidden = NO;
}

#pragma mark -
#pragma mark: Imlementation for buttons event.
- (IBAction)clickDownload:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
        [AppUtils showUsingCellNetworkAlertViewWithTag:ALERT_USING_CELL_NEWORK delegate:self];
    }
    else {
        [self download];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case ALERT_USING_CELL_NEWORK:
            if (buttonIndex == 1) {
                [self download];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)clickPauseBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [self pause];
    }
    else {
        //TODO, resume download request
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
            // user is using Mobile Network
            [AppUtils showUsingCellNetworkAlertViewWithTag:ALERT_USING_CELL_NEWORK delegate:self];
        }
        else {
            [self download];
        }
    }
}

- (void)pause
{
    //TODO, pause download request
    [[CityDownloadService defaultService] pause:_city];
    
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didPauseDownload:)]) {
        [_cityListCellDelegate didPauseDownload:_city];
    }
}

- (void)download
{
    // Download city data.
    [[CityDownloadService defaultService] download:_city delegate:self];
    
    // Call delegate method to do some addition work.
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didStartDownload:)]) {
        [_cityListCellDelegate didStartDownload:_city];
    } 
}

- (IBAction)clickCancel:(id)sender {
    [[CityDownloadService defaultService] cancel:_city];
    
    self.pauseDownloadBtn.selected = NO;
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didCancelDownload:)]) {
        [_cityListCellDelegate didCancelDownload:_city];
    }
}

- (IBAction)clickOnlineBtn:(id)sender {
    [self selectCurrentCity];
    
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didClickOnlineBtn:)]) {
        [_cityListCellDelegate didClickOnlineBtn:_city];
    }
}

- (IBAction)clickCurrentCityBtn:(id)sender {
    [self selectCurrentCity];
}

- (void)selectCurrentCity
{
    if (_city.cityId == [[AppManager defaultManager] getCurrentCityId]) {
        return;
    }
    
    // Set current cityId.
    [[AppManager defaultManager] setCurrentCityId:_city.cityId];
    
    // Call delegate metchod to do some addition work.
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didSelectCurrendCity:)]) {
        [_cityListCellDelegate didSelectCurrendCity:_city];
    }
}

- (void)didFinishDownload:(City*) city
{
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didFinishDownload:)]) {
        [_cityListCellDelegate didFinishDownload:city];
    }    
}

- (void)didFailDownload:(City*)city error:(NSError *)error;
{
    if (_cityListCellDelegate && [_cityListCellDelegate respondsToSelector:@selector(didFailDownload:error:)]) {
        [_cityListCellDelegate didFailDownload:city error:error];
    }
}

@end
