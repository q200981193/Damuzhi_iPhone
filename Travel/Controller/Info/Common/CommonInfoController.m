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
    
    SlideImageView* slideImageView = [[SlideImageView alloc] initWithFrame:imageHolderView.bounds];
    [imageHolderView addSubview:slideImageView];  
    
    // add image array
    [dataSource getImages];
    
//    NSArray* images = [dataSource getImages];
//    if ([AppUtils hasLocalCityData:[[AppManager defaultManager] getCurrentCityId]]) {
//        NSMutableArray *imagePathList = [[NSMutableArray alloc] init];
//        for (NSString *image in images) {
//            NSString *imagePath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:image]; 
//            [imagePathList addObject:imagePath];
//        }
//    }
//    else
//    {
//        
//    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[dataSource getHtmlFileURL]];
    NSLog(@"load webview url = %@", [request description]);
    if (request) {
        [self.dataWebview loadRequest:request];
        
    }

}

- (void)findRequestDone:(int)result data:(CityOverview*)cityOverView
{
    
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
