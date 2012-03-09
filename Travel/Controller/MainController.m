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

#import "CommonInfoController.h"
#import "CityBasicDataSource.h"

#import "NearbyController.h"
#import "MoreController.h"

@implementation MainController

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

- (void)createTitleView
{
#define TITLE_NAME @"大拇指旅行 - 肇庆"
#define TITLE_VIEW_WIDTH 200
#define TITLE_VIEW_HEIGHT 30
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TITLE_VIEW_WIDTH, TITLE_VIEW_HEIGHT)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TITLE_VIEW_WIDTH-50, TITLE_VIEW_HEIGHT)];
    label.font = [UIFont fontWithName:@"" size:0.1];
    label.text = @"大拇指旅行 — 肇庆";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;   

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(TITLE_VIEW_WIDTH-50, TITLE_VIEW_HEIGHT/2-3, 14, 7)];
    [imageView setImage:[UIImage imageNamed:@"top_arrow.png"]];
    [view addSubview:label];
    [view addSubview:imageView];

    self.navigationItem.titleView = view;

    [view release];
}

- (void)viewDidLoad
{
    [self setBackgroundImageName:@"index_bg.png"];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self createTitleView];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"index_bg@2x.png"]];
    
    

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
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (IBAction)clickSpotButton:(id)sender {
    
    CommonPlaceListController* controller = [[CommonPlaceListController alloc] initWithFilterHandler:
                                             [SpotListFilter createFilter]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];    
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
    MoreController* controller = [[MoreController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
