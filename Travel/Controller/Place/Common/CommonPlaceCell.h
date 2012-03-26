//
//  CommonPlaceCell.h
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@class Place;

@interface CommonPlaceCell : PPTableViewCell

+ (CommonPlaceCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;

// this method must be overrided by sub class
- (void)setCellDataByPlace:(Place*)place currentLocation:(CLLocation*)currentLocation;

@end
