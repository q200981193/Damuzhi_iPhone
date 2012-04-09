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
#import "RestaurantListFilter.h"
#import "ShoppingListFilter.h"
#import "EntertainmentListFilter.h"
#import "FavoriteController.h"
#import "CommonInfoController.h"
#import "CityBasicDataSource.h"
#import "TravelUtilityDataSource.h"
#import "CommonPlace.h"

#import "NearbyController.h"
#import "AppManager.h"
#import "CityManagementController.h"
#import "HelpController.h"
#import "ShareToSinaController.h"
#import "ShareToQQController.h"

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
    [_shoppingListComtroller release];
    [_entertainmentListComtroller release];
    [_nearbyController release];
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
    CityManagementController *controller = [[CityManagementController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
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
    //[self createButtonView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self createButtonView];
    [super viewWillAppear:animated];
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
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[SpotListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickHotelButton:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[HotelListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickRestaurant:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[RestaurantListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickShopping:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[ShoppingListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickEntertainment:(id)sender
{
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:[EntertainmentListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickCityOverviewButton:(id)sender
{
    CommonInfoController* controller = [[CommonInfoController alloc] initWithDataSource:[CityBasicDataSource createDataSource]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];        
}

- (IBAction)clickTravelUtilityButton:(id)sender
{
    CommonInfoController *controller = [[CommonInfoController alloc]initWithDataSource:[TravelUtilityDataSource createDataSource]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];  
}


- (IBAction)clickNearbyButton:(id)sender
{
    NearbyController *controller = [[NearbyController alloc] init];
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

- (IBAction)clickFavorite:(id)sender
{
    FavoriteController *fc = [[FavoriteController alloc] init];
    [self.navigationController pushViewController:fc animated:YES];
    [fc release];
}

- (IBAction)clickHelp:(id)sender {
    HelpController *controller = [[HelpController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)clickShare:(id)sender
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLS(@"取消") destructiveButtonTitle:NSLS(@"通过短信") otherButtonTitles:NSLS(@"分享到新浪微博"), NSLS(@"分享到腾讯微博"), nil];
    [shareSheet showInView:self.view];
    [shareSheet release];
}

#pragma -mark share UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            NSLog(@"click 0");
            break;
        case 1:
            NSLog(@"click 1");
            ShareToSinaController *sc = [[ShareToSinaController alloc] init];
            [self.navigationController pushViewController:sc animated:NO];
            [sc release];
            break;
        case 2:
            NSLog(@"click 2");
            ShareToQQController *shareToQQ = [[ShareToQQController alloc] init];
            [self.navigationController pushViewController:shareToQQ animated:YES];
            [shareToQQ release];
            break;
        case 3:
            NSLog(@"click 3");
            break;
        default:
            break;
    }
}

@end
