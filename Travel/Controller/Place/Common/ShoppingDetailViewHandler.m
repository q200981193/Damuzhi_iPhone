//
//  ShoppingDetailViewHandler.m
//  Travel
//
//  Created by gckj on 12-3-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonPlaceDetailController.h"
#import "Place.pb.h"

@implementation ShoppingDetailViewHandler

@synthesize commonController;

- (void)addDetailViews:(UIView*)dataScrollView WithPlace:(Place*)place
{
    
    [self.commonController addIntroductionViewWith: NSLS(@"商家简介") description:[place introduction]];
    
    [self.commonController addSegmentViewWith: NSLS(@"营业时间") description:[place openTime]];
    
    [self.commonController addSegmentViewWith:NSLS(@"停车指南") description:[place parkingGuide]];
    
    NSMutableString * transportation = [NSMutableString stringWithString:[place transportation]];
    NSRange range = NSMakeRange(0, [transportation length]); 
    [transportation replaceOccurrencesOfString:@";" withString:@"\n" options:NSCaseInsensitiveSearch range:range];
    [self.commonController addSegmentViewWith: NSLS(@"交通信息") description:transportation];
//    [self.commonController addTransportView:place];

    [self.commonController addSegmentViewWith: NSLS(@"购物贴士") description:[place tips]];
    
    
}

- (id)initWith:(CommonPlaceDetailController *)controller
{
    [super init];
    self.commonController = controller;
    return  self;
}


@end
