//
//  FeekbackController.h
//  Travel
//
//  Created by 小涛 王 on 12-4-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPViewController.h"
#import "UserService.h"


@interface FeekbackController : PPViewController <UITextViewDelegate, UITextFieldDelegate, UserServiceDelegate>

@property (assign, nonatomic) CGPoint viewCenter;

@property (retain, nonatomic) IBOutlet UITextView *feekbackTextView;

@property (retain, nonatomic) IBOutlet UITextField *contactWayTextField;

- (CGFloat)getMoveDistance:(CGRect)frame keyboardHeight:(CGFloat)keyboardHeight;
- (void)moveView:(UIView*)view toCenter:(CGPoint)center needAnimation:(BOOL)need;

@end
