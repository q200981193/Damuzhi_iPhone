//
//  ShareToQQController.m
//  Travel
//
//  Created by haodong qiu on 12年4月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ShareToQQController.h"

#define kQQWeiBoAppKey        @"801124726"
#define kQQWeiBoAppSecret     @"4cd1cd1882f68fe7a7a43df7761d30d9"

#define kQQAccessTokenKey    @"QQAccessTokenKey"
#define kQQAccessTokenSecret	@"QQAccessTokenSecret"


@interface ShareToQQController ()
@property (nonatomic, retain) NSString *accessTokenKey;
@property (nonatomic, retain) NSString *accessTokenSecret;
- (void)loadDefaultKey;
@end

@implementation ShareToQQController
@synthesize accessTokenKey;
@synthesize accessTokenSecret;

- (void)dealloc
{
    [accessTokenKey release];
    [accessTokenSecret release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDefaultKey];
    
    if (self.accessTokenKey && self.accessTokenSecret) {
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setAccessTokenKey:nil];
    [self setAccessTokenSecret:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadDefaultKey {
	self.accessTokenKey = [[NSUserDefaults standardUserDefaults] valueForKey:kQQAccessTokenKey];
	self.accessTokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:kQQAccessTokenSecret];
}

@end
