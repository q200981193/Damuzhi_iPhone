//
//  HelpController.h
//  Travel
//
//  Created by 小涛 王 on 12-4-5.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@interface HelpController : PPViewController <UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *helpWebView;

@end
