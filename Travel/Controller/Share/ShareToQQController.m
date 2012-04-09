//
//  ShareToQQController.m
//  Travel
//
//  Created by haodong qiu on 12年4月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ShareToQQController.h"
#import "LogUtil.h"
#import "LocaleUtils.h"
#import "QWeiboSyncApi.h"
#import "QVerifyWebViewController.h"
#import "NSURL+QAdditions.h"

#define kQQWeiBoAppKey        @"801124726"
#define kQQWeiBoAppSecret     @"4cd1cd1882f68fe7a7a43df7761d30d9"
#define kQQAccessTokenKey       @"QQAccessTokenKey"
#define kQQAccessTokenSecret	@"QQAccessTokenSecret"
#define VERIFY_URL      @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="

@interface ShareToQQController ()
@property (nonatomic, retain) NSString *accessTokenKey;
@property (nonatomic, retain) NSString *accessTokenSecret;
@property (nonatomic, retain) UIWebView *authWebView;

- (void)loadDefaultKey;
@end

@implementation ShareToQQController
@synthesize accessTokenKey;
@synthesize accessTokenSecret;
@synthesize authWebView;

- (void)dealloc
{
    [accessTokenKey release];
    [accessTokenSecret release];
    [authWebView release];
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
    
    [NSURL smartURLForString:@"test"];
    
    if (accessTokenKey || [accessTokenKey length] == 0 || accessTokenSecret || [accessTokenSecret length] == 0) {
        QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
        NSString *retString = [api getRequestTokenWithConsumerKey:kQQWeiBoAppKey consumerSecret:kQQWeiBoAppSecret];
        PPDebug(@"Get requestToken:%@", retString);
        NSDictionary *params = [NSURL parseURLQueryString:retString];
        self.accessTokenKey = [params objectForKey:@"oauth_token"];
        self.accessTokenSecret = [params objectForKey:@"oauth_token_secret"];
    }
    
    if (accessTokenKey && accessTokenSecret) {
        [self createAuthWebView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self setAccessTokenKey:nil];
    [self setAccessTokenSecret:nil];
    [self setAuthWebView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadDefaultKey {
	self.accessTokenKey = [[NSUserDefaults standardUserDefaults] valueForKey:kQQAccessTokenKey];
	self.accessTokenSecret = [[NSUserDefaults standardUserDefaults] valueForKey:kQQAccessTokenSecret];
}

- (void)createAuthWebView
{
    UIWebView *webView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
    webView.delegate = self;
    self.authWebView = webView;
    [webView release];
    
    [self.view addSubview:authWebView];
    NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, accessTokenKey];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
	[authWebView loadRequest:request];
}

#pragma -mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

@end
