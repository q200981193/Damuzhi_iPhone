//
//  SpotDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"

@implementation HotelDetailViewHandler
@synthesize commonController;

- (NSString*)starToString:(int32_t)star
{
    return @"五星级";
}

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    
    [self.commonController addSegmentViewWith: NSLS(@"酒店简介") description:[place introduction]];
    
    [self.commonController addSegmentViewWith: NSLS(@"酒店星级") description:[self starToString:[place hotelStar]]];
    
    [self.commonController addSegmentViewWith: NSLS(@"用户评价关键词") description:[place.keywordsList componentsJoinedByString:@" "]];
    
    [self.commonController addSegmentViewWith: NSLS(@"房间价格") description:[place price]];
    
    [self.commonController addSegmentViewWith: NSLS(@"交通信息") description:[place transportation]];
}

- (id)initWith:(CommonPlaceDetailController *)controller
{
    [super init];
    self.commonController = controller;
    return  self;
}

@end
