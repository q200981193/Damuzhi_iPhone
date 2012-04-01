//
//  CommonInfoController.m
//  Travel
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonInfoController.h"
#import "SlideImageView.h"
#import "CityOverviewService.h"
#import "AppManager.h"
#import "AppUtils.h"

@implementation CommonInfoController

@synthesize imageHolderView;
@synthesize dataWebview;
@synthesize dataSource;

- (void)dealloc {
    [dataSource release];
    [imageHolderView release];
    [dataWebview release];
    [super dealloc];
}

- (id)initWithDataSource:(NSObject<CommonInfoDataSourceProtocol>*)source
{
    self = [super init];
    self.dataSource = source;
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setTitle:[dataSource getTitleName]];
    
    [self setNavigationLeftButton:NSLS(@"返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [dataSource requestDataWithDelegate:self];
}

- (void)findRequestDone:(int)result data:(CommonOverview*)commonOverview
{
    NSString* urlString = [commonOverview html];
    NSArray *imageList = [commonOverview imagesList];
    
    //handle urlString, if there has local data, urlString is a relative path, otherwise, it is a absolute URL.
    NSURL* url = nil;
    if ([urlString hasPrefix:@"http:"]){
        url = [NSURL URLWithString:urlString];           
    }
    else{
        NSString *htmlPath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:urlString];         
        url = [NSURL fileURLWithPath:htmlPath];
    }
    
    //request from a url, load request to web view.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSLog(@"load webview url = %@", [request description]);
    if (request) {
        [self.dataWebview loadRequest:request];        
    }
    
    
    //handle imageList, if there has local data, each image is a relative path, otherwise, it is a absolute URL.
    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    NSLog(@"imagePath = %@", [imageList objectAtIndex:0]);
    if (![[imageList objectAtIndex:0] hasPrefix:@"http:"]) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *image in imageList) {
            NSString *imagePath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:image];
            [images addObject:imagePath];
//            NSLog(@"imagePath = %@", imagePath);
        }
        [slideImageView setImages:images];
    }
    else {
        [slideImageView setImages:imageList];
    }
    
    [imageHolderView addSubview:slideImageView]; 
    [slideImageView release];
}

- (void)viewDidUnload
{
    [self setImageHolderView:nil];
    [self setDataWebview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
