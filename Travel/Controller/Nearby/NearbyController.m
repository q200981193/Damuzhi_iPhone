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
#import "CommonPlace.h"
#import "Place.pb.h"
#import "ImageName.h"
#import "UIImageUtil.h"
#import "App.pb.h"
#import "PPNetworkRequest.h"
#import "AppService.h"


@implementation NearbyController
@synthesize imageRedStartView;
@synthesize findAllPlaceButton;
@synthesize findSpotButton;
@synthesize findHotelButton;
@synthesize findShoppingButton;
@synthesize findEntertainmentButton;
@synthesize findRestaurantButton;
@synthesize buttonHolderView;
@synthesize placeListController;
@synthesize placeListHolderView;
@synthesize distanceView;
@synthesize distance=_distance;
@synthesize categoryId = _categoryId;
@synthesize showMap = _showMap;
@synthesize placeList = _placeList;

#define POINT_OF_DISTANCE_500M  CGPointMake(28, 18)
#define POINT_OF_DISTANCE_1KM   CGPointMake(83, 18)
#define POINT_OF_DISTANCE_5KM   CGPointMake(164, 18)
#define POINT_OF_DISTANCE_10KM   CGPointMake(287, 18)

#define DISTANCE_500M 500
#define DISTANCE_1KM  1000
#define DISTANCE_5KM 5000
#define DISTANCE_10KM 10000

- (void)dealloc
{
    [placeListController release];
    [placeListHolderView release];
    [distanceView release];
    [findAllPlaceButton release];
    [findSpotButton release];
    [findHotelButton release];
    [findShoppingButton release];
    [findEntertainmentButton release];
    [findRestaurantButton release];
    [_placeList release];
    [buttonHolderView release];
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

- (void)findRequestDone:(int)result placeList:(NSArray*)placeList
{
    if (result != ERROR_SUCCESS) {
        [self popupMessage:@"数据加载失败" title:nil];
    }
    
    self.placeList = [self filterByDistance:placeList distance:_distance];
    [self createAndReloadPlaceListController];
}

- (void)deletedPlace:(Place *)place
{
    [[PlaceService defaultService] findPlaces:_categoryId viewController:self];
}

- (void)createAndReloadPlaceListController
{        
    if (self.placeListController == nil){
        self.placeListController = [PlaceListController createController:_placeList 
                                                               superView:placeListHolderView
                                                         superController:self
                                                          pullToRreflash:YES];
        [placeListController setPullDownDelegate:self];
    }
    
    [self.placeListController setAndReloadPlaceList:_placeList];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    self.title = NSLS(@"我的附近");
    
    [self setNavigationRightButton:NSLS(@"地图") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickMapBtn:)];
    
    imageRedStartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_star.png"]];
    
    [imageRedStartView setCenter:POINT_OF_DISTANCE_500M];

    [distanceView addSubview:imageRedStartView];
    
    [buttonHolderView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage strectchableImageName:@"options_bg2.png"]]];    
    
    // Do any additional setup after loading the view from its nib.
    self.distance = DISTANCE_500M;
    self.categoryId = PlaceCategoryTypePlaceAll;
        
    [self setSelectedBtn:_categoryId];
    
    [[PlaceService defaultService] findPlaces:_categoryId viewController:self];
}

- (void)setSelectedBtn:(int)categoryId
{
    for (UIView *subView in [buttonHolderView subviews]) {
        if (![subView isKindOfClass:[UIButton class]]) {
            return;
        }
        
        UIButton *button = (UIButton*)subView;
        if (button.tag == categoryId) {
            button.selected = YES;
        }
        else
        {
            button.selected = NO;
        }
    }
}

- (void)viewDidUnload
{
    [self setPlaceListHolderView:nil];
    [self setDistanceView:nil];
    [self setFindAllPlaceButton:nil];
    [self setFindSpotButton:nil];
    [self setFindHotelButton:nil];
    [self setFindShoppingButton:nil];
    [self setFindEntertainmentButton:nil];
    [self setFindRestaurantButton:nil];
    [self setButtonHolderView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didPullDown
{
    [[PlaceService defaultService] findPlaces:_categoryId viewController:self];
}


- (NSArray*)filterByDistance:(NSArray*)list distance:(int)distance
{
    NSMutableArray *placeList = [[[NSMutableArray alloc] init] autorelease];
    for (Place *place in list) {
        CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
        CLLocation *myLocation = [[AppService defaultService] currentLocation];
        CLLocationDistance distance = [myLocation distanceFromLocation:placeLocation];
        [placeLocation release];
                
        if (distance <= self.distance) {
            [placeList addObject:place];
        }
    }
    
    return placeList;
}


- (void )clickMapBtn:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	
	[UIView setAnimationTransition:(_showMap ?
									UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlUp)
						   forView:self.view cache:YES];
    [UIView commitAnimations];
    
    if (_showMap){
        [self.placeListController switchToListMode];
    }
    else{
        [self.placeListController switchToMapMode];
    }
    
    _showMap = !_showMap;
    [self updateModeButton];
}


- (void)updateModeButton
{
    // set button text by _showMap flag
    if (_showMap) {
        UIButton *mapBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
        [mapBtn setTitle:@"列表" forState:UIControlStateNormal];
    } else {
        UIButton *mapBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
        [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    }
}

- (void)moveImageView:(UIImageView *)imageView toCenter:(CGPoint)center needAnimation:(BOOL)need
{
    if (need) {
        [UIImageView beginAnimations:nil context:nil];
        [UIImageView setAnimationDuration:1];
        [imageView setCenter:center];
        [UIImageView commitAnimations];        
    }else{
        [imageView setCenter:center];        
    }
}

- (IBAction)click500M:(id)sender {
    if (_distance != DISTANCE_500M) {
        self.distance = DISTANCE_500M;
        [self moveImageView:imageRedStartView toCenter:POINT_OF_DISTANCE_500M needAnimation:YES];
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self];    
    }
}

- (IBAction)click1K:(id)sender {
    if (_distance != DISTANCE_1KM) {
        self.distance = DISTANCE_1KM;
        [self moveImageView:imageRedStartView toCenter:POINT_OF_DISTANCE_1KM needAnimation:YES];
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self];    
    }   
}

- (IBAction)click5K:(id)sender {
    if (_distance != DISTANCE_5KM) {
        self.distance = DISTANCE_5KM;
        [self moveImageView:imageRedStartView toCenter:POINT_OF_DISTANCE_5KM needAnimation:YES];
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self];  
    }    
}

- (IBAction)click10K:(id)sender {
    if (_distance != DISTANCE_10KM) {
        self.distance = DISTANCE_10KM;
        [self moveImageView:imageRedStartView toCenter:POINT_OF_DISTANCE_10KM needAnimation:YES];
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self];    
    }
}

- (IBAction)clickSpotBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceSpot) {
        self.categoryId = PlaceCategoryTypePlaceSpot;
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self];    
        [self setSelectedBtn:_categoryId];
    }
}

- (IBAction)clickHotelBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceHotel) {
        self.categoryId = PlaceCategoryTypePlaceHotel;
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self];
        [self setSelectedBtn:_categoryId];
    }
}

- (IBAction)clickAllBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceAll) {
        self.categoryId = PlaceCategoryTypePlaceAll;
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self setSelectedBtn:_categoryId];
    }
}

- (IBAction)clickRestaurantBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceRestraurant) {
        self.categoryId = PlaceCategoryTypePlaceRestraurant;
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self setSelectedBtn:_categoryId];
    }
}

- (IBAction)clickShoppingBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceShopping) {
        self.categoryId = PlaceCategoryTypePlaceShopping;
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self setSelectedBtn:_categoryId];
    }
}

- (IBAction)clickEntertainmentBtn:(id)sender {
    if (_categoryId != PlaceCategoryTypePlaceEntertainment) {
        self.categoryId = PlaceCategoryTypePlaceEntertainment;
        [[PlaceService defaultService] findPlaces:_categoryId viewController:self]; 
        [self setSelectedBtn:_categoryId];
    }
}

@end
