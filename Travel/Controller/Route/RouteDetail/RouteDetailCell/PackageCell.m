//
//  PackageCell.m
//  Travel
//
//  Created by 小涛 王 on 12-7-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PackageCell.h"
#import "LocaleUtils.h"

#define EDGE 5

#define FONT_DURATION_LABEL [UIFont systemFontOfSize:13]
#define TEXT_COLOR_DURATION_LABEL [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1]

#define FONT_HOTEL_NAME_LABEL [UIFont systemFontOfSize:13]
#define TEXT_COLOR_HOTEL_NAME_LABEL [UIColor colorWithRed:37.0/255.0 green:66.0/255.0 blue:80.0/255.0 alpha:1]

@interface PackageCell ()

@end

@implementation PackageCell


@synthesize flightButton;

+ (CGFloat)getCellHeight
{
    return 78;
}

+ (NSString *)getCellIdentifier
{
    return @"PackageCell";
}

- (void)setCellData:(TravelPackage *)package
{
    NSString *flight = [NSString stringWithFormat:NSLS(@"往：%@%@ 返：%@%@"), package.departFlight.company, package.departFlight.mode];
    [flightButton setTitle:flight forState:UIControlStateNormal];
    
    CGFloat originX = self.frame.size.width/2 - flightButton.frame.size.width/2;
    CGFloat originY = flightButton.frame.origin.y + flightButton.frame.size.height + EDGE;    
    CGFloat width = flightButton.frame.size.width;
    CGFloat height = 42;
    
    CGRect frame = CGRectMake(originX, originY, width, height);
    for (Accommodation *accommodation in package.accommodationsList) {
        UIView *view = [self acommodationViewWithFrame:frame accommodation:accommodation];
        [self addSubview:view];
        
        originY += height + EDGE;
        frame = CGRectMake(originX, originY , width, height);
    }
}


- (UIView *)acommodationViewWithFrame:(CGRect)frame
                        accommodation:(Accommodation *)accommodation
{    
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    
    [button setBackgroundImage:[UIImage imageNamed:@"line_tr2.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(clickAcommodation:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = accommodation.hotelId;
    
    CGRect rect = CGRectMake(frame.origin.x + 30, 0, frame.size.width - 32, frame.size.height/2);
    UILabel *durationLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.text =  accommodation.duration;
    durationLabel.font = FONT_DURATION_LABEL;
    durationLabel.textColor = TEXT_COLOR_DURATION_LABEL;
    
    [button addSubview:durationLabel];
    
    rect = CGRectMake(durationLabel.frame.origin.x, durationLabel.frame.origin.y+durationLabel.frame.size.height, durationLabel.frame.size.width, durationLabel.frame.size.height);
    
    UILabel *hotelNameLabel = [[[UILabel alloc] initWithFrame:rect] autorelease];
    hotelNameLabel.backgroundColor = [UIColor clearColor];
    hotelNameLabel.text =  accommodation.hotelName;
    hotelNameLabel.font = FONT_HOTEL_NAME_LABEL;
    hotelNameLabel.textColor = TEXT_COLOR_HOTEL_NAME_LABEL;
    [button addSubview:hotelNameLabel];
    
    return button;
}

- (void)clickAcommodation:(id)sender
{
    
}


- (void)dealloc {
    [flightButton release];
    [super dealloc];
}

@end
