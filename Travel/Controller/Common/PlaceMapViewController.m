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
#import "UIImageUtil.h"
#import "MapUtils.h"

@implementation PlaceMapViewController

@synthesize mapView = _mapView;
@synthesize locationManager = _locationManager;
@synthesize placeList = _placeList;
//@synthesize mapAnnotations;
@synthesize superController;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void) loadAllAnnotations
{    
    NSMutableArray *mapAnnotations = [[NSMutableArray alloc] init];
    if (_placeList && _placeList.count > 0) {
        for (Place *place in _placeList) {
            if ([MapUtils isValidLatitude:[place latitude] Longitude:[place longitude]]) {
                PlaceMapAnnotation *placeAnnotation = [[PlaceMapAnnotation alloc]initWithPlace:place];
                [mapAnnotations addObject:placeAnnotation];
                [placeAnnotation release];
            }
        } 
    }
    
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotations:mapAnnotations];
    [mapAnnotations release];
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;   
    [self loadAllAnnotations];
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];

}

- (void)mapView:(MKMapView *)mapview didAddAnnotationViews:(NSArray *)views
{
//    [MapUtils gotoLocation:[_placeList objectAtIndex:0] mapView:mapview];
}

- (void)viewDidUnload
{
    _mapView = nil;
    _placeList = nil;
    _locationManager = nil;
}

- (void)dealloc 
{
    [_mapView release];
    [_placeList release];
    [_locationManager release];
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
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:[annotation title]];
        if (pinView == nil)
        {
            MKAnnotationView* annotationView = [[[MKAnnotationView alloc]
                                                 initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] autorelease];
            PlaceMapAnnotation *placeAnnotation = (PlaceMapAnnotation*)annotation;
            
            UIButton *customizeView = [MapUtils createAnnotationViewWith:placeAnnotation.place placeList:_placeList];
            UIImage *img = [UIImage strectchableImageName:@"green_glass" leftCapWidth:20];
            annotationView.image = img;
            [annotationView setFrame:customizeView.frame];
                        
            [customizeView addTarget:self action:@selector(notationAction:) forControlEvents:UIControlEventTouchUpInside];            
            
            [annotationView addSubview:customizeView];
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
