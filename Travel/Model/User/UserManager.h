//
//  UserManager.h
//  Travel
//
//  Created by  on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@interface UserManager : NSObject<CommonManagerProtocol>

- (NSString*)getUserId;
- (void)saveUserId:(NSString*)userId;

- (void)login:(NSString *)loginId token:(NSString *)token;
- (void)logout;

- (BOOL)isLogin;
- (NSString *)loginId;
- (NSString *)token;




@end
