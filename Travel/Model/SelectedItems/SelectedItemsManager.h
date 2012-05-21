//
//  SelectedItemsManager.h
//  Travel
//
//  Created by 小涛 王 on 12-4-20.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonService.h"
#import "SelectedItems.h"

@interface SelectedItemsManager : NSObject <CommonManagerProtocol>

@property (retain, nonatomic) SelectedItems *spotSelectedItems;
@property (retain, nonatomic) SelectedItems *hotelSelectedItems;
@property (retain, nonatomic) SelectedItems *restaurantSelectedItems;
@property (retain, nonatomic) SelectedItems *shoppingSelectedItems;
@property (retain, nonatomic) SelectedItems *entertainmentSelectedItems;

- (SelectedItems*)getSelectedItems:(int)categoryId;
- (void)resetAllSelectedItems;

@end
