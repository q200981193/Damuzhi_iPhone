//
//  SlideImageView.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012å¹?__MyCompanyName__. All rights reserved.
//

#import "SlideImageView.h"
#import "HJObjManager.h"
#import "PPApplication.h"

#define DEFAULT_HEIGHT_OF_PAGE_CONTROL 20

@implementation SlideImageView

@synthesize scrollView;

@synthesize pageControl;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        pageControl = [[UICustomPageControl alloc] initWithFrame:CGRectMake(self.bounds.origin.x/2, self.bounds.size.height-DEFAULT_HEIGHT_OF_PAGE_CONTROL, self.bounds.size.width, DEFAULT_HEIGHT_OF_PAGE_CONTROL)]; 
        
        scrollView.delegate = self;
        [pageControl addTarget:self action:@selector(pageClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)dealloc
{
    [scrollView release];
    [pageControl release];
    [super dealloc];
}


// images is a NSString array that contain a list of absoute path or absolute URL or bundle file name of the images.
- (void)setImages:(NSArray*)images{
    // remove all old previous images
    NSArray* subviews = [scrollView subviews];
    for (UIView* subview in subviews){
        [subview removeFromSuperview];
    }
    
    //set content size of scroll view.
    int imagesCount = [images count];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*imagesCount, scrollView.frame.size.height);
    
    for (int i=0; i<imagesCount; i++) {
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        
        NSString *image = [images objectAtIndex:i];
    
        HJManagedImageV *imageView = [[HJManagedImageV alloc] initWithFrame:frame]; 
        
        NSLog(@"image = %@", image);
    
        [imageView showLoadingWheel];
         
        if ([image isAbsolutePath]) {
            // Load image from file
            [imageView setImage:[[UIImage alloc] initWithContentsOfFile:[images objectAtIndex:i]]];
        }
        else if([image hasPrefix:@"http:"]){
            // Load image from url
            imageView.callbackOnSetImage = self;
            [imageView clear];
            imageView.url = [NSURL URLWithString:image];
            [GlobalGetImageCache() manage:imageView];
        }
        else{
            // Load image from bundle
            [imageView setImage:[images objectAtIndex:i]];
        }
        
        [scrollView addSubview:imageView];
        [imageView release];
    }
    
    pageControl.numberOfPages = imagesCount;
    [pageControl setImagePageStateNormal:[UIImage imageNamed:@"pageStateNormal.jpg"]];
    [pageControl setImagePageStateHighted:[UIImage imageNamed:@"pageStateHeight.jpg"]];
    
    [self addSubview:scrollView];
    [self addSubview:pageControl];
}

- (void) managedImageSet:(HJManagedImageV*)mi
{
}

// Loading image failed will call this method
- (void) managedImageCancelled:(HJManagedImageV*)mi
{
}


#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    /* we switch page at %50 across */
    CGFloat pageWidth = scrollView1.frame.size.width;
    int page = floor((scrollView1.contentOffset.x - pageWidth/2)/pageWidth +1);
    pageControl.currentPage = page;
    [pageControl setImagePageStateNormal:[UIImage imageNamed:@"pageStateNormal.jpg"]];
    [pageControl setImagePageStateHighted:[UIImage imageNamed:@"pageStateHeight.jpg"]];
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)pageClick:(id)sender
{
    // Change the scroll view 
    CGRect frame = scrollView.frame;
    frame.origin.x  = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}

@end
