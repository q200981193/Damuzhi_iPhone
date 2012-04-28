//
//  NearByRecommendController.m
//  Travel
//
//  Created by gckj on 12-4-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearByRecommendController.h"
#import "PlaceMapAnnotation.h"
#import "Place.pb.h"
#import "CommonPlaceDetailController.h"
#import "AppUtils.h"
#import "UIImageUtil.h"
#import "App.pb.h"

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

- (BOOL)isValidLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    if (-90.0 <= latitude && latitude <= 90.0 &&  -180.0 <= longitude && longitude <= 180.0){
        return  YES;
    }else {
        return NO;
    }
}

- (void)gotoLocation:(Place*)place
{
    if (![self isValidLatitude:[place latitude] Longitude:[place longitude]]) {
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

- (void) loadAllAnnotations
{ 
    NSMutableArray *mapAnnotations = [[NSMutableArray alloc] init];
    
    for (Place *place in _placeList) {
        if ([self isValidLatitude:[place latitude] Longitude:[place longitude]]) {
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
    
    // Find places nearby.
    [[PlaceService defaultService] findPlacesNearby:PlaceCategoryTypePlaceAll 
                                              place:_place distance:10.0     
                                     viewController:self];
    
    self.placeList = [[NSMutableArray alloc] init];
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
    
    CommonPlaceDetailController *controller = [[CommonPlaceDetailController alloc] initWithPlace:[_placeList objectAtIndex:index]];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (UIButton*)createAnnotationViewWith:(Place*)place
{
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize withinSize = CGSizeMake(300, CGFLOAT_MAX);
    CGSize size = [[place name] sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    UIButton *customizeView = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,size.width+40,27)] autorelease];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,size.width+40,27)];
    UIImage *img = [UIImage strectchableImageName:@"red_glass" leftCapWidth:20];
    [imageView setImage:img];
    [customizeView addSubview:imageView];
    
    NSString *fileName = [AppUtils getCategoryIndicatorIcon:place.categoryId];
    UIImage *icon = [UIImage imageNamed:fileName];
    
    UIButton *leftIndicatorButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 1.5, 13, 17)];            
    [leftIndicatorButton setBackgroundImage:icon forState:UIControlStateNormal];
    [leftIndicatorButton addTarget:self action:@selector(notationAction:) forControlEvents:UIControlEventTouchUpInside];
    [customizeView addSubview:leftIndicatorButton];
    [leftIndicatorButton release];
    [icon release];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, size.width, 17)];
    label.font = [UIFont systemFontOfSize:12];
    label.text  = [place name];
    NSInteger value = [_placeList indexOfObject:place];
    label.textColor = [UIColor colorWithWhite:255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    [customizeView addSubview:label];
    [label release];
    
    customizeView.tag = value;
    
    return customizeView;
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
             ;            
            UIButton *customizeView;
            
            //判断placeAnnotation是否为当前地点，是则显示红色长方块背景
            if (placeAnnotation.place == _place )
            {
                customizeView = [self createAnnotationViewWith:placeAnnotation.place];
            }
            else
            {
                NSInteger value = [self.placeList indexOfObject:placeAnnotation.place];

                customizeView = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,35,35)] autorelease];
                [customizeView setBackgroundColor:[UIColor clearColor]];

                NSString *fileName = [AppUtils getCategoryPinIcon:placeAnnotation.place.categoryId];
                UIImage *image = [UIImage imageNamed:fileName];
                
                annotationView.image = image; 
                customizeView.tag = value;
            }
            
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
