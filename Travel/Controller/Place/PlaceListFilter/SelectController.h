//
//  SelectController.h
//  Travel
//
//  Created by 小涛 王 on 12-3-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"

@protocol SelectControllerDelegate <NSObject>
@optional
- (void)didSelectFinish:(NSArray*)selectedList;

@end

@interface SelectController : PPTableViewController

@property (assign, nonatomic) int type;
@property (assign, nonatomic) BOOL multiOptions;
@property (assign, nonatomic) BOOL needConfirm;
@property (retain, nonatomic) NSArray *placeList;

@property (retain, nonatomic) NSArray *meaningfulItems;
@property (retain, nonatomic) NSArray *allItems;
@property (retain, nonatomic) NSMutableArray *selectedIds;
@property (retain, nonatomic) NSMutableArray *beforeSelectedIds;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) id<SelectControllerDelegate> delegate;

+ (SelectController*)createController:(NSArray*)list selectedIds:(NSMutableArray*)selectedIds multiOptions:(BOOL)multiOptions needConfirm:(BOOL)needConfirm type:(int)type;
- (void)setAndReload:(NSArray*)placeList;

@end
