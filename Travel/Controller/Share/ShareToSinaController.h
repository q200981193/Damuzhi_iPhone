//
//  ShareToSinaController.h
//  Travel
//
//  Created by haodong qiu on 12年4月6日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPViewController.h"
#import "WBEngine.h"

@interface ShareToSinaController : PPViewController<WBEngineDelegate, UITextViewDelegate>

- (IBAction)backgroundTap:(id)sender;

@end
