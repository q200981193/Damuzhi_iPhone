//
//  RouteFeekbackController.m
//  Travel
//
//  Created by Orange on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RouteFeekbackController.h"

#import "PPTableViewController.h"   //(have not found the exact header for using NSLS)
#import "PPNetworkRequest.h"


#define MAX_LENGTH_OF_FEEKBACK 160

@implementation RouteFeekbackController
@synthesize backgroundImageButton1;
@synthesize backgroundImageButton2;
@synthesize backgroundImageButton3;

@synthesize feekbackTextView;
@synthesize feekbackImageView;

#pragma mark - View lifecycle


- (void)dealloc {
    [backgroundImageButton1 release];
    [backgroundImageButton2 release];
    [backgroundImageButton3 release];
    
    [feekbackTextView release];
    [feekbackImageView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png" 
                           action:@selector(clickBack:)];
    self.navigationItem.title = NSLS(@"评价");
    [self setNavigationRightButton:NSLS(@"发送")
                         imageName:@"topmenu_btn_right.png"  
                            action:@selector(clickSubmit:)];
    
    // Set feekback text view delegate.
    self.feekbackTextView.delegate = self;
    self.feekbackTextView.placeholder = NSLS(@"请输入您的评价!(小于等于160个字)");
    self.feekbackTextView.font = [UIFont systemFontOfSize:13];

    self.feekbackTextView.placeholderColor = [UIColor lightGrayColor];    
}
-(void) clickSubmit: (id) sender
{
    NSString *feekback = [self.feekbackTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];    
    if ([feekback compare:@""] == 0) {
        [self popupMessage:NSLS(@"请输入意见或建议") title:nil];
        return;
    }
    
    if ([feekback lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > MAX_LENGTH_OF_FEEKBACK) {
        [self popupMessage:NSLS(@"反馈意见字数太长") title:nil];
        return;
    }
    
  
    [feekbackTextView resignFirstResponder];
     [[UserService defaultService] submitFeekback:self feekback:feekback contact:nil];
}


- (void)submitFeekbackDidFinish:(int)resultCode
{
    if (resultCode == ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"发送成功") title:nil];
    }
    else {
        [self popupMessage:NSLS(@"网络不稳定，发送失败") title:nil];
    }
}

- (void)viewDidUnload
{
    [self setBackgroundImageButton1:nil];
    [self setBackgroundImageButton2:nil];
    [self setBackgroundImageButton3:nil];
    [self setFeekbackTextView:nil];
    [self setFeekbackImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)clickChangeBackgroundButton1:(id)sender {
    backgroundImageButton1.selected = YES;
    backgroundImageButton2.selected = NO;
    backgroundImageButton3.selected = NO;
}

- (IBAction)clickChangeBackgroundButton2:(id)sender {
    backgroundImageButton1.selected = YES;
    backgroundImageButton2.selected = YES;
    backgroundImageButton3.selected = NO;
}

- (IBAction)clickChangeBackgroundButton3:(id)sender {
    backgroundImageButton1.selected = YES;
    backgroundImageButton2.selected = YES;
    backgroundImageButton3.selected = YES;
}

- (IBAction)hideKeyboardButton:(id)sender {
    [feekbackTextView resignFirstResponder];
}


@end
