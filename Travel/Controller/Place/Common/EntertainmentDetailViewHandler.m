//
//  EntertainmentDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"
#import "PlaceUtils.h"

@implementation EntertainmentDetailViewHandler

@synthesize commonController;

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    
    [self.commonController addIntroductionViewWith: NSLS(@"商家简介") description:[place introduction]];
    
    [self.commonController addSegmentViewWith: NSLS(@"营业时间") description: [place openTime]];
    
    [self.commonController addSegmentViewWith:NSLS(@"人均消费") description:[place priceDescription]];
    
    [self.commonController addSegmentViewWith: NSLS(@"关键词评价") description:[place.keywordsList componentsJoinedByString:@" "]];
    
    [self.commonController addSegmentViewWith: NSLS(@"交通信息") description:[place transportation]];
    
    [self.commonController addSegmentViewWith: NSLS(@"玩乐贴士") description:[place tips]];
    
    
}

- (id)initWith:(CommonPlaceDetailController *)controller
{
    [super init];
    self.commonController = controller;
    return  self;
}


@end
