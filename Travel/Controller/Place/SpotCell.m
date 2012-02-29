//
//  SpotCell.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpotCell.h"

@implementation SpotCell
@synthesize nameLabel;

+ (SpotCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SpotCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <SpotCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((SpotCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (SpotCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"SpotCell";
}

- (void)dealloc {
    [nameLabel release];
    [super dealloc];
}
@end
