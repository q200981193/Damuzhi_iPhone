//
//  RouteFeekbackController.h
//  Travel
//
//  Created by Orange on 12-7-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "UserService.h"
@interface RouteFeekbackController : PPTableViewController <UserServiceDelegate,
UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UIButton *backgroundImage1;
@property (retain, nonatomic) IBOutlet UIButton *backgroundImage2;
@property (retain, nonatomic) IBOutlet UIButton *backgroundImage3;

@property (retain, nonatomic) IBOutlet UITextView *feekbackTextViewField;

@property (retain, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
