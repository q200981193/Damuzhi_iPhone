//
//  NearByRecommendController.h
//  Travel
//
//  Created by gckj on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PPViewController.h"
#import "PlaceService.h"

@class Place;

@interface NearByRecommendController : PPViewController <MKMapViewDelegate,PlaceServiceDelegate>
{
    UIView *buttomView;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) Place *place;
@property (retain, nonatomic) NSMutableArray *placeList;
//@property (assign, nonatomic) id <MKAnnotation> annotationToSelect;

- (NearByRecommendController*)initWithPlace:(Place*)place;

@end
