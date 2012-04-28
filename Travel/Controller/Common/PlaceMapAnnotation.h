//
//  PlaceMapAnnotation.h
//  Travel
//
//  Created by gckj on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.pb.h"

@interface PlaceMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, retain) Place *place;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;
- (id)initWithPlace:(Place*)place;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
