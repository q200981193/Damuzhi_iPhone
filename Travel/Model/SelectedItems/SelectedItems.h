//
//  SelectedItemsManager.h
//  Travel
//
//  Created by 小涛 王 on 12-4-3.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedItems : NSObject

@property (retain, nonatomic) NSMutableArray *selectedSubCategoryIdList;
@property (retain, nonatomic) NSMutableArray *selectedSortIdList;
@property (retain, nonatomic) NSMutableArray *selectedAreaIdList;
@property (retain, nonatomic) NSMutableArray *selectedPriceIdList;
@property (retain, nonatomic) NSMutableArray *selectedServiceIdList;
@property (retain, nonatomic) NSMutableArray *selectedCuisineIdList;

- (void)resetAll;

@end
