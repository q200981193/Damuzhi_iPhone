//
//  DownloadListCell.m
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "DownloadListCell.h"
#import "AppUtils.h"
#import "PPDebug.h"
#import "ImageName.h"
#import "LocalCityManager.h"
#import "LocaleUtils.h"
#import "Reachability.h"

#define NO_DOWNLOAD 0
#define DOWNLOAD 1
#define FINISH_DOWNLOAD 2

@implementation DownloadListCell

@synthesize city = _city;
@synthesize downloadFlagButton;
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

- (void)setCellAppearance
{
    LocalCity *localCity = [[LocalCityManager defaultManager] getLocalCity:_city.cityId];
    [self setCellAppearance:localCity];
}

+ (NSString*)getCellIdentifier
{
    return @"DownloadListCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}

- (void)setCellData:(City*)city
{
    self.city = city;    
    self.cityNameLabel.text = [[city.countryName stringByAppendingString:NSLS(@".")] stringByAppendingString:city.cityName];
    float dataSize = city.dataSize/1024.0/1024.0;
    self.dataSizeLabel.text = [[NSString alloc] initWithFormat:@"%0.1fM", dataSize];
    [self setCellAppearance];

    return;
}

- (IBAction)clickDownload:(id)sender {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
        // user is using Mobile Network
        NSString *message = NSLS(@"您现在使用非WIFI网络下载，将会占用大量流量，是否继续下载?");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:NSLS(message) delegate:self cancelButtonTitle:NSLS(@"取消") otherButtonTitles:@"确定",nil];
        [alert show];
        [alert release];
    }
    else {
        [[AppService defaultService] downloadCity:_city];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    PPDebug(@"click button %d", buttonIndex);
    if (buttonIndex == 1) {
//        PPDebug(@"download city = %d", _city.cityId);
        [[AppService defaultService] downloadCity:_city];
    }
}


- (IBAction)clickPauseBtn:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        //TODO, pause download request
        [[AppService defaultService] pauseDownloadCity:_city];
    }
    else {
        //TODO, resume download request
        if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN){
            // user is using Mobile Network
            NSString *message = NSLS(@"您现在使用非WIFI网络下载，将会占用大量流量，是否继续下载?");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"提示") message:NSLS(message) delegate:self cancelButtonTitle:NSLS(@"取消") otherButtonTitles:@"确定",nil];
            [alert show];
            [alert release];
        }
        else {
            [[AppService defaultService] downloadCity:_city];
        }
    }
}

- (void)dealloc {
    [_city release];
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
    [downloadDoneLabel release];
    [pauseDownloadBtn release];
    [cancelDownloadBtn release];
    [moreDetailBtn release];
    [super dealloc];
}

- (IBAction)clickCancel:(id)sender {
    [[AppService defaultService] cancelDownloadCity:_city];
    self.pauseDownloadBtn.selected = NO;
}

- (void)setCellAppearance:(LocalCity*)localCity
{ 
    if(localCity == nil)
    {
        [self setCellAppearance:NO_DOWNLOAD localCity:localCity];
        return;
    }
    
    if (localCity.downloadDoneFlag == NO) {
        [self setCellAppearance:DOWNLOAD localCity:localCity];
    }
    else {
        [self setCellAppearance:FINISH_DOWNLOAD localCity:localCity];
    }
}

- (void)setCellAppearance:(int)downloadStatus localCity:(LocalCity*)localCity
{
    switch (downloadStatus) {
        case NO_DOWNLOAD:
            [self.downloadFlagButton setImage:[UIImage imageNamed:IMAGE_CITY_DOWNLOADED_NO] forState:UIControlStateNormal];   
            [self.cityNameLabel setTextColor:[UIColor darkGrayColor]];
            self.dataSizeLabel.hidden = NO;
            self.downloadProgressView.hidden = YES;
            self.downloadPersentLabel.hidden = YES;
            self.pauseDownloadBtn.hidden = YES;
            
            self.downloadButton.hidden = NO;
            self.cancelDownloadBtn.hidden = YES;
            self.onlineButton.hidden = NO;
            
            self.downloadDoneLabel.hidden = YES;
            self.moreDetailBtn.hidden = YES;
            break;
            
        case DOWNLOAD:
            [self.downloadFlagButton setImage:[UIImage imageNamed:IMAGE_CITY_DOWNLOADED_NO] forState:UIControlStateNormal]; 
            [self.cityNameLabel setTextColor:[UIColor darkGrayColor]];
            self.dataSizeLabel.hidden = YES;
            self.downloadProgressView.hidden = NO;
            self.downloadPersentLabel.hidden = NO;
            self.pauseDownloadBtn.hidden = NO;
            
            self.downloadButton.hidden = YES;
            self.cancelDownloadBtn.hidden = NO;
            self.onlineButton.hidden = NO;
            
            self.downloadDoneLabel.hidden = YES;
            self.moreDetailBtn.hidden = YES;
            
            self.pauseDownloadBtn.selected = !localCity.downloadingFlag;
            self.downloadProgressView.progress = localCity.downloadProgress;
            float persent = localCity.downloadProgress*100;
            self.downloadPersentLabel.text = [NSString stringWithFormat:@"%2.f%%", persent];
            
            break;
            
        case FINISH_DOWNLOAD:
            [self.downloadFlagButton setImage:[UIImage imageNamed:IMAGE_CITY_DOWNLOADED_YES] forState:UIControlStateNormal]; 
            [self.cityNameLabel setTextColor:[UIColor redColor]];
            self.dataSizeLabel.hidden = NO;
            self.downloadProgressView.hidden = YES;
            self.downloadPersentLabel.hidden = YES;
            self.pauseDownloadBtn.hidden = YES;
            
            self.downloadButton.hidden = YES;
            self.cancelDownloadBtn.hidden = YES;
            self.onlineButton.hidden = YES;
            
            self.downloadDoneLabel.hidden = NO;
            self.moreDetailBtn.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (IBAction)clickOnlineBtn:(id)sender {
}

@end
