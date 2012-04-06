//
//  ShareToSinaController.m
//  Travel
//
//  Created by haodong qiu on 12年4月6日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ShareToSinaController.h"

#define kSinaWeiBoAppKey        @"475196157"
#define kSinaWeiBoAppSecret     @"747adfaf3ec50dfe3791f9f0481365aa"

@interface ShareToSinaController ()

@property (nonatomic, retain) WBEngine *sinaWeiBoEngine;
@property (nonatomic, retain) UITextView *contentTextView;
@property (nonatomic, retain) UILabel *wordsNumberLabel;

@end

@implementation ShareToSinaController
@synthesize sinaWeiBoEngine;
@synthesize contentTextView;
@synthesize wordsNumberLabel;

- (void)dealloc
{
    [sinaWeiBoEngine release];
    [contentTextView release];
    [wordsNumberLabel release];
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
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"发送") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(sendSinaWeibo:)];
    
    self.navigationItem.title = NSLS(@"分享到新浪微博");
    
    [self createSendView];
    
    WBEngine *engine = [[WBEngine alloc] initWithAppKey:kSinaWeiBoAppKey appSecret:kSinaWeiBoAppSecret];
    [engine setRootViewController:self];
    [engine setDelegate:self];
    [engine setRedirectURI:@"http://"];
    [engine setIsUserExclusive:NO];
    self.sinaWeiBoEngine = engine;
    [engine release]; 
    
    if ([sinaWeiBoEngine isLoggedIn]) {
        
    }
    else {
        [sinaWeiBoEngine logIn];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self setSinaWeiBoEngine:nil];
    [self setContentTextView:nil];
    [self setWordsNumberLabel:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#define CONTENT_WIDTH   260
#define CONTENT_HEIGHT  140
- (void)createSendView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-CONTENT_WIDTH)/2, 0, 73, 30)];
    imageView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:imageView];
    [imageView release];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(260, 10, 30, 20)];
    label.text = @"0";
    label.textAlignment = UITextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    self.wordsNumberLabel = label;
    [label release];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake((320-CONTENT_WIDTH)/2, 30, CONTENT_WIDTH, CONTENT_HEIGHT)];
    textView.delegate = self;
    self.contentTextView = textView;
    [textView release];
    
    [self.view addSubview:wordsNumberLabel];
    [self.view addSubview:contentTextView];
}

#pragma -mark UITextViewDelegate 
- (void)textViewDidChange:(UITextView *)textView
{
    self.wordsNumberLabel.text = [NSString stringWithFormat:@"%d",[textView.text length]];
}

- (void)sendSinaWeibo:(id)sender
{
    if ([sinaWeiBoEngine isLoggedIn]) {
        [sinaWeiBoEngine sendWeiBoWithText:contentTextView.text image:nil];
    }
    else {
        [sinaWeiBoEngine logIn];
    }
}

- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    NSLog(@"engineAlreadyLoggedIn");
}

- (void)engineDidLogIn:(WBEngine *)engine
{
    NSLog(@"engineDidLogIn");
}

- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"engine: didFailToLogInWithError:");
}

- (void)engineDidLogOut:(WBEngine *)engine
{
    NSLog(@"engineDidLogOut");
}

- (void)engineNotAuthorized:(WBEngine *)engine
{
    NSLog(@"engineNotAuthorized");
}

- (void)engineAuthorizeExpired:(WBEngine *)engine
{
    NSLog(@"engineAuthorizeExpired");
}

- (void)engine:(WBEngine *)engine requestDidFailWithError:(NSError *)error
{
    NSLog(@"engine: requestDidFailWithError:");
}

- (void)engine:(WBEngine *)engine requestDidSucceedWithResult:(id)result
{
    NSLog(@"engine: requestDidSucceedWithResult:");
}


@end
