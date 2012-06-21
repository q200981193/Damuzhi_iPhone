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

- (void)signUpDidFinish:(BOOL)success;

@end

@interface UserService : CommonService

+ (UserService*)defaultService;

- (void)autoRegisterUser:(NSString*)deviceToken;

- (void)queryVersion:(id<UserServiceDelegate>)delegate;

- (void)submitFeekback:(id<UserServiceDelegate>)delegate feekback:(NSString*)feekback contact:(NSString*)contact;

- (void)loginWithLoginId:(NSString *)loginId password:(NSString *)password os:(int)os;

- (void)signUpWithLoginId:(NSString *)loginId password:(NSString *)password;

- (void)verificate:(NSString *)loginId telephone:(NSString *)telephone;
- (void)verificate:(NSString *)loginId code:(NSString *)code;

- (void)retrievePassword:(NSString *)telephone;

- (void)modifyUserInfoWithLoginId:(NSString *)loginId
                            token:(NSString *)token 
                         fullName:(NSString *)fullName
                         nickName:(NSString *)nickName
                           gender:(int)gender
                        telephone:(NSString *)telephone
                            email:(NSString *)email
                          address:(NSString *)address;
    
- (void)modifyPasswordWithLoginId:(NSString *)loginId
                            token:(NSString *)token 
                      oldPassword:(NSString *)oldPassword
                      newPassword:(NSString *)newPassword;

- (void)retrieveUserInfoLoginId:(NSString *)loginId
                          token:(NSString *)token;

@end
