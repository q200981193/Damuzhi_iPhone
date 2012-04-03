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

@class Place;

@interface NearByRecommendController : PPViewController <MKMapViewDelegate,CLLocationManagerDelegate>
{
    MKMapView *mapView;
    NSArray* _placeList;
    CLLocationManager* _locationManager;
}

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSArray* placeList;
@property (nonatomic, assign) NSInteger indexOfSelectedPlace;
@property (nonatomic, retain) NSMutableArray* mapAnnotations;
@property (nonatomic, retain) UIViewController* superController;

- (void)setPlaces:(NSArray*)placeList;
- (void)setPlaces:(NSArray*)placeList selectedIndex:(NSInteger)index;
- (void)gotoLocation:(Place*)place;

@end
