//
//  VerificationController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "VerificationController.h"
#import "ImageManager.h"
#import "UserManager.h"
#import "PPNetworkRequest.h"

@interface VerificationController ()

@property (copy, nonatomic) NSString *telephone;
@property (copy, nonatomic) NSString *code;

@end

@implementation VerificationController
@synthesize telephone = _telephone;
@synthesize code = _code;

@synthesize verificationBgImageView;
@synthesize telephoneTextField;
@synthesize codeTextField;
@synthesize hideKeyboardButton;

- (void)dealloc {
    [_telephone release];
    [_code release];
    
    [verificationBgImageView release];
    [telephoneTextField release];
    [codeTextField release];
    [hideKeyboardButton release];
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
    
    [self setNavigationLeftButton:NSLS(@" 返回") 
                        imageName:@"back.png"
                           action:@selector(clickBack:)];
    
    [self setNavigationRightButton:NSLS(@"确定") 
                         imageName:@"topmenu_btn_right.png" 
                            action:@selector(clickFinish:)];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"all_page_bg2.jpg"]]];
    
    verificationBgImageView.image = [[ImageManager defaultManager] signUpBgImage];
    
    telephoneTextField.delegate = self;
    codeTextField.delegate = self;
}

- (void)viewDidUnload
{
    [self setVerificationBgImageView:nil];
    [self setTelephoneTextField:nil];
    [self setCodeTextField:nil];
    [self setHideKeyboardButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)clickRetrieveCodeButton:(id)sender {
    self.telephone = telephoneTextField.text;
    
    [[UserService defaultService] verificate:[[UserManager defaultManager] loginId] telephone:_telephone delegate:self];
}

- (void) verificationDidSend:(int)resultCode
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，获取验证码失败") title:nil];
        return;
    }
    
    [self popupMessage:NSLS(@"等待接收验证码") title:nil];
}

- (IBAction)clickHideKeyboardButton:(id)sender {
    [self hideKeyboard];
    hideKeyboardButton.enabled = NO;
}

- (void)hideKeyboard
{
    [telephoneTextField resignFirstResponder];
    [codeTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField;           // became first responder
{
    hideKeyboardButton.enabled = YES;
}

//- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer {
//    [self hideKeyboard];
//}

@end
