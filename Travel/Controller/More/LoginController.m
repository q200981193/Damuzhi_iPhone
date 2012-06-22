//
//  LoginController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LoginController.h"
#import "SignUpController.h"
#import "UserManager.h"

@interface LoginController ()

@end

@implementation LoginController
@synthesize loginIdTextField;
@synthesize passwordTextField;


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
    
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.title = NSLS(@"登录");
    [self setNavigationRightButton:NSLS(@"登录") 
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickLogin:)];
    
    
}

- (void)viewDidUnload
{
    
    [self setLoginIdTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//
- (void)clickLogin:(id)sender
{
    // To do, check password. 6~16 characters
    [[UserService defaultService] login:loginIdTextField.text
                               password:passwordTextField.text
                               delegate:self];
}

- (void)loginDidFinish:(int)success
{
    // check login success code.
}

- (IBAction)clickSignUpButton:(id)sender {
    SignUpController *contoller = [[[SignUpController alloc] init] autorelease];
    contoller.superController = self;
    [self.navigationController pushViewController:contoller animated:YES];
}

- (IBAction)clickRetrievePasswordButton:(id)sender {
    
}

- (IBAction)clickCheckOrdersButton:(id)sender {
    
}


- (void)dealloc {
    [loginIdTextField release];
    [passwordTextField release];
    [super dealloc];
}

- (IBAction)clickAutoLoginButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected; 
}

- (IBAction)clickRememberLoginIdButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[UserManager defaultManager] rememberLoginId:button.selected]; // save
    button.selected = !button.selected;
}


- (IBAction)clickRememberPasswordButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[UserManager defaultManager] rememberPassword:button.selected]; // save
     button.selected = !button.selected;
}


@end























































