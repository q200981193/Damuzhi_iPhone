//
//  AppManager.h
//  Travel
//
//  Created by  on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"

@interface AppManager : NSObject<CommonManagerProtocol>

- (NSString*)getSubCategoryName:(int32_t)categoryId subCategoryId:(NSString*)subCategoryId;
- (NSString*)getServiceImage:(int32_t)categoryId providedServiceId:(NSString*)providedServiceId;


@end
