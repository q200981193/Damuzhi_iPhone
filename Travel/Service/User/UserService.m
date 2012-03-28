//
//  UserService.m
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserService.h"
#import "UserManager.h"
#import "TravelNetworkRequest.h"
#import "JSON.h"
#import "LogUtil.h"

@implementation UserService

static UserService* _defaultUserService = nil;

+ (UserService*)defaultService
{
    if (_defaultUserService == nil) {
        _defaultUserService = [[UserService alloc] init];
    }
    return _defaultUserService;
}

- (void)autoRegisterUser:(NSString*)deviceToken
{
    // if user exists locally then return, else send a registration to server
    if ([[UserManager defaultManager] userId]) {
        return;
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            CommonNetworkOutput *output = [TravelNetworkRequest registerUser:1 token:deviceToken];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (output.textData != nil) {
                    NSDictionary* jsonDict = [output.textData JSONValue];
                    NSNumber *result = (NSNumber*)[jsonDict objectForKey:PARA_TRAVEL_RESULT];
                    
                    if (0 == result.intValue){
                        NSString *userId = (NSString*)[jsonDict objectForKey:PARA_TRAVEL_USER_ID];
                        [[UserManager defaultManager] saveUserId:userId];
                    }else {
                        PPDebug(@"<UserService> autoRegisterUser faild,result:%d", result.intValue);
                    }
                }else {
                    PPDebug(@"<UserService>autoRegisterUser:　Get User ID faild");
                }
            });                        
        });
    }
}

@end
