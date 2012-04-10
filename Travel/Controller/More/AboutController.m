//
//  AboutController.m
//  Travel
//
//  Created by haodong qiu on 12年4月10日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "AboutController.h"
#import "AppManager.h"

@interface AboutController ()

@end

@implementation AboutController
@synthesize aboutWebView;

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
    
    //暂时用help的地址，以后记得更新
    NSString *aboutHtml = [[AppManager defaultManager] getHelpHtml];
    
    NSURL *url = [NSURL URLWithString:aboutHtml];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (request) {
        [self.aboutWebView loadRequest:request];        
    }
    
    self.aboutWebView.delegate = self;
}

- (void)viewDidUnload
{
    [self setAboutWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [aboutWebView release];
    [super dealloc];
}

#pragma mark-
#pragma mark- UIWebViewDelegate 
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showActivityWithText:@"正在加载页面..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideActivity];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"load URL failure, error=%@", [error description]);
    [self hideActivity];
    [self popupMessage:@"加载页面失败，请确认你已经连接到互联网" title:nil];
}

@end
