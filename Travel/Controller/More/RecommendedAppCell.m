//
//  RouteCell.m
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RecommendedAppCell.h"
#import "AppUtils.h"
#import "PPApplication.h"
#import "AppUtils.h"

@implementation RecommendedAppCell

#pragma mark -
#pragma mark: implementation of PPTableViewCellProtocol
@synthesize imageView;
@synthesize titleLabel;
@synthesize briefIntroLabel;

+ (NSString*)getCellIdentifier
{
    return @"RecommendedAppCell";
}

#pragma mark -
#pragma mark: Customize the appearance of cell.
- (void)setCellData:(RecommendedApp*)app
{
    titleLabel.text = app.name;
    briefIntroLabel.text = app.description;
    briefIntroLabel.textColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255 alpha:1];
    [imageView.layer setCornerRadius:5.0f];
    [imageView.layer setMasksToBounds:YES];
    [self setAppIcon:app];
}

- (void)setAppIcon:(RecommendedApp*)app
{
    [imageView showLoadingWheel];
    [imageView setImage:[UIImage imageWithContentsOfFile:[AppUtils getRecommendedAppIconPath:app.id]]];
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
