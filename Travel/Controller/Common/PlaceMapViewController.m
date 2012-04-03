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
#import "CommonPlaceDetailController.h"
#import "AppUtils.h"

@implementation PlaceMapViewController

@synthesize mapView;
@synthesize locationManager = _locationManager;
@synthesize placeList = _placeList;
@synthesize mapAnnotations;
@synthesize indexOfSelectedPlace;
@synthesize superController;

- (BOOL)isRightLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    if (-90.0 <= latitude && latitude <= 90.0 &&  -180.0 <= longitude && longitude <= 180.0){
        return  YES;
    }else {
        return NO;
    }
}

- (void)gotoLocation:(Place*)place
{
    if (![self isRightLatitude:[place latitude] Longitude:[place longitude]]) {
        return;
    }
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [place latitude];
    newRegion.center.longitude = [place longitude];
    //设置地图的范围，越小越精确  
//    newRegion.span.latitudeDelta = 0.05;
//    newRegion.span.longitudeDelta = 0.05;
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
    [super viewDidAppear:animated];
}


- (void) loadAllAnnotations
{    
    [self.mapAnnotations removeAllObjects];
    if (_placeList && _placeList.count > 0) {
        for (Place *place in _placeList) {
            if ([self isRightLatitude:[place latitude] Longitude:[place longitude]]) {
                PlaceMapAnnotation *placeAnnotation = [[[PlaceMapAnnotation alloc]initWithPlace:place]autorelease];
                [self.mapAnnotations addObject:placeAnnotation];
//                NSLog(@"******load Annotations for coordinate: %f,%f",[place latitude],[place longitude]);
            }
            
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
//    self.mapView.showsUserLocation = YES;
    self.mapAnnotations = [[NSMutableArray alloc]init];
    [self loadAllAnnotations];
    
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];

}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
//    NSLog(@"didAddAnnotationViews");
    [self gotoLocation:[_placeList objectAtIndex:0]];
}

- (void)viewDidUnload
{
    self.mapView = nil;
    self.mapAnnotations = nil;
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
- (void)notationAction:(id)sender
{        
    UIButton *button = sender;
    NSInteger index = button.tag;
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc]initWithPlace:[_placeList objectAtIndex:index]];
    [self.superController.navigationController pushViewController:controller animated:YES];
    [controller release];
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
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]]autorelease];
        if (pinView == nil)
        {
            MKAnnotationView* annotationView = [[[MKAnnotationView alloc]
                                                 initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
            PlaceMapAnnotation *placeAnnotation = (PlaceMapAnnotation*)annotation;
            UIButton *customizeView = [[UIButton alloc] initWithFrame:CGRectMake(0,0,102,27)];
            [customizeView setBackgroundColor:[UIColor clearColor]];
            
            UIImage *image = [UIImage imageNamed:@"map_button"];
            annotationView.image = image;            
            
            UIButton *leftIndicatorButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 1.5, 13, 17)];            
   
            NSString *destinationDir = [AppUtils getCategoryImageDir];
            NSString *fileName = [[NSString alloc] initWithFormat:@"%d.png",placeAnnotation.place.categoryId];
            UIImage *icon = [[UIImage alloc] initWithContentsOfFile:[destinationDir stringByAppendingPathComponent:fileName]];
            
            [leftIndicatorButton setBackgroundImage:icon forState:UIControlStateNormal];
            [leftIndicatorButton addTarget:self action:@selector(notationAction:) forControlEvents:UIControlEventTouchUpInside];
            [customizeView addSubview:leftIndicatorButton];
            [leftIndicatorButton release];
            [icon release];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 80, 17)];
            label.font = [UIFont systemFontOfSize:12];
            label.text  = [placeAnnotation.place name];
            NSInteger value = [self.placeList indexOfObject:placeAnnotation.place];
            label.textColor = [UIColor colorWithWhite:255.0 alpha:1.0];
            label.backgroundColor = [UIColor clearColor];
            [customizeView addSubview:label];
            [label release];
            
            customizeView.tag = value;
            [customizeView addTarget:self action:@selector(notationAction:) forControlEvents:UIControlEventTouchUpInside];            
            
            [annotationView addSubview:customizeView];
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
