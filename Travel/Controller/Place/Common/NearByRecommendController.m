//
//  NearByRecommendController.m
//  Travel
//
//  Created by gckj on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceMapAnnotation.h"
#import "Place.pb.h"
#import "CommonPlaceDetailController.h"
#import "AppUtils.h"
#import "UIImageUtil.h"
#import "App.pb.h"
#import "PPDebug.h"
#import "MapUtils.h"

@implementation NearByRecommendController

@synthesize mapView;
@synthesize placeList = _placeList;
@synthesize place = _place;
//@synthesize annotationToSelect;

- (NearByRecommendController*)initWithPlace:(Place*)place
{
    if (self = [super init]) {
        self.place = place;
    }
    
    return self;
}

- (void) loadAllAnnotations
{ 
    NSMutableArray *mapAnnotations = [[NSMutableArray alloc] init];
    
    for (Place *place in _placeList) {
        if ([MapUtils isValidLatitude:[place latitude] Longitude:[place longitude]]) {
            PlaceMapAnnotation *placeAnnotation = [[PlaceMapAnnotation alloc] initWithPlace:place];
            [mapAnnotations addObject:placeAnnotation];
            [placeAnnotation release];
        }
    } 
    
    [self.mapView removeAnnotations:mapView.annotations];
    [self.mapView addAnnotations:mapAnnotations];
    [mapAnnotations release];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.ShowsUserLocation = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.mapView.ShowsUserLocation = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self.navigationItem setTitle:NSLS(@"周边推荐")];
    
    mapView.delegate = self;
    mapView.mapType = MKMapTypeStandard; 
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0, 0.0);
    [MapUtils setMapSpan:mapView span:span];    
    [MapUtils gotoLocation:mapView latitude:_place.latitude longitude:_place.longitude];
    
    self.placeList = [[[NSMutableArray alloc] init] autorelease];
    
    [self addMyLocationBtnTo:self.view];
    
    // Find places nearby.
    [[PlaceService defaultService] findPlacesNearby:PlaceCategoryTypePlaceAll 
                                              place:_place 
                                           distance:10.0     
                                     viewController:self];
}

- (void)findRequestDone:(int)result placeList:(NSArray *)placeList
{
    [_placeList addObject:_place];

    for (Place *place in placeList) {
        [_placeList addObject:place];
    }
    
    [self loadAllAnnotations];
}

- (void)dealloc
{
    [_placeList release];
    [_place release];
    PPRelease(mapView);
//    [mapView release];
//    [annotationToSelect release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    mapView = nil;
//    annotationToSelect = nil;
    _place = nil;
    _placeList = nil;
}

//The event handling method
- (void)notationAction:(id)sender
{        
    UIButton *button = sender;
    NSInteger index = button.tag;
    
    int count = [_placeList count];
    if (index<0 || index>count-1) {
        PPDebug(@"WARRING:index you click is out of range!");
        return;
    }
    
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc] initWithPlace:[_placeList objectAtIndex:index]];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
#define  RED_GLASS_VIEW 20120510

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
    
    // handle our custom annotations
    if([annotation isKindOfClass:[PlaceMapAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* annotationIdentifier = @"mapAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        if (pinView == nil)
        {
            MKAnnotationView* annotationView = [[[MKAnnotationView alloc]
                                                 initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
            PlaceMapAnnotation *placeAnnotation = (PlaceMapAnnotation*)annotation;
             ;            
//            UIButton *customizeView;
            
            //判断placeAnnotation是否为当前地点，是则显示红色长方块背景
            if (placeAnnotation.place == _place )
            {
                MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                       initWithAnnotation:annotation reuseIdentifier:[annotation title]] autorelease];
//                annotationToSelect = annotation;
                customPinView.pinColor = MKPinAnnotationColorRed;
                customPinView.animatesDrop = YES;
                customPinView.canShowCallout = YES;
                
                UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                [rightButton addTarget:self
                                action:@selector(notationAction:)
                      forControlEvents:UIControlEventTouchUpInside];
                customPinView.rightCalloutAccessoryView = rightButton;
                
                NSInteger tag = [_placeList indexOfObject:placeAnnotation.place];
                customPinView.tag = tag;
                
                [theMapView selectAnnotation:annotation animated:YES];
                
                return customPinView;
            }
            else
            {                
                
                NSInteger tag = [_placeList indexOfObject:placeAnnotation.place];
                NSString *fileName = [AppUtils getCategoryPinIcon:placeAnnotation.place.categoryId];
                [MapUtils showCallout:annotationView imageName:fileName tag:tag target:self];

            }
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
        
    }
    
    return nil;
}

//- (void)mapView:(MKMapView *)mapview didAddAnnotationViews:(NSArray *)views
//{
//    for (id<MKAnnotation> currentAnnotation in mapview.annotations) {       
//        if ([currentAnnotation isEqual: annotationToSelect]) {
//            [mapview selectAnnotation:currentAnnotation animated:YES];
//        }
//    }
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

- (void)clickMyLocationBtn
{
    [MapUtils gotoLocation:mapView latitude:mapView.userLocation.location.coordinate.latitude longitude:mapView.userLocation.location.coordinate.longitude];
}

- (void)addMyLocationBtnTo:(UIView*)view
{
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-31, view.frame.size.height-31, 31, 31)];    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];            
    
    [button setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickMyLocationBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button release];
}


@end
