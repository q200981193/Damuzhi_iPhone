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

- (void)addDetailViewsToController:(CommonPlaceDetailController*)controller WithPlace:(Place*)place
{
    [controller addIntroductionViewWith: NSLS(@"景点介绍") description:[place introduction]];
    [controller addSegmentViewWith: NSLS(@"门票价格") description:[PlaceUtils getDetailPrice:place]];
    
    [controller addSegmentViewWith: NSLS(@"开放时间") description:[place openTime]];
    
    NSString *transportation = [place transportation];
    
    [controller addSegmentViewWith: NSLS(@"交通信息") description:transportation];
    
    [controller addSegmentViewWith: NSLS(@"旅游贴士") description:[place tips]];
}

@end
