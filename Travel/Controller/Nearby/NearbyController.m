//
//  NearbyController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NearbyController.h"
#import "PlaceListController.h"
#import "PlaceService.h"
#import "PPViewController.h"

@implementation NearbyController
@synthesize imageRedStartView;
@synthesize placeListController;
@synthesize placeListHolderView;
@synthesize distanceView;

- (void)dealloc
{
    [placeListController release];
    [placeListHolderView release];
    [distanceView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.

}

#pragma mark - View lifecycle

#define POINT_OF_DISTANCE_500M  CGPointMake(28, 18)
#define POINT_OF_DISTANCE_1KM   CGPointMake(83, 18)
#define POINT_OF_DISTANCE_5KM   CGPointMake(164, 18)
#define POINT_OF_DISTANCE_10KM   CGPointMake(287, 18)
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    imageRedStartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_star.png"]];
    
    [imageRedStartView setCenter:POINT_OF_DISTANCE_500M];
    
    [distanceView addSubview:imageRedStartView];
    
    
    // Do any additional setup after loading the view from its nib.
    
    [[PlaceService defaultService] findAllPlaces:self];    
}

- (void)viewDidUnload
{
    [self setPlaceListHolderView:nil];
    [self setDistanceView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)findRequestDone:(int)result dataList:(NSArray*)list
{
    self.placeListController = [PlaceListController createController:list 
                                                           superView:self.placeListHolderView];
}

- (IBAction)click500M:(id)sender {
    [imageRedStartView setCenter:POINT_OF_DISTANCE_500M];
}

- (IBAction)click1K:(id)sender {
    [imageRedStartView setCenter:POINT_OF_DISTANCE_1KM];
}

- (IBAction)click5K:(id)sender {
    [imageRedStartView setCenter:POINT_OF_DISTANCE_5KM];
}

- (IBAction)click10K:(id)sender {
    [imageRedStartView setCenter:POINT_OF_DISTANCE_10KM];
}
@end
