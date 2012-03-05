//
//  SpotCell.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SpotCell.h"
#import "Place.pb.h"

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

- (NSString*)getIconByProvidedServiceId:(NSString*)serviceId
{   
    return serviceId;
}

-(void)setRankImage:(int32_t)rank
{
    self.praise1View.image = [UIImage imageNamed:@"bad.jpg"];
    self.praise2View.image = [UIImage imageNamed:@"bad.jpg"];
    self.praise3View.image = [UIImage imageNamed:@"bad.jpg"];

    switch (rank) {
        case 1:
            [praise1View setImage:[UIImage imageNamed:@"great.jpg"]];
            break;
            
        case 2:
            [praise1View setImage:[UIImage imageNamed:@"great.jpg"]];
            [praise2View setImage:[UIImage imageNamed:@"great.jpg"]];
            break;
            
        case 3:
            [praise1View setImage:[UIImage imageNamed:@"great.jpg"]];
            [praise2View setImage:[UIImage imageNamed:@"great.jpg"]];
            [praise3View setImage:[UIImage imageNamed:@"great.jpg"]];
            break;
            
        default:
            break;
    }
    
    return;
}


#define ORINGIN_X_OF_SERVICE_IMAGE 30
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
        CGRect rect = CGRectMake(categoryLable.frame.origin.x+ORINGIN_X_OF_SERVICE_IMAGE+i*DESTANCE_BETWEEN_SERVICE_IMAGES, categoryLable.frame.origin.y, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE);
        UIImageView *serviceImageView = [[UIImageView alloc]initWithFrame:rect];
        NSString *serviceIcon = [self getIconByProvidedServiceId:[serviceIdList objectAtIndex:i]];
        UIImage *serviceImage = [UIImage imageNamed:serviceIcon];
        [serviceImageView setImage:serviceImage];    
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
    self.areaLable.text = [place areaIdAtIndex:0];
    self.categoryLable.text = @"景点";
    [self.favoritesView setImage:[UIImage imageNamed:@"heart.jpg"]];
    
    [self setRankImage:[place rank]];
    [self setSeviceImage:(NSMutableArray*)[place providedServiceIdList]];
    
    //self.distanceLable.text = @"100米";
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
