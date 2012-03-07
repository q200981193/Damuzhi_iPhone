//
//  SlideImageView.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012å¹?__MyCompanyName__. All rights reserved.
//

#import "SlideImageView.h"

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
        
        pageControl = [[UICustomPageControl alloc] initWithFrame:CGRectMake(self.bounds.origin.x/2, self.bounds.size.height-20, self.bounds.size.width, 20)]; 
        
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

- (void)setImages:(NSArray*)images
{
    // remove all old previous images
    NSArray* subviews = [scrollView subviews];
    for (UIView* subview in subviews){
        [subview removeFromSuperview];
    }
    
    int imagesCount = [images count];
    NSLog(@"imagesCount = %d", imagesCount);
    scrollView.contentSize = CGSizeMake(320*imagesCount, scrollView.frame.size.height);   
    for (int i=0; i<imagesCount; i++) {
        CGRect frame;
        frame.origin.x = scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame]; 
        [imageView setImage:[images objectAtIndex:i]];
        [scrollView addSubview:imageView];
        [imageView release];
    }
    
    pageControl.numberOfPages = imagesCount;
    [pageControl setImagePageStateNormal:[UIImage imageNamed:@"pageStateNormal.jpg"]];
    [pageControl setImagePageStateHighted:[UIImage imageNamed:@"pageStateHeight.jpg"]];
    
    [self addSubview:scrollView];
    [self addSubview:pageControl];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    if(pageControlIsChangingPage){
      return;
    }
        
    /* we switch page at %50 across */
    CGFloat pageWidth = scrollView1.frame.size.width;
    int page = floor((scrollView1.contentOffset.x - pageWidth/2)/pageWidth +1);
    NSLog(@"page = %d", page);
    pageControl.currentPage = page;
    [pageControl setImagePageStateNormal:[UIImage imageNamed:@"pageStateNormal.jpg"]];
    [pageControl setImagePageStateHighted:[UIImage imageNamed:@"pageStateHeight.jpg"]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    pageControlIsChangingPage = NO;
}

#pragma mark -
#pragma mark PageControl stuff
- (IBAction)pageClick:(id)sender
{
    /* Change the scroll view */
    CGRect frame = scrollView.frame;
    frame.origin.x  = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    
    [scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlIsChangingPage = YES;
}

@end
