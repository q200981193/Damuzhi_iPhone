//
//  SlideImageView.m
//  Travel
//
//  Created by  on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SlideImageView.h"

@implementation SlideImageView

@synthesize scrollView;

/*-(IBAction)changePage
{
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlBeingUsed) {
        return;
    }
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage = page;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *array = [[NSArray alloc]initWithObjects:NSLocalizedString(@"image.jpg", nil), NSLocalizedString(@"image2.jpg", nil), NSLocalizedString(@"image3.jpg", nil), NSLocalizedString(@"image4.jpg", nil), NSLocalizedString(@"image5.jpg", nil), nil];
    
    for (int i=0; i<5; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width*i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:frame];
        [bgImageView setImage:[UIImage imageNamed:[array objectAtIndex:i]]];
        [self.scrollView addSubview:bgImageView];
    }
    array = nil;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*5, self.scrollView.frame.size.height);
    pageControlBeingUsed = NO;
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.backgroundColor = [UIColor greenColor];
        
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;        
    }
    return self;
}

-(void)dealloc
{
    [scrollView release];
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
    scrollView.contentSize = CGSizeMake(320*imagesCount, scrollView.frame.size.height);   //禁止scrollView上下滚动。
    
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
    
//  scrollView.delegate = self;
    [self addSubview:scrollView];

}

@end
