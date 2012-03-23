/*
     File: MapViewController.m 
 Abstract: The primary view controller containing the MKMapView, adding and removing both MKPinAnnotationViews through its toolbar. 
  Version: 1.0 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2010 Apple Inc. All Rights Reserved. 
  
 */

#import "PlaceMapViewController.h"
#import "PlaceMapAnnotation.h"
#import "Place.pb.h"

@implementation PlaceMapViewController

@synthesize mapView;
@synthesize mapAnnotations;
@synthesize locationManager = _locationManager;
@synthesize placeList = _placeList;

- (void)gotoLocation:(Place*)place
{
    MKCoordinateRegion newRegion;
    // start off by default in San Francisco
//    newRegion.center.latitude = 37.786996;
//    newRegion.center.longitude = -122.440100;
    newRegion.center.latitude = [place latitude];
    newRegion.center.longitude = [place longitude];
    //设置地图的范围，越小越精确  
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;

    [self.mapView setRegion:newRegion animated:YES];
}

- (void)gotoPlaceWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = coordinate.latitude ;
    newRegion.center.longitude = coordinate.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    [self.mapView setRegion:newRegion animated:YES];
}


- (void)gotoCurrentPosition
{
    //开始探测自己的位置  
    if (_locationManager==nil)   
    {  
        _locationManager =[[CLLocationManager alloc] init];  
    }  
    
    
    if ([CLLocationManager locationServicesEnabled])   
    {  
        _locationManager.delegate=self;  
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;  
        _locationManager.distanceFilter=10.0f;  
        [_locationManager startUpdatingLocation];  
    }  
    
    MKCoordinateRegion theRegion = { {0.0, 0.0 }, { 0.0, 0.0 } };
    theRegion.center = [[_locationManager location] coordinate];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    theRegion.span.latitudeDelta = 0.112872;
    theRegion.span.longitudeDelta = 0.109863;
    [mapView setRegion:theRegion animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    // bring back the toolbar
    [self.navigationController setToolbarHidden:NO animated:NO];
}


- (Place*)buildTestPlace:(NSString*)placeTag
{
    Place_Builder* builder = [[[Place_Builder alloc] init] autorelease];
    
    [builder setPlaceId:[placeTag intValue]];       
    [builder setCategoryId:1];
    [builder setSubCategoryId:1];
    [builder setRank:3];
    [builder setIntroduction:@"简介信息，待完善"];
    [builder setIcon:@"image.jpg"];
    [builder setAvgPrice:@"100"];
    [builder setOpenTime:@"早上10点到晚上10点"];
    [builder setLatitude:37.80000f];
    [builder setLongitude:-122.457989f];
    [builder setName:@"香港太平山"];
    [builder setPlaceFavoriteCount:12];
    [builder setPrice:@"$50"];
    [builder setPriceDescription:@"儿童免票，成人100元"];
    [builder setTips:@"缆车车费：单程HK$20"];
    [builder setTransportation:@"乘地铁从上环站到中环站"];
    [builder setWebsite:@"http://www.madametussauds.com"];
    [builder addTelephone:@"00852-28496966"];
    [builder addAddress:@"香港山顶道128号凌霄阁"];
    [builder addAreaId:11];
    [builder setCategoryId:1];
    [builder addProvidedServiceId:3];
    
    return [builder build];
}

- (void) loadAllAnnotations
{
    if (_placeList && _placeList.count > 0) {
        for (Place *place in _placeList) {
            PlaceMapAnnotation *placeAnnotation = [[[PlaceMapAnnotation alloc]initWithPlace:place] autorelease];
            [self.mapAnnotations addObject:placeAnnotation];
        } 
    }
    [self.mapView removeAnnotations:self.mapView.annotations];  
    [self.mapView addAnnotations:self.mapAnnotations];
    
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;   
    self.mapView.showsUserLocation = YES;
    self.mapAnnotations = [[[NSMutableArray alloc]init] autorelease];
    
    [self loadAllAnnotations];
    
//    Place *place = [self buildTestPlace:@"1"];
//    PlaceMapAnnotation *placeAnnotation = [[PlaceMapAnnotation alloc]initWithPlace:place];
//    [self.mapAnnotations addObject:placeAnnotation];

    //for test
//    CLLocationCoordinate2D location;
//    location.latitude = 37.80000;
//    location.longitude = -122.457989;
//    PlaceMapAnnotation *placeAnnotation = [[PlaceMapAnnotation alloc]initWithCoordinate:location];
//    [self.mapAnnotations addObject:placeAnnotation];
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    NSLog(@"didAddAnnotationViews");
    [self gotoLocation:[_placeList objectAtIndex:1]];
}

- (void)viewDidUnload
{
    self.mapAnnotations = nil;
    self.mapView = nil;
}

- (void)dealloc 
{
    [mapView release];
    [mapAnnotations release];
    
    [super dealloc];
}

- (void)setPlaces:(NSArray*)placeList
{
    self.placeList = placeList;
    [self loadAllAnnotations];
}

#pragma mark -
#pragma mark MKMapViewDelegate

//The event handling method
- (void)notationAction:(UITapGestureRecognizer *)recognizer {
    NSLog(@"click annotation handler here!");
    //Do stuff here...
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our custom annotations
    if([annotation isKindOfClass:[PlaceMapAnnotation class]])
    {
        // try to dequeue an existing pin view first
        static NSString* annotationIdentifier = @"mapAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView)
        {
            MKAnnotationView* annotationView = [[[MKAnnotationView alloc]
                                                 initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
            
            PlaceMapAnnotation *placeAnnotation = (PlaceMapAnnotation*)annotation;
            
            UIView *customizeView = [[UIView alloc] initWithFrame:CGRectMake(0,0,102,27)];
            [customizeView setBackgroundColor:[UIColor clearColor]];
            
            UIImage *image = [UIImage imageNamed:@"map_annotation_bg"];
            annotationView.image = image;            
            
            UIButton *leftIndicatorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftIndicatorButton setBackgroundImage:[UIImage imageNamed:@"map_food"] forState:UIControlStateNormal];
            [leftIndicatorButton setFrame:CGRectMake(5, 1.5, 13, 17)];
            [leftIndicatorButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            [customizeView addSubview:leftIndicatorButton];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 70, 17)];
            label.font = [UIFont systemFontOfSize:12];
            label.text  = [[placeAnnotation place]name];
            label.textColor = [UIColor colorWithWhite:255.0 alpha:1.0];
            label.backgroundColor = [UIColor clearColor];
            [customizeView addSubview:label];
            
            [annotationView addSubview:customizeView];
            
            UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(notationAction:)];
            [customizeView addGestureRecognizer:singleFingerTap];
            [singleFingerTap release];
            [customizeView release];
            
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

@end
