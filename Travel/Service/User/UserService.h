//
//  UserService.h
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@protocol UserServiceDelegate <NSObject>

@optional

- (void)queryVersionFinish:(NSString*)version dataVersion:(NSString*)dataVersion;
- (void)submitFeekbackDidFinish:(BOOL)success;

@end

@interface UserService : CommonService

+ (UserService*)defaultService;

- (void)autoRegisterUser:(NSString*)deviceToken;

- (void)queryVersion:(id<UserServiceDelegate>)delegate;

- (void)submitFeekback:(id<UserServiceDelegate>)delegate feekback:(NSString*)feekback contact:(NSString*)contact;

@end
