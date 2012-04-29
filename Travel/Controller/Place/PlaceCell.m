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
#import "AppManager.h"
#import "AppUtils.h"
#import "CommonPlace.h"
#import "PlaceService.h"
#import "PlaceStorage.h"
#import "PlaceUtils.h"

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
#define WIDTH_OF_SERVICE_IMAGE 15
#define HEIGHT_OF_SERVICE_IMAGE 15
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
        
        serviceIconView.center = CGPointMake(categoryLable.frame.origin.x + categoryLable.frame.size.width+DESTANCE_BETWEEN_SERVICE_IMAGES_AND_CATEGORYLABEL+(i++)*DESTANCE_BETWEEN_SERVICE_IMAGES, 
                                             categoryLable.center.y); 
        
        [serviceIconView setImage:icon];
        serviceIconView.tag = 1;
        [self.contentView addSubview:serviceIconView];
                
        [icon release];
        [serviceIconView release];
    }
}

- (void)setPlaceIcon:(Place*)place
{
    [self.imageView clear];
    [self.imageView setImage:[UIImage imageNamed:@"default_s.png"]];

    if (![AppUtils isShowImage] ) {
        return;
    }
    
    if (![place.icon hasPrefix:@"http"]){
        // local files, read image locally
        NSString *iconPath = [[AppUtils getCityDataDir:[[AppManager defaultManager] getCurrentCityId]] stringByAppendingPathComponent:place.icon];
        PPDebug(@"place iconPath = %@", iconPath);
        [self.imageView setImage:[UIImage imageWithContentsOfFile:iconPath]];
    }
    else{
        [self.imageView showLoadingWheel];

        self.imageView.callbackOnSetImage = self;
        self.imageView.url = [NSURL URLWithString:[place icon]];
        PPDebug(@"load place image from URL %@", [place icon]);
        [GlobalGetImageCache() manage:self.imageView];
    }
}

- (void) managedImageSet:(HJManagedImageV*)mi
{
    [mi.loadingWheel stopAnimating];
}

- (void) managedImageCancelled:(HJManagedImageV*)mi
{
    [mi.loadingWheel stopAnimating];
}

- (void)setCellDataByPlace:(Place*)place currentLocation:(CLLocation *)currentLocation
{ 
    nameLabel.text = [place name];
    
    [distanceLable setTextColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1]];
    distanceLable.text = [self getDistanceString:place currentLocation:currentLocation];
    [self setPlaceIcon:place];
    priceLable.text = [PlaceUtils getPriceString:place];
    
    areaLable.text = [[AppManager defaultManager] getAreaName:place.cityId areaId:place.areaId];
    
    [categoryLable setTextColor:[UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1]];
    
    if (place.categoryId == PlaceCategoryTypePlaceHotel) {
        categoryLable.text = [PlaceUtils hotelStarToString:place.hotelStar];
    }else {
        categoryLable.text = [[AppManager defaultManager] getSubCategotyName:[place categoryId] 
                                                                    subCategoryId:[place subCategoryId]];
    }
    
    if ([[PlaceStorage favoriteManager] isPlaceInFavorite:place.placeId]) {
        [favoritesView setImage:[UIImage imageNamed:IMAGE_HEART]];
        favoritesView.hidden = NO;
    }
    else {
        [favoritesView setImage:nil];
        favoritesView.hidden = YES;
    }
    
    
    [self setRankImage:[place rank]];
    
//    PPDebug(@"palce name = %@", [place name]);
    
    NSMutableArray *providedServiceIcons = [[NSMutableArray alloc] init];
    for (NSNumber *providedServiceId in [place providedServiceIdList]) {
        NSString *iconPath = [AppUtils getProvidedServiceIconPath:[providedServiceId intValue]];
//        PPDebug(@"provided service icon: %@", iconPath);
        [providedServiceIcons addObject:iconPath];
    }
    
    [self setServiceIcons:providedServiceIcons];
    [providedServiceIcons release];

}

- (NSString*)getDistanceString:(Place*)place currentLocation:(CLLocation *)currentLocation
{
    if (currentLocation == nil) {
        return @"";
    }
    
    CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:[place latitude] longitude:[place longitude]];
    CLLocationDistance distance = [currentLocation distanceFromLocation:placeLocation];
    [placeLocation release];
    
//    NSLog(@"place name = %@", place.name);
//    NSLog(@"place latitude = %lf, place longitude ＝ %lf", place.latitude, place.longitude);
//    NSLog(@"current location = %@", currentLocation.description);
//    NSLog(@"distance = %lf", distance);

    if (distance > 100000.0) {
        return @"";
    }
    else if (distance >1000.0) {
        long long temp = (long long)distance / 1000;
        return [NSString stringWithFormat:NSLS(@"%lldKM"), temp];
    }
    else if (distance > 100.0) {
        return [NSString stringWithFormat:NSLS(@"%0.1fM"), (float)distance];
    }
    else {
        return [NSString stringWithFormat:NSLS(@"0.1KM")];
    }
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
