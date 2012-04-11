//
//  RouteCell.m
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteCell.h"
#import "AppUtils.h"
#import "PPApplication.h"

@implementation RouteCell

#pragma mark -
#pragma mark: implementation of PPTableViewCellProtocol
@synthesize imageView;
@synthesize titleLabel;
@synthesize briefIntroLabel;

+ (NSString*)getCellIdentifier
{
    return @"RouteCell";
}

#pragma mark -
#pragma mark: Customize the appearance of cell.
- (void)setCellData:(CommonTravelTip*)tip
{
    titleLabel.text = tip.name;
    briefIntroLabel.text = tip.briefIntro;
    [self setTipImage:tip];
}

- (void)setTipImage:(CommonTravelTip*)tip
{
    [imageView showLoadingWheel];
    
    [imageView setImage:[UIImage imageNamed:@"heart.png"]];
    
    if (![tip.image hasPrefix:@"http"]){
        // local files, read image locally
        NSString *imagePath = [[AppUtils getCityDataDir:tip.cityId] stringByAppendingPathComponent:tip.image];
        [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
    }
    else{
        imageView.callbackOnSetImage = self;
        [imageView clear];
        imageView.url = [NSURL URLWithString:tip.image];
        //        PPDebug(@"load place image from URL %@", [place icon]);
        [GlobalGetImageCache() manage:imageView];
    }
}

-(void) managedImageSet:(HJManagedImageV*)mi
{
}

-(void) managedImageCancelled:(HJManagedImageV*)mi
{
}

- (void)dealloc {
    [imageView release];
    [titleLabel release];
    [briefIntroLabel release];
    [super dealloc];
}
@end
