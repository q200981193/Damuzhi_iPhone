//
//  CommonWebController.m
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "CommonWebController.h"

@implementation CommonWebController

@synthesize urlString = _urlString;
@synthesize webView;


- (void)initWithWebUrl:(NSString*)urlString
{
    self.urlString = urlString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [_urlString release];
    [webView release];
    [super dealloc];
}
@end
