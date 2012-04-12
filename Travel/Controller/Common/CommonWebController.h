//
//  CommonWebController.h
//  Travel
//
//  Created by 小涛 王 on 12-4-11.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PPViewController.h"

@interface CommonWebController : PPViewController <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@property (retain, nonatomic) NSString *htmlPath;

- (CommonWebController*)initWithWebUrl:(NSString*)htmlPath;

@end
