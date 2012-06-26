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
#import "PPNetworkRequest.h"

// add by lst
#import "StringUtil.h"
//#define TAG_TEXT_FIELD_LOGIN_ID 19
//#define TAG_TEXT_FIELD_PASSWORD 20

@interface LoginController ()
@property (copy, nonatomic) NSString *loginId;
@property (copy, nonatomic) NSString *password;
@end

@implementation LoginController
@synthesize loginIdTextField;
@synthesize passwordTextField;

@synthesize loginId = _loginId;
@synthesize password = _password;

#pragma mark: Lift cycle

- (void)dealloc {
    [_loginId release];
    [_password release];
    
    [loginIdTextField release];
    [passwordTextField release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationLeftButton:NSLS(@" 返回") 
                         imageName:@"topmenu_btn2.png"
                            action:@selector(clickBack:)];
    
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

#pragma mark: Button action

- (void)clickLogin:(id)sender
{
    // To do, check password. 6~16 characters
    // valid loginId and password
    [self hideKeyboard:nil];
    self.loginId = [self.loginIdTextField.text
                    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.password = self.passwordTextField.text;
    
    
    
    if (!NSStringIsValidPhone(_loginId)) {
        [self popupMessage:NSLS(@"您输入的号码格式不正确") title:nil];
        return;
    }
    
    if (_password.length < 6) {
        [self popupMessage:NSLS(@"您输入的密码太短") title:nil];
        return;
    }
    
    if (_password.length > 16) {
        [self popupMessage:NSLS(@"您输入的密码长度太长") title:nil];
        return;
    }
    
    [[UserService defaultService] login:loginIdTextField.text
                               password:passwordTextField.text
                               delegate:self];
    
}

- (IBAction)hideKeyboard:(id)sender {
    [self.loginIdTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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

- (IBAction)clickAutoLoginButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected; 
}

- (IBAction)clickRememberLoginIdButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[UserManager defaultManager] rememberLoginId:button.selected];  
    button.selected = !button.selected;
}

- (IBAction)clickRememberPasswordButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    [[UserManager defaultManager] rememberPassword:button.selected]; 
    button.selected = !button.selected;
}

////called whe 'done' key pressed. return NO to ignore
//-(BOOL) textFieldShouldReturn:(UITextField *)textField
//{
//       switch (textField.tag) {
//        case :TAG_TEXT_FIELD_LOGIN_ID
//            [loginIdTextField becomeFirstResponder];
//            break;
//         
//        case :TAG_TEXT_FIELD_PASSWORD
//            [self hideKeyboard:nil]
//            break;
//            
//        default:
//            break;
//    }
//    return YES;
//}

#pragma mark: implementation of UserServiceDelegate.

- (void)loginDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo
{
    if (resultCode != ERROR_SUCCESS) {
        [self popupMessage:NSLS(@"您的网络不稳定，登录失败") title:nil];
        return;
    }
    
    if (result != 0) {
        NSString *str = [NSString stringWithFormat:NSLS(@"登陆失败：%@"), resultInfo];
        [self popupMessage:str title:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end























































