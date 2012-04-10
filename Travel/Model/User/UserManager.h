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

- (NSString*)userId;
- (void)saveUserId:(NSString*)userId;
- (BOOL)isShowImage;
- (void)saveIsShowImage:(BOOL)isShow;

@end
