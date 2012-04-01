//
//  AppDelegate.h
//  Travel
//
//  Created by  on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPApplication.h"

#define kAppId			@"travl_id"

@class MainController;

@interface AppDelegate : PPApplication <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainController *mainController;

@end
