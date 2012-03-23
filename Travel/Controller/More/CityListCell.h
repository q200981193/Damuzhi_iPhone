//
//  CityListCell.h
//  Travel
//
//  Created by 小涛 王 on 12-3-7.
//  Copyright (c) 2012年 甘橙软件. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "App.pb.h"

@interface CityListCell : PPTableViewCell<PPTableViewCellProtocol>

@property (retain, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (retain, nonatomic) IBOutlet UIButton *updateButton;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UILabel *dataSizeLabel;

- (void)setCellData:(City*)city;
- (void)initCellData;

@end
