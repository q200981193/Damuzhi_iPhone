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

- (NSString*)getSubCategoryName:(int32_t)categoryId subCategoryId:(int32_t)subCategoryId;
- (NSString*)getServiceImage:(int32_t)categoryId providedServiceId:(int32_t)providedServiceId;


@end
