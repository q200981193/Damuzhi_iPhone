//
//  MapUtils.m
//  Travel
//
//  Created by gckj on 12-4-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapUtils.h"
#import "AppUtils.h"

@implementation MapUtils

+ (BOOL)isValidLatitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    if (-90.0 <= latitude && latitude <= 90.0 &&  -180.0 <= longitude && longitude <= 180.0){
        return  YES;
    }else {
        return NO;
    }
}

+ (void)gotoLocation:(Place*)place mapView:(MKMapView*)mapView
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
    newRegion.span.latitudeDelta = 0.025;
    newRegion.span.longitudeDelta = 0.025;
    
    [mapView setRegion:newRegion animated:YES];
}

+ (UIButton*)createAnnotationViewWith:(Place*)place placeList:(NSArray*)placeList
{
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize withinSize = CGSizeMake(300, CGFLOAT_MAX);
    CGSize size = [[place name] sizeWithFont:font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
    UIButton *customizeView = [[[UIButton alloc] initWithFrame:CGRectMake(0,0,size.width+40,27)] autorelease];
    
    NSString *fileName = [AppUtils getCategoryIndicatorIcon:place.categoryId];
    UIImage *icon = [UIImage imageNamed:fileName];
    
    UIButton *leftIndicatorButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 1.5, 13, 17)];            
    [leftIndicatorButton setBackgroundImage:icon forState:UIControlStateNormal];
    [leftIndicatorButton addTarget:self action:@selector(notationAction:) forControlEvents:UIControlEventTouchUpInside];
    [customizeView addSubview:leftIndicatorButton];
    [leftIndicatorButton release];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, size.width, 17)];
    label.font = [UIFont systemFontOfSize:12];
    label.text  = [place name];
    NSInteger value = [placeList indexOfObject:place];
    label.textColor = [UIColor colorWithWhite:255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    [customizeView addSubview:label];
    [label release];
    
    customizeView.tag = value;
    
    return customizeView;
}

+ (void) showCallout:(MKAnnotationView*)annotationView imageName:(NSString*)imageName tag:(NSInteger)tag target:(id)target
{
    annotationView.canShowCallout = YES;

    UIImage *image = [UIImage imageNamed:imageName];
    annotationView.image = image; 
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:target action:@selector(notationAction:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = rightButton;           
    
    rightButton.tag = tag;
}

@end
