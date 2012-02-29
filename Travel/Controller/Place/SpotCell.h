//
//  SpotCell.h
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonPlaceCell.h"

@interface SpotCell : CommonPlaceCell

+ (SpotCell*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@end
