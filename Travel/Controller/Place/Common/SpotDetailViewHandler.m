//
//  SpotDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-17.
//  Copyright (c) 2012Âπ?__MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"
#import "PlaceUtils.h"

@implementation SpotDetailViewHandler
@synthesize commonController;

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    [self.commonController addIntroductionViewWith: NSLS(@"景点介绍") description:[place introduction]];
    [self.commonController addSegmentViewWith: NSLS(@"门票价格") description:[PlaceUtils  getPriceString:place]];
    
    [self.commonController addSegmentViewWith: NSLS(@"开放时间") description:[place openTime]];
    
    NSString *transportation = [place transportation];

    [self.commonController addSegmentViewWith: NSLS(@"交通信息") description:transportation];
   
    [self.commonController addSegmentViewWith: NSLS(@"旅游贴士") description:[place tips]];
}

-(id)initWith:(CommonPlaceDetailController *)controller
{
    [super init];
    self.commonController = controller;
    return  self;
}

@end
