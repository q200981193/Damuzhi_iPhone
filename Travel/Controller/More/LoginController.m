//
//  LoginController.m
//  Travel
//
//  Created by 小涛 王 on 12-6-21.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "LoginController.h"

@interface LoginController ()

@end

@implementation LoginController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor redColor];//by lst
    self.navigationItem.title = NSLS(@"登录");//by lst
    
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)clickLogin:(id)sender
{
    [[UserService defaultService] login:nil password:nil delegate:self];
}

- (void)loginDidFinish:(BOOL)success
{
    if (success) {
        
    }else {
    }
}



- (void)dealloc {
      [super dealloc];
}









@end























































