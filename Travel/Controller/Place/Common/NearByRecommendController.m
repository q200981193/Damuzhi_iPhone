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
#import "Reachability.h"

@implementation NearByRecommendController

@synthesize mapView;
@synthesize placeList = _placeList;
@synthesize place = _place;

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
    
    [mapView removeAnnotations:mapView.annotations];
    [mapView addAnnotations:mapAnnotations];
    [mapAnnotations release];
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [AppUtils showAlertViewWhenLookingMapWithoutNetwork];
        return;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    mapView.showsUserLocation = NO;
    [super viewDidDisappear:animated];
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
//    mapView.ShowsUserLocation = YES;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.0, 0.0);
    [MapUtils setMapSpan:mapView span:span];    
    [MapUtils gotoLocation:mapView latitude:_place.latitude longitude:_place.longitude];
    
    self.placeList = [[[NSMutableArray alloc] init] autorelease];
    
    [self addMyLocationBtnTo:self.view];
    
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        [AppUtils showAlertViewWhenLookingMapWithoutNetwork];
        return;
    }
    
    // Find places nearby.
    [[PlaceService defaultService] findPlacesNearby:PlaceCategoryTypePlaceAll 
                                              place:_place 
                                           distance:10.0     
                                     viewController:self];
}

//- (void)clickBack:(id)sender
//{
//    mapView.showsUserLocation = NO;
//    [self.navigationController popViewControllerAnimated:YES];
//}

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
    PPRelease(_placeList);
    PPRelease(_place);
    PPRelease(mapView);
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    mapView = nil;
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

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // handle our custom annotations
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
        
    // handle our custom annotations
    if([annotation isKindOfClass:[PlaceMapAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* annotationIdentifier = @"mapAnnotationIdentifier2";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        
        if (pinView == nil)
        {
            MKAnnotationView* annotationView = [[[MKAnnotationView alloc]
                                                 initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
            PlaceMapAnnotation *placeAnnotation = (PlaceMapAnnotation*)annotation;
        
            //判断placeAnnotation是否为当前地点
            if (placeAnnotation.place == _place )
            {
                MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
                                                       initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
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

                
                // Note: on itouch4(iOS4.2.1) , it will run into crash. 
                // but on iphone4 and iphone4s(both ios5.1), it run just fine.
                // can you tell me why?
//                [theMapView selectAnnotation:annotation animated:YES];

                [self performSelector:@selector(selectAnnotation:) withObject:annotation afterDelay:0.3f];

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

- (void)selectAnnotation:(id <MKAnnotation>)annotation
{
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

- (void)clickMyLocationBtn:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.selected = !button.selected;
    if (button.selected) {
        mapView.showsUserLocation = YES;
        [MapUtils gotoLocation:mapView latitude:mapView.userLocation.location.coordinate.latitude longitude:mapView.userLocation.location.coordinate.longitude];
    }else {
        mapView.showsUserLocation = NO;
        [MapUtils gotoLocation:mapView latitude:_place.latitude longitude:_place.longitude];
    }
}

- (void)addMyLocationBtnTo:(UIView*)view
{
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width-31, view.frame.size.height-31, 31, 31)];    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 31, 31)];            
    
    [button setImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"locate_back.png"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickMyLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button release];
}


@end
