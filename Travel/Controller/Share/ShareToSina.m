//
//  ShareToSina.m
//  Travel
//
//  Created by haodong qiu on 12年4月6日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "ShareToSina.h"
#import "MainController.h"

@implementation ShareToSina


// If you try to log in with logIn or logInUsingUserID method, and
// there is already some authorization info in the Keychain,
// this method will be invoked.
// You may or may not be allowed to continue your authorization,
// which depends on the value of isUserExclusive.
- (void)engineAlreadyLoggedIn:(WBEngine *)engine
{
    NSLog(@"engineAlreadyLoggedIn");
}

// Log in successfully.
- (void)engineDidLogIn:(WBEngine *)engine
{
    NSLog(@"engineDidLogIn");
    WBSendView *sendView = [[WBSendView alloc] initWithAppKey:kSinaWeiBoAppKey appSecret:kSinaWeiBoAppSecret text:@"test" image:[UIImage imageNamed:@"bg.png"]];
    [sendView setDelegate:self];
    
    [sendView show:YES];
    [sendView release];
}

// Failed to log in.
// Possible reasons are:
// 1) Either username or password is wrong;
// 2) Your app has not been authorized by Sina yet.
- (void)engine:(WBEngine *)engine didFailToLogInWithError:(NSError *)error
{
    NSLog(@"engine: didFailToLogInWithError:");
}

// Log out successfully.
- (void)engineDidLogOut:(WBEngine *)engine
{
    NSLog(@"engineDidLogOut");
}

// When you use the WBEngine's request methods,
// you may receive the following four callbacks.
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



#pragma mark - WBSendViewDelegate Methods
//- (void)sendViewWillAppear:(WBSendView *)view
//{
//    NSLog(@"sendViewWillAppear");
//}
//
//- (void)sendViewDidAppear:(WBSendView *)view
//{
//    NSLog(@"sendViewDidAppear");
//}
//
//- (void)sendViewWillDisappear:(WBSendView *)view
//{
//    NSLog(@"sendViewWillDisappear");
//}
//
//- (void)sendViewDidDisappear:(WBSendView *)view
//{
//    NSLog(@"sendViewDidDisappear");
//}

- (void)sendViewDidFinishSending:(WBSendView *)view
{
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送成功！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendView:(WBSendView *)view didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [view hide:YES];
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil 
													   message:@"微博发送失败！" 
													  delegate:nil
											 cancelButtonTitle:@"确定" 
											 otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)sendViewNotAuthorized:(WBSendView *)view
{
    NSLog(@"sendViewNotAuthorized");
}

- (void)sendViewAuthorizeExpired:(WBSendView *)view
{
    NSLog(@"sendViewAuthorizeExpired");
}


@end
