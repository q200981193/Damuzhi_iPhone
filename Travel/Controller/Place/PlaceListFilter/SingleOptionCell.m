//
//  SingleOptionCell.m
//  Travel
//
//  Created by 小涛 王 on 12-4-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import "SingleOptionCell.h"
#import "UIImageUtil.h"

@implementation SingleOptionCell

#pragma mark -
#pragma mark: implementation of PPTableViewCellProtocol
@synthesize radioImageView;
@synthesize optionlLabel;
@synthesize selectedImageView;
+ (NSString*)getCellIdentifier
{
    return @"SingleOptionCell";
}

- (void)setCellData:(NSString*)optionName selected:(BOOL)selected
{
    self.optionlLabel.text = optionName;
    
    if (selected) {
        [self.radioImageView setImage:[UIImage imageNamed:@"radio_2.png"]];
        [self.selectedImageView setImage:[UIImage imageNamed:@"select_btn_1.png"]];
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage strectchableImageName:@""]]];
    }
    else {
        [self.radioImageView setImage:[UIImage imageNamed:@"radio_1.png"]];
        self.selectedImageView = nil;
        self.backgroundView = nil;
    }
}

- (void)dealloc {
    [radioImageView release];
    [optionlLabel release];
    [selectedImageView release];
    [super dealloc];
}
@end
