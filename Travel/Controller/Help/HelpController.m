//
//  HelpController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "HelpController.h"
#import "AppManager.h"

@implementation HelpController
@synthesize helpWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self.navigationItem setTitle:NSLS(@"帮助")];
    
    NSString *helpHtml = [[AppManager defaultManager] getHelpHtml];
    NSLog(@"helpHtmlPath = %@",helpHtml);
    NSURL *url = [NSURL URLWithString:helpHtml];
    //request from a url, load request to web view.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (request) {
        [self.helpWebView loadRequest:request];        
    }
    
    self.helpWebView.delegate = self;
}

- (void)viewDidUnload
{
    [self setHelpWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [helpWebView release];
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showActivityWithText:@"正在加载页面..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewVal
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
