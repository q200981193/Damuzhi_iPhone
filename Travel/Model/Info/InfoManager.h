//
//  InfoManager.h
//  Travel
//
//  Created by  on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityOverview.pb.h"

@interface InfoManager : NSObject

@property (nonatomic, retain) CommonOverview* cityBasic;
@property (nonatomic, retain) CityOverview* cityOverview;

+ (InfoManager*)defaultManager;

- (CommonOverview*)getCityBasic;
- (void)readCityOverview:(NSString*)cityId;

@end
