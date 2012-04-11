//
//  RestaurantDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"

@implementation RestaurantViewHandler

@synthesize commonController;

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    
    [self.commonController addIntroductionViewWith: NSLS(@"餐馆介绍") description:[place introduction]];
    
    [self.commonController addSegmentViewWith: NSLS(@"菜式类型") description: @"粤菜"];
    
    [self.commonController addSegmentViewWith:NSLS(@"人均消费") description:[place avgPrice]];
    
    [self.commonController addSegmentViewWith: NSLS(@"用户评价关键词") description:[[place keywordsList] componentsJoinedByString:@" "]];
    
    [self.commonController addSegmentViewWith: NSLS(@"特色菜式") description:[[place typicalDishesList] componentsJoinedByString:@" "]];
    
    NSMutableString * transportation = [NSMutableString stringWithString:[place transportation]];
    NSRange range = NSMakeRange(0, [transportation length]); 
    [transportation replaceOccurrencesOfString:@";" withString:@"\n" options:NSCaseInsensitiveSearch range:range];
    [self.commonController addSegmentViewWith: NSLS(@"交通信息") description:transportation];
}

- (id)initWith:(CommonPlaceDetailController *)controller
{
    [super init];
    self.commonController = controller;
    return  self;
}

@end
