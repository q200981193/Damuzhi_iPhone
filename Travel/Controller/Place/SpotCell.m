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
#import "PPApplication.h"


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

#define DESTANCE_BETWEEN_SERVICE_IMAGES_AND_CATEGORYLABEL 5
#define DESTANCE_BETWEEN_SERVICE_IMAGES 15
#define WIDTH_OF_SERVICE_IMAGE 11
#define HEIGHT_OF_SERVICE_IMAGE 11
-(void)setServiceIcons:(NSArray*)providedServiceIcons
{
    NSArray* views = self.contentView.subviews;
    
    for (UIView* view in views){
        if (view.tag == 1){
            [view removeFromSuperview];
        }
    }
    
    CGRect rect = CGRectMake(0, 0, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE);
    UIImageView *serviceIconView = [[UIImageView alloc] initWithFrame:rect];
    int i = 0;
    for (NSString *providedServiceIcon in providedServiceIcons) {
        UIImage *icon = [[UIImage alloc] initWithContentsOfFile:providedServiceIcon];
        PPDebug(@"providedServiceIcon = %@", providedServiceIcon);
        
        serviceIconView.center = CGPointMake(categoryLable.center.x+categoryLable.frame.size.width/2+DESTANCE_BETWEEN_SERVICE_IMAGES_AND_CATEGORYLABEL+(i++)*DESTANCE_BETWEEN_SERVICE_IMAGES, 
                                             categoryLable.center.y); 
        
        [serviceIconView setImage:icon];
        [self.contentView addSubview:serviceIconView];
        [self.contentView viewWithTag:1];
        
        [icon release];
    }
    
    [serviceIconView release];
//    
//    
//    for (int i=0; i<[serviceIdList count]; i++) {
//        NSString *imageName = [serviceIdList objectAtIndex:i];
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageName];
//        
//        PPDebug(@"image = %@", imageName);
//        
//        CGRect rect = CGRectMake(0, 0, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE);
//        UIImageView *serviceImageView = [[UIImageView alloc] initWithFrame:rect];
//        serviceImageView.center = CGPointMake(categoryLable.center.x+categoryLable.frame.size.width/2+DESTANCE_BETWEEN_SERVICE_IMAGES_AND_CATEGORYLABEL+i*DESTANCE_BETWEEN_SERVICE_IMAGES, categoryLable.center.y); 
//        
//        [serviceImageView setImage:image];
//        
//        [self.contentView addSubview:serviceImageView];
//        [self.contentView viewWithTag:1];
//        [serviceImageView release];
//    }   

}

- (void)setPlaceIcon:(Place*)place
{
    if ([[place icon] isAbsolutePath]){
    //if (YES){
        // local files, read image locally
        
    }
    else{
        self.imageView.callbackOnSetImage = self;
        [self.imageView clear];
        self.imageView.url = [NSURL URLWithString:[place icon]];
        PPDebug(@"load place image from URL %@", [place icon]);
        [GlobalGetImageCache() manage:self.imageView];
    }
}

- (void) managedImageSet:(HJManagedImageV*)mi
{
}

- (void) managedImageCancelled:(HJManagedImageV*)mi
{
}

- (void)setCellDataByPlace:(Place*)place
{ 
    self.nameLabel.text = [place name];
    
    
    [self setPlaceIcon:place];
    
    self.priceLable.text = [place price];
    
    self.areaLable.text = [NSString  stringWithInt:[place areaIdAtIndex:0]];
    
    self.categoryLable.text = [[AppManager defaultManager] getSubCategotyName:[place categoryId] 
                                                                subCategoryId:[place subCategoryId]];
    
    [self.favoritesView setImage:[UIImage imageNamed:IMAGE_HEART]];
    
    [self setRankImage:[place rank]];
    
    NSMutableArray *providedServiceIcons = [[[NSMutableArray alloc] init] autorelease];
    for (NSNumber *providedServiceId in [place providedServiceIdList]) {
        NSString *providedServiceIcon = [[AppManager defaultManager] getProvidedServiceIcon:[place categoryId]
                                                                          providedServiceId:[providedServiceId intValue]];
        [providedServiceIcons addObject:providedServiceIcon];
    }
    
    [self setServiceIcons:providedServiceIcons];
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
