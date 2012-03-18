//
//  CommonPlaceDetailController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "SlideImageView.h"
#import "Place.pb.h"
#import "CommonPlace.h"

@implementation CommonPlaceDetailController
@synthesize imageHolderView;
@synthesize dataScrollView;
@synthesize place;
@synthesize handler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id<CommonPlaceDetailDataSourceProtocol>)createPlaceHandler:(Place*)onePlace
{
    if ([onePlace categoryId] == PLACE_TYPE_SPOT){
        return [[[SpotDetailViewHandler alloc] init] autorelease];
    }
    return nil;
}

- (id)initWithPlace:(Place *)onePlace
{
    self = [super init];
    self.place = onePlace;    
    self.handler = [self createPlaceHandler:onePlace];     
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    [imageHolderView addSubview:slideImageView];  
    
    // add image array
    NSArray* imagePathArray = [self.place imagesList];
    NSMutableArray* images = [[[NSMutableArray alloc] init] autorelease];
    for (NSString* imagePath in imagePathArray){
        NSLog(@"%@", imagePath);
        [images addObject:[UIImage imageNamed:imagePath]];
    }
    [slideImageView setImages:images];
    
    [self.handler addDetailViews:dataScrollView WithPlace:self.place];
    
    UILabel *telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 300, 320, 30)];
//    telephoneLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""];
    NSString *tel = [[NSString alloc]initWithFormat:@"电话:"];

    NSArray *telephoneList = [self.place telephoneList];
    for (NSString* tel in telephoneList) {
        [tel stringByAppendingFormat:@" ", tel];
    }
    telephoneLabel.text = tel;
}

- (void)viewDidUnload
{
    [self setImageHolderView:nil];
    [self setDataScrollView:nil];
    [self setPlace:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [imageHolderView release];
    [dataScrollView release];
    [place release];
    [super dealloc];
}
@end
