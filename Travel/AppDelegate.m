//
//  AppDelegate.m
//  Travel
//
//  Created by  on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LocaleUtils.h"
#import "MainController.h"
#import "UINavigationBarExt.h"
#import "DeviceDetection.h"
#import "AppService.h"
#import "UserService.h"
#import "LocalCityManager.h"
#import "AppConstants.h"
#import "MobClick.h"
#import "AppUtils.h"
#import "ResendService.h"

#define UMENG_KEY @"4f76a1c15270157f7700004d"

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainController = _mainController;

- (void)dealloc
{
    [_window release];
    [_mainController release];
    [super dealloc];
}

#define EVER_LAUNCHED @"everLaunched"
#define FIRST_LAUNCH @"firstLaunch"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:UMENG_KEY];
    
    if ([DeviceDetection isOS5]){
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top_live.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else{
        GlobalSetNavBarBackground(@"top_live.png");        
    }
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
//    //juage if app is firstLaunch
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:EVER_LAUNCHED]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:EVER_LAUNCHED];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FIRST_LAUNCH];
//    }
//    else{
//        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:FIRST_LAUNCH];
//    }
    
    [self initImageCacheManager];
    
//    //–insert a delay of 5 seconds before the splash screen disappears–
//    [NSThread sleepForTimeInterval:1.0];
    
    [AppUtils createAllNeededDir];
        
    // init app data
    [[AppService defaultService] loadAppData]; 
    
    // update app data from server
    [[AppService defaultService] updateAppData];
    
    // update help html 
    [[AppService defaultService] updateHelpHtmlFile];
    
    //register user
    //[[UserService defaultService] autoRegisterUser:@"123"];
    [[UserService defaultService] autoRegisterUser:[self getDeviceToken]];
    
    //resend favorete place
    [[ResendService defaultService] resendFavorite];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.mainController = [[[MainController alloc] initWithNibName:@"MainController" bundle:nil] autorelease];
    
    UINavigationController* navigationController = [[[UINavigationController alloc] initWithRootViewController:self.mainController] autorelease];
    self.mainController.navigationItem.title = NSLS(@"大拇指旅行");
    
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [[LocalCityManager defaultManager] save];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
