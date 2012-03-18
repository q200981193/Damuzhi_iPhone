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
    
//    // add image array
//    NSArray* imagePathArray = [self.place imagesList];
//    NSMutableArray* images = [[[NSMutableArray alloc] init] autorelease];
//    for (NSString* imagePath in imagePathArray){
//        NSLog(@"%@", imagePath);
//        [images addObject:[UIImage imageNamed:imagePath]];
//    }
//    [slideImageView setImages:images];
    
    
    [dataScrollView setContentSize:CGSizeMake(320, 460)];
    [self.handler addDetailViews:dataScrollView WithPlace:self.place];
    
    UILabel *telephoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 350, 320, 20)];
    telephoneLabel.font = [UIFont systemFontOfSize:12];
    telephoneLabel.backgroundColor = [UIColor redColor];
    NSString *tel = [[[NSString alloc]initWithFormat:@"电话:"] autorelease];
    NSArray *telephoneList = [self.place telephoneList];
    for (NSString* telephone in telephoneList) {
        tel = [tel stringByAppendingFormat:@" ", telephone];
    }
    telephoneLabel.text = tel;
    
    [dataScrollView addSubview:telephoneLabel];
    [telephoneLabel release];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 370, 320, 20)];
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.backgroundColor = [UIColor greenColor];
    NSString *addr = [[[NSString alloc]initWithFormat:@"地址:"] autorelease];
    NSArray *addressList = [self.place addressList];
    for (NSString* address in addressList) {
        addr = [addr stringByAppendingFormat:@" ", address];
    }
    addressLabel.text = addr;
    
    [dataScrollView addSubview:addressLabel];
    [addressLabel release];
    
    UILabel *websiteLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 390, 320, 20)];
    websiteLabel.font = [UIFont systemFontOfSize:12];
    websiteLabel.backgroundColor = [UIColor blueColor];
    NSString *website = @"网站: ";
    websiteLabel.text = [website stringByAppendingString:[self.place website]];
    
    [dataScrollView addSubview:websiteLabel];
    [websiteLabel release];
    
    UIView *favouritesView = [[UIView alloc]initWithFrame:CGRectMake(0, 410, 320, 50)];
    
     UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 5, 120, 20)];
    [button setTitle:@"收藏本页" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.backgroundColor = [UIColor blueColor];
    [favouritesView addSubview:button];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 30, 100, 10)];
    label.text = @"已有673人收藏";
    label.font = [UIFont systemFontOfSize:12];
    [favouritesView addSubview:label];
    
    [dataScrollView addSubview:favouritesView];
    [label release];
    [button release];
    [favouritesView release];
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
