//
//  SpotCell.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpotCell.h"
#import "Place.pb.h"
#import "AppManager.h"
#import "StringUtil.h"
#import "ImageName.h"
#import "LogUtil.h"
#import "ASIHTTPRequest.h"
#import "FileUtil.h"

@implementation SpotCell
@synthesize nameLabel;
@synthesize priceLable;
@synthesize distanceLable;
@synthesize areaLable;
@synthesize categoryLable;
@synthesize imageView;
@synthesize praise1View;
@synthesize praise2View;
@synthesize praise3View;
@synthesize favoritesView;


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

-(void)setRankImage:(int32_t)rank
{
    self.praise1View.image = [UIImage imageNamed:IMAGE_GOOD2];
    self.praise2View.image = [UIImage imageNamed:IMAGE_GOOD2];
    self.praise3View.image = [UIImage imageNamed:IMAGE_GOOD2];

    switch (rank) {
        case 1:
            [praise1View setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        case 2:
            [praise1View setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praise2View setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        case 3:
            [praise1View setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praise2View setImage:[UIImage imageNamed:IMAGE_GOOD]];
            [praise3View setImage:[UIImage imageNamed:IMAGE_GOOD]];
            break;
            
        default:
            break;
    }
    
    return;
}


#define DESTANCE_BETWEEN_SERVICE_IMAGES 18
#define WIDTH_OF_SERVICE_IMAGE 15
#define HEIGHT_OF_SERVICE_IMAGE 15
-(void)setSeviceImage:(NSMutableArray*)serviceIdList
{
    NSArray* views = self.contentView.subviews;
    
    for (UIView* view in views){
        if (view.tag == 1){
            [view removeFromSuperview];
        }
    }
    
    for (int i=0; i<[serviceIdList count]; i++) {
        NSString *imageName = [serviceIdList objectAtIndex:i];
       // UIImage *image = [UIImage imageNamed:imageName];
        
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageName];
        
        PPDebug(@"image = %@", imageName);

        CGRect rect = CGRectMake(categoryLable.frame.origin.x+categoryLable.frame.size.width+i*DESTANCE_BETWEEN_SERVICE_IMAGES, categoryLable.frame.origin.y, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE);
        
        UIImageView *serviceImageView = [[UIImageView alloc] initWithFrame:rect];
        [serviceImageView setImage:image];
        
        [self.contentView addSubview:serviceImageView];
        [self.contentView viewWithTag:1];
        [serviceImageView release];
    }   

}

- (void)setCellDataByPlace:(Place*)place
{ 
    self.nameLabel.text = [place name];
    self.imageView.image = [UIImage imageNamed:[place icon]];
    self.priceLable.text = [place price];
    self.areaLable.text = [NSString  stringWithInt:[place areaIdAtIndex:0]];
    self.categoryLable.text = [[AppManager defaultManager] 
                               getSubCategoryName:[place categoryId]                                                                
                               subCategoryId:[place subCategoryId]];
    
    [self.favoritesView setImage:[UIImage imageNamed:IMAGE_HEART]];
    
    [self setRankImage:[place rank]];
    
    NSArray *serviceIdList = [place providedServiceIdList];
    NSMutableArray *serviceIcons = [[NSMutableArray alloc] init];
    for(NSNumber* providedServieceId in serviceIdList)
    {
        NSString *serviceIcon = [[AppManager defaultManager]getServiceImage:[place categoryId] providedServiceId:[providedServieceId intValue]];
        PPDebug(@"serviceIcon = %@", serviceIcon);
        
        [serviceIcons addObject:serviceIcon];
    }
   
    [self setSeviceImage:serviceIcons];
    [serviceIcons release];
}

- (void)dealloc {
    [nameLabel release];
    [priceLable release];
    [distanceLable release];
    [areaLable release];
    [categoryLable release];
    [imageView release];
    [praise1View release];
    [praise2View release];
    [praise3View release];
    [favoritesView release];
    [super dealloc];
}
@end
