//
//  AboutController.h
//  Travel
//
//  Created by haodong qiu on 12年4月10日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"

@interface AboutController : PPViewController<UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *aboutWebView;

@end
