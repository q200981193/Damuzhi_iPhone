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
- (void)submitFeekbackDidFinish:(int)resultCode;

- (void)signUpDidFinish:(int)resultCode result:(int)result resultInfo:(NSString *)resultInfo;
- (void)verificationDidSend:(int)resultCode;
- (void)verificationDidFinish:(int)resultCode;
- (void)loginDidFinish:(int)resultCode;
- (void)retrievePasswordDidSend:(int)resultCode;

@end

@interface UserService : CommonService

+ (UserService*)defaultService;

- (void)autoRegisterUser:(NSString*)deviceToken;

- (void)queryVersion:(id<UserServiceDelegate>)delegate;

- (void)submitFeekback:(id<UserServiceDelegate>)delegate
              feekback:(NSString*)feekback
               contact:(NSString*)contact;

- (void)login:(NSString *)loginId
     password:(NSString *)password
     delegate:(id<UserServiceDelegate>)delegate;

- (void)logout:(NSString *)loginId 
         token:(NSString *)token;

- (void)signUp:(NSString *)loginId 
      password:(NSString *)password
      delegate:(id<UserServiceDelegate>)delegate;

- (void)verificate:(NSString *)loginId 
         telephone:(NSString *)telephone 
          delegate:(id<UserServiceDelegate>)delegate;

- (void)verificate:(NSString *)loginId 
              code:(NSString *)code 
          delegate:(id<UserServiceDelegate>)delegate;

- (void)retrievePassword:(NSString *)loginId 
               telephone:(NSString *)telephone
                delegate:(id<UserServiceDelegate>)delegate;

- (void)modifyUserInfo:(NSString *)loginId
                 token:(NSString *)token 
              fullName:(NSString *)fullName
              nickName:(NSString *)nickName
                gender:(int)gender
             telephone:(NSString *)telephone
                 email:(NSString *)email
               address:(NSString *)address;
    
- (void)modifyPassword:(NSString *)loginId
                 token:(NSString *)token 
           oldPassword:(NSString *)oldPassword
                newPassword:(NSString *)newPassword;

- (void)retrieveUserInfo:(NSString *)loginId
        token:(NSString *)token;

@end
