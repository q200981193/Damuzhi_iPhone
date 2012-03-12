//
//  PlaceMapAnnotation.m
//  Travel
//
//  Created by gckj on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceMapAnnotation.h"

@implementation PlaceMapAnnotation

@synthesize place;
@synthesize coordinate;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithPlace:(Place *)a_place
{
    place = a_place;
    coordinate.longitude = place.longitude;
    coordinate.latitude = place.latitude;
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;
{
    coordinate.longitude = coord.longitude;
    coordinate.latitude = coord.latitude;
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = 37.810000;
    theCoordinate.longitude = -122.477989;
    return theCoordinate; 
}


@end
