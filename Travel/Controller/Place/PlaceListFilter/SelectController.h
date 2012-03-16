//
//  SelectController.h
//  Travel
//
//  Created by 小涛 王 on 12-3-13.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "PPTableViewController.h"

@protocol SelectControllerDelegate <NSObject>

- (void)didSelectFinish:(NSArray*)selectedList;

@end

@interface SelectController : PPTableViewController
{
    NSMutableArray* _selectedIds;
    BOOL _multiOptions;
}

@property (assign, nonatomic) BOOL multiOptions;
@property (retain, nonatomic) NSMutableArray *selectedIds;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) id<SelectControllerDelegate> delegate;

+ (SelectController*)createController:(NSArray*)list selectedIds:(NSMutableArray*)selectedIds multiOptions:(BOOL)multiOptions;
@end
