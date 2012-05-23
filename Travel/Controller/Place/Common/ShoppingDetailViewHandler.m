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

- (void)addDetailViewsToController:(CommonPlaceDetailController*)controller WithPlace:(Place*)place
{
    [controller addIntroductionViewWith: NSLS(@"商家简介") description:[place introduction]];
    
    [controller addSegmentViewWith: NSLS(@"营业时间") description:[place openTime]];
    
    //    [self.commonController addSegmentViewWith:NSLS(@"停车指南") description:[place parkingGuide]];
    
    NSMutableString * transportation = [NSMutableString stringWithString:[place transportation]];
    NSRange range = NSMakeRange(0, [transportation length]); 
    [transportation replaceOccurrencesOfString:@";" withString:@"\n" options:NSCaseInsensitiveSearch range:range];
    [controller addSegmentViewWith: NSLS(@"交通信息") description:transportation];
    
    [controller addSegmentViewWith: NSLS(@"购物贴士") description:[place tips]]; 
}

@end
