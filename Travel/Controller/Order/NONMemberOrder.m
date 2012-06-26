//
//  NONMemberOrder.m
//  Travel
//
//  Created by 小涛 王 on 12-6-26.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "NONMemberOrder.h"
#import "TouristRoute.pb.h"

#define TAG_TEXT_FIELD_CONTACT_PERSON 111

@interface NONMemberOrder ()

@property (retain, nonatomic) TouristRoute *route;

@end

@implementation NONMemberOrder

@synthesize route = _route;

@synthesize routeNameLabel;
@synthesize contactPerson;
@synthesize telephone;

- (void)dealloc {
    [_route release];
    
    [routeNameLabel release];
    [contactPerson release];
    [telephone release];
    [super dealloc];
}

- (id)initWithRoute:(TouristRoute *)route
{
    if (self = [super init]) {
        self.route = _route;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    routeNameLabel.text = _route.name;
}

- (void)viewDidUnload
{
    [self setRouteNameLabel:nil];
    [self setContactPerson:nil];
    [self setTelephone:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

// called when 'return' key pressed. return NO to ignore.
//- (BOOL)textFieldShouldReturn:(UITextField *)textField              
//{
//    switch (textField.tag) {
//        case TAG_TEXT_FIELD_LOGIN_ID:
//            [passwordTextField becomeFirstResponder];
//            break;
//            
//        case TAG_TEXT_FIELD_PASSWORD:
//            [comfirmPasswordTextField becomeFirstResponder];
//            break;
//            
//        case TAG_TEXT_FIELD_COMFIRM_PASSWORD:
//            [self hideKeyboard];
//            break;
//            
//        default:
//            break;
//    }
//    
//    return YES;
//}

@end
