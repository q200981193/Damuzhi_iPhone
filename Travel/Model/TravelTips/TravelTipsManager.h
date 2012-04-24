//
//  TravelTips.h
//  Travel
//
//  Created by 小涛 王 on 12-4-10.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "TravelTips.pb.h"

@interface TravelTipsManager : NSObject <CommonManagerProtocol>

@property (assign, nonatomic) int cityId;
@property (retain, nonatomic) NSArray *guideList;
@property (retain, nonatomic) NSArray *routeList;

- (void)switchCity:(int)cityId;
- (NSArray*)getTravelTipList:(TravelTipType)type;
- (CommonTravelTip*)getTravelTip:(TravelTipType)type tipId:(int)tipId;

@end
