//
//  MainController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainController.h"
#import "CommonPlaceListController.h"
#import "SpotListFilter.h"
#import "HotelListFilter.h"
#import "RestaurantFilter.h"
#import "FavoriteController.h"
#import "CommonInfoController.h"
#import "CityBasicDataSource.h"

#import "NearbyController.h"
#import "AppManager.h"

@implementation MainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_moreController release];
    [_spotListComtroller release];
    [_hotelListComtroller release];
    [_restaurantListComtroller release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void) clickTitle:(id)sender
{
    NSLog(@"click title");
}


#define APP_TITLE @"大拇指旅行 - "
#define BUTTON_VIEW_WIDTH 200
#define BUTTON_VIEW_HEIGHT 30
- (void)createButtonView
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BUTTON_VIEW_WIDTH-50, BUTTON_VIEW_HEIGHT)];
    label.font = [UIFont fontWithName:@"" size:0.1];
    label.text = [[NSString alloc] initWithFormat:@"大拇指旅行 — %@", [[AppManager defaultManager] getCurrentCityName]];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(BUTTON_VIEW_WIDTH-50, BUTTON_VIEW_HEIGHT/2-3, 14, 7)];
    [imageView setImage:[UIImage imageNamed:@"top_arrow.png"]];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_VIEW_WIDTH, BUTTON_VIEW_HEIGHT)];
    
    [button addSubview:label];
    [button addSubview:imageView];
    
    [button addTarget:self action:@selector(clickTitle:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = button;
    
    [label release];
    [imageView release];
    [button release];
}

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"index_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmenu_bg.png"] forBarMetrics:UIBarMetricsDefault];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self createButtonView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickSpotButton:(id)sender {
    if(_spotListComtroller == nil)
    {
        _spotListComtroller = [[CommonPlaceListController alloc] initWithFilterHandler:
                                                 [SpotListFilter createFilter]];
    }
    
    [self.navigationController pushViewController:_spotListComtroller animated:YES];
}

- (IBAction)clickHotelButton:(id)sender
{
    if(_hotelListComtroller == nil)
    {
        _hotelListComtroller = [[CommonPlaceListController alloc] initWithFilterHandler:
                               [HotelListFilter createFilter]];
    }
    
    [self.navigationController pushViewController:_hotelListComtroller animated:YES];
}

- (IBAction)clickRestaurant:(id)sender
{
    if(_restaurantListComtroller == nil)
    {
        _restaurantListComtroller = [[CommonPlaceListController alloc] initWithFilterHandler:
                                [RestaurantFilter createFilter]];
    }
    
    [self.navigationController pushViewController:_restaurantListComtroller animated:YES];
    
}

- (IBAction)clickCityOverviewButton:(id)sender
{
    CommonInfoController* controller = [[CommonInfoController alloc] initWithDataSource:[CityBasicDataSource createDataSource]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickNearbyButton:(id)sender
{
    NearbyController* controller = [[NearbyController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickMoreButton:(id)sender
{
    if (_moreController == nil) {
        _moreController = [[MoreController alloc] init];
    }
    
    [self.navigationController pushViewController:_moreController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmenu_bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)clickFavorite:(id)sender
{
    FavoriteController *fc = [[FavoriteController alloc] init];
    [self.navigationController pushViewController:fc animated:YES];
    [fc release];
}

@end
