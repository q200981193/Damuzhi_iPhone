//
//  ResendService.h
//  Travel
//
//  Created by haodong qiu on 12年5月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@interface ResendService : CommonService

+ (ResendService *)defaultService;
- (void)resendFavorite;

@end
