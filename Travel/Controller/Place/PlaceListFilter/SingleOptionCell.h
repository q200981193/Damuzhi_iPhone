//
//  SingleOptionCell.h
//  Travel
//
//  Created by 小涛 王 on 12-4-8.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"

@interface SingleOptionCell : PPTableViewCell <PPTableViewCellProtocol>

@property (retain, nonatomic) IBOutlet UIImageView *radioImageView;

@property (retain, nonatomic) IBOutlet UILabel *optionlLabel;

@property (retain, nonatomic) IBOutlet UIImageView *selectedImageView;

- (void)setCellData:(NSString*)optionName selected:(BOOL)selected;

@end
