//
//  PersonalInfoCell.m
//  Travel
//
//  Created by haodong on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PersonalInfoCell.h"

@implementation PersonalInfoCell
@synthesize backgroundImageVeiw;
@synthesize titleLabel;
@synthesize inputTextField;

- (void)dealloc {
    [titleLabel release];
    [inputTextField release];
    [backgroundImageVeiw release];
    [super dealloc];
}


#pragma mark: implementation of PPTableViewCellProtocol
+ (NSString*)getCellIdentifier
{
    return @"PersonalInfoCell";
}

+ (CGFloat)getCellHeight
{
    return 44.0f;
}




@end
