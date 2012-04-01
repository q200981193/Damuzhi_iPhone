//
//  PlaceCell.m
//  Travel
//
//  Created by  on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlaceCell.h"
#import "Place.pb.h"
#import "AppManager.h"
#import "StringUtil.h"
#import "ImageName.h"
#import "LogUtil.h"
#import "ASIHTTPRequest.h"
#import "FileUtil.h"
#import "PPApplication.h"
#import "CityOverviewManager.h"
#import "AppUtils.h"
#import "CommonPlace.h"
#import "PlaceService.h"
#import "PlaceStorage.h"

@implementation PlaceCell
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

+ (PlaceCell*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PlaceCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <PlaceCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((PlaceCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (PlaceCell*)[topLevelObjects objectAtIndex:0];
}

+ (NSString*)getCellIdentifier
{
    return @"PlaceCell";
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
    
    int i = 0;
    CGRect rect = CGRectMake(0, 0, WIDTH_OF_SERVICE_IMAGE, HEIGHT_OF_SERVICE_IMAGE);
    for (NSString *providedServiceIcon in providedServiceIcons) {
        UIImageView *serviceIconView = [[UIImageView alloc] initWithFrame:rect];
        UIImage *icon = [[UIImage alloc] initWithContentsOfFile:providedServiceIcon];
        //PPDebug(@"providedServiceIcon = %@", providedServiceIcon);
        
        serviceIconView.center = CGPointMake(categoryLable.frame.origin.x + categoryLable.frame.size.width+DESTANCE_BETWEEN_SERVICE_IMAGES_AND_CATEGORYLABEL+(i++)*DESTANCE_BETWEEN_SERVICE_IMAGES, 
                                             categoryLable.center.y); 
        
        [serviceIconView setImage:icon];
        [self.contentView addSubview:serviceIconView];
        [self.contentView viewWithTag:1];
        
        [icon release];
        [serviceIconView release];
    }
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

- (void)setCellDataByPlace:(Place*)place currentLocation:(CLLocation *)currentLocation
{ 
    self.nameLabel.text = [place name];
//    NSLog(@"place: %@", [place name]);
//    PPDebug(@"经纬度:%f,%f",place.longitude ,place.latitude);
    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
    NSLog(@"place: %@", [place name]);

    PPDebug(@"当前经纬度:%lf,%lf", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude);
    PPDebug(@"地点经纬度:%lf,%lf",place.longitude ,place.latitude);
    CLLocationDistance distance = [currentLocation distanceFromLocation:placeLocation];
    [placeLocation release];
    
    if (distance <1000.0) {
        self.distanceLable.text = [[NSString stringWithFormat:@"%d", distance] stringByAppendingString:NSLS(@"米")];
    }
    else {
        self.distanceLable.text = [[NSString stringWithFormat:@"%0.1lf", distance/1000] stringByAppendingString:NSLS(@"公里")];
    }
    
    [self setPlaceIcon:place];
    
    self.priceLable.text = [NSString stringWithFormat:@"%@%@",
                            [[CityOverViewManager defaultManager] getCurrencySymbol],
                            [place price]];
    
    self.areaLable.text = [[CityOverViewManager defaultManager] getAreaName:[place areaId]];

    self.categoryLable.text = [[AppManager defaultManager] getSubCategotyName:[place categoryId] 
                                                                subCategoryId:[place subCategoryId]];
    
    if ([[PlaceStorage favoriteManager] isPlaceInFavorite:place.placeId]) {
        [self.favoritesView setImage:[UIImage imageNamed:IMAGE_HEART]];
        self.favoritesView.hidden = NO;
    }
    else {
        [self.favoritesView setImage:nil];
        self.favoritesView.hidden = YES;
    }
    
    
    [self setRankImage:[place rank]];
    
    NSMutableArray *providedServiceIcons = [[[NSMutableArray alloc] init] autorelease];
    for (NSNumber *providedServiceId in [place providedServiceIdList]) {
        NSString *destinationDir = [AppUtils getProvidedServiceImageDir];
        NSString *fileName = [[NSString alloc] initWithFormat:@"%d.png", [providedServiceId intValue]];
        [providedServiceIcons addObject:[destinationDir stringByAppendingPathComponent:fileName]];
        [fileName release];
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
