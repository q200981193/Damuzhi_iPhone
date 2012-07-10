//
//  RouteSelectCell.m
//  Travel
//
//  Created by 小涛 王 on 12-7-9.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "RouteSelectCell.h"
#import "Item.h"
#import "AppConstants.h"
#import "LocaleUtils.h"

#define WIDTH_SELECT_BUTTON 75
#define EDGE ((320 - WIDTH_SELECT_BUTTON * NUM_OF_SELECT_BUTTON_IN_LINE) / 2)
#define INVALID_ITEM_ID -99
#define FONT_BUTTON_TITLE [UIFont systemFontOfSize:15]


@interface RouteSelectCell ()

@property (retain, nonatomic) NSArray *itemList;
@property (retain, nonatomic) NSMutableArray *selectedItemIds;
@property (retain, nonatomic) NSMutableArray *selectedItemIdsBeforConfirm;

@property (assign, nonatomic) BOOL multiOptions;
@property (assign, nonatomic) BOOL needShowCount;

@end

@implementation RouteSelectCell

@synthesize aDelegate = _aDelegate;

@synthesize itemList = _itemList;
@synthesize selectedItemIds = _selectedItemIds;
@synthesize selectedItemIdsBeforConfirm = _selectedItemIdsBeforConfirm;

@synthesize multiOptions = _multiOptions;
@synthesize needShowCount = _needShowCount;

+ (NSString *)getCellIdentifier
{
    return NSLS(@"RouteSelectCell");
}

- (void)dealloc
{
    [_itemList release];
    [_selectedItemIds release];
    [_selectedItemIdsBeforConfirm release];
    
    [super dealloc];
}

- (void)setCellData:(NSArray *)itemList
    selectedItemIds:(NSMutableArray *)selectedItemIds
       multiOptions:(BOOL)multiOptions
        needConfirm:(BOOL)needConfirm
      needShowCount:(BOOL)needShowCount
{
    self.itemList = itemList;
    
    self.selectedItemIds = selectedItemIds;
    self.selectedItemIdsBeforConfirm = [NSMutableArray arrayWithArray:selectedItemIds];
    
    self.multiOptions = multiOptions;
    self.needShowCount = needShowCount;
    
    
    int totalRows = ([itemList count] + NUM_OF_SELECT_BUTTON_IN_LINE - 1) / NUM_OF_SELECT_BUTTON_IN_LINE;
    
    Item *item;
    int itemId;
    NSString *itemName;
    int row;
    int column;
    BOOL enabled;
    CGRect rect;
    
    for (int i = 0; i < totalRows * 4; i ++) {
        if (i < [itemList count]) {
            item = [itemList objectAtIndex:i];
        }else {
            item = nil;
        }
        
        itemId = (item == nil) ? INVALID_ITEM_ID : item.itemId;
        itemName = (item == nil) ? nil : item.itemName;
        enabled = (item == nil) ? NO : YES;

        row = i / NUM_OF_SELECT_BUTTON_IN_LINE;
        column = i % 4;
        rect = CGRectMake(EDGE + column * WIDTH_SELECT_BUTTON, row * HEIGHT_SELECT_BUTTON, WIDTH_SELECT_BUTTON, HEIGHT_SELECT_BUTTON);
        
        UIButton *button = [self buttonWithFrame:rect
                                             tag:itemId
                                           title:itemName 
                                         enabled:enabled 
                                             row:row 
                                          column:column 
                                       totalRows:totalRows];
        
        [self addSubview:button];
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                          tag:(int)tag
                        title:(NSString *)title
                      enabled:(BOOL)enabled
                          row:(int)row
                       column:(int)column
                    totalRows:(int)totalRows
{
    UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
    button.tag = tag;
    button.enabled = enabled;
    button.titleLabel.font = FONT_BUTTON_TITLE;
//    [button setTintColor:[UIColor blackColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateNormal];
    [button setImage:nil forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickSelectItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)clickSelectItem:(id)sender
{
    UIButton *button = (UIButton *)sender;
    int itemId = button.tag;
    
    if(self.multiOptions == YES){          
        if (itemId == ALL_CATEGORY) {
            if ([self isSelectedItemIds:_selectedItemIdsBeforConfirm containItemId:itemId]) {
                [_selectedItemIdsBeforConfirm removeObject:[NSNumber numberWithInt:itemId]];
            }else {
                [_selectedItemIdsBeforConfirm removeAllObjects];
                [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:itemId]];
            }
        }else {
            if ([self isSelectedItemIds:_selectedItemIdsBeforConfirm containItemId:ALL_CATEGORY]) {
                [_selectedItemIdsBeforConfirm removeObject:[NSNumber numberWithInt:ALL_CATEGORY]];
            }
            
            if ([self isSelectedItemIds:_selectedItemIdsBeforConfirm containItemId:itemId]) {
                [_selectedItemIdsBeforConfirm removeObject:[NSNumber numberWithInt:itemId]];
            }else {
                [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:itemId]];
            }
        }
        
    } else {
        [_selectedItemIdsBeforConfirm removeAllObjects];
        [_selectedItemIdsBeforConfirm addObject:[NSNumber numberWithInt:itemId]];
    }

}

- (BOOL)isSelectedItemIds:(NSArray *)selectedItemIds containItemId:(int)itemId
{
    for (NSNumber *selectedItemId in selectedItemIds) {
        if ([selectedItemId intValue] == itemId) {
            return YES;
        }
    }
    
    return NO;
}

- (void)copyItemIdsForm:(NSMutableArray *)itemIdsScr To:(NSMutableArray *)itemIdsDes
{
    [itemIdsDes removeAllObjects];
    for (NSNumber *itemId in itemIdsScr) {
        [itemIdsDes addObject:itemId];
    }
}

- (void)clickFinish:(id)sender
{
    if ([_selectedItemIdsBeforConfirm count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLS(@"温馨提示") message:NSLS(@"亲，您还没有选择哦！") delegate:nil cancelButtonTitle:NSLS(@"好的") otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    else{
        [self copyItemIdsForm:_selectedItemIdsBeforConfirm To:_selectedItemIds];
        if ([_aDelegate respondsToSelector:@selector(selectdItemsDidChange)]) {
            [_aDelegate selectdItemsDidChange];
        }
    }
}

@end
