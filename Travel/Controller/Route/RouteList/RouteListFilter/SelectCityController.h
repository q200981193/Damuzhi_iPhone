//
//  SelectCityController.h
//  Travel
//
//  Created by haodong qiu on 12年7月7日.
//  Copyright (c) 2012年 orange. All rights reserved.
//

#import "PPTableViewController.h"

@class Item;
@protocol SelectCityDelegate <NSObject>

@optional
- (void)didSelectCity:(NSArray *)selectedItemList;

@end


@interface SelectCityController : PPTableViewController <UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;

- (id)initWithAllItemList:(NSArray *)itemsList 
         selectedItemList:(NSMutableArray *)selectedItemIds 
                 delegate:(id<SelectCityDelegate>)delegate;

@end
