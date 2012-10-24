//
//  PhotoViewController.m
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"

#define PHOTO_NUM		20
#define INDICATOR_W		60
#define INDICATOR_H		60

#define SCROLL_PHOTO_NUM	PHOTO_NUM

#define SCROLL_TIME_INTERVAL	0.05	//20fps
#define RELOAD_INTERVAL			300		

@interface PhotoViewController (private)
- (void)adjustPhotoViews;
- (void)reloadPhotoData;
@end

@implementation PhotoViewController
@synthesize delegate = delegate_ ;
- (id)init {
    self = [super init];
    if (self) {
		showIndex = 0 ;
    }

    return self;
}

- (void)loadView{
	UIView* view = [[[UIView alloc] init] autorelease];
	CGRect screenRect = [UIScreen mainScreen].applicationFrame ;
	
	view.frame = CGRectMake(0, 20, screenRect.size.width, screenRect.size.height);
	view.backgroundColor = [UIColor whiteColor];
	UIImage* bgImage = [UIImage imageNamed:@"Default"];
	NSAssert((bgImage != nil), @"Default.png is not exist.");

	CALayer* bgLayer = [CALayer layer];
	bgLayer.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
	bgLayer.contents = (UIView*)bgImage.CGImage ;
	[view.layer addSublayer:bgLayer];

	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.frame = CGRectMake((screenRect.size.width-INDICATOR_W)/2,
								 (screenRect.size.height-INDICATOR_H)/2,
								 INDICATOR_W,
								 INDICATOR_H);
	indicator.hidden = YES;
	indicator.backgroundColor = [UIColor blackColor];
	indicator.alpha = 0.7;
	
	[indicator.layer setCornerRadius:10.0f];
	[view addSubview:indicator];
	
	photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
	photoScrollView.backgroundColor = [UIColor clearColor];
	photoScrollView.contentSize = CGSizeMake(320, 320*(PHOTO_NUM-2));
	photoScrollView.showsHorizontalScrollIndicator = NO;
	photoScrollView.showsVerticalScrollIndicator = NO;
	photoScrollView.delegate = self;
	
	[view addSubview:photoScrollView];
	
	self.view = view ;
}

- (void)viewDidLoad{
	if( photoViewArray == nil || [photoViewArray count] == 0 ){
		//show indicator
		indicator.hidden = NO;
		[indicator startAnimating];
		
		//get photo data json
		if([delegate_ respondsToSelector:@selector(photoViewController:requestPhotoDataJSON:)] ){
			[delegate_ photoViewController:self 
					  requestPhotoDataJSON:POPULAR_PHOTO];
		}
		
		reloadTimer = [[NSTimer scheduledTimerWithTimeInterval:RELOAD_INTERVAL
														target:self 
													  selector:@selector(reloadPhotoData)
													  userInfo:nil
													   repeats:YES] retain];
	}
}

- (void)dealloc{
	[photoViewArray removeAllObjects];
	[photoViewArray release];
	[indicator release];
	[photoScrollView release];
	[super dealloc];
}

#pragma mark - instance Method
- (void)setPhotoImage:(UIImage*)image index:(int)index{
	NSLog(@"index:%d",index);
	PhotoView* view = [photoViewArray objectAtIndex:index];
	[view setPhotoImage:image];
}

- (void)moveContentOffset{
	photoScrollView.contentOffset = CGPointMake(0, photoScrollView.contentOffset.y+1);
	[self adjustPhotoViews];
}

- (void)stopAutoScroll{
	[timer invalidate];
	[timer release];
	timer = nil ;
}

- (void)startAutoScroll{
	[self stopAutoScroll];
	timer = [[NSTimer scheduledTimerWithTimeInterval:SCROLL_TIME_INTERVAL
											  target:self 
											selector:@selector(moveContentOffset) 
											userInfo:nil 
											 repeats:YES] retain];
}

- (void)reloadPhotoData{
	if([delegate_ respondsToSelector:@selector(photoViewController:requestPhotoDataJSON:)] ){
		[delegate_ photoViewController:self 
				  requestPhotoDataJSON:POPULAR_PHOTO];
	}
}

- (void)adjustPhotoViews{
	// 初回表示時
	if( [[photoScrollView subviews] count] == 0 ){
		for( int i = 0 ; i < SCROLL_PHOTO_NUM ; i++ ){
			PhotoView* photoView = [photoViewArray objectAtIndex:i];
			CGRect rect = CGRectMake(photoView.frame.origin.x, photoView.frame.size.height*i-photoView.frame.size.height, photoView.frame.size.width, photoView.frame.size.height);
			photoView.frame = rect ;
			[photoScrollView addSubview:photoView];
		}
		
		[self startAutoScroll];
	}
	
	// 一つの写真が完全に隠れた場合にviewを再構築
	PhotoView* photoView = [photoViewArray objectAtIndex:0];
	if( photoScrollView.contentOffset.y >= photoView.frame.size.height ){
		int unvisibleViewNum = photoScrollView.contentOffset.y/photoView.frame.size.height ;

		NSArray* views = [photoScrollView subviews];
		for( UIView* v in views){
			[v removeFromSuperview];
		}

		showIndex += unvisibleViewNum ;

		if (showIndex >= PHOTO_NUM) {
			showIndex -= PHOTO_NUM ;
		}
		
		for( int i = 0 ; i < SCROLL_PHOTO_NUM ; i++ ){
			int index = showIndex + i ;
 			
			if( index >= PHOTO_NUM){
				index -= PHOTO_NUM;
			}
			
			PhotoView* photoView = [photoViewArray objectAtIndex:index];
			CGRect rect = CGRectMake(photoView.frame.origin.x, photoView.frame.size.height*i-photoView.frame.size.height, photoView.frame.size.width, photoView.frame.size.height);
			photoView.frame = rect ;
			[photoScrollView addSubview:photoView];
		}
	
		[photoScrollView setContentOffset:CGPointMake(0, photoScrollView.contentOffset.y-photoView.frame.size.height*unvisibleViewNum)];
	}
}

- (void)setPhotoDataArray:(NSArray*)dataArray{
	if( photoViewArray != nil || [photoViewArray count] != 0){
		[photoViewArray removeAllObjects];
		[photoViewArray release];
	}
	
	photoViewArray = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];

	// それぞれのviewのセットと画像データの取得を行う
	for( PhotoData* data in dataArray ){
		PhotoView* photoView = [[[PhotoView alloc] initWithData:data delegate:self] autorelease];
		photoView.delegate = self; 
		[photoViewArray addObject:photoView];
	}
	[self adjustPhotoViews];
}

#pragma mark - PhotoViewDelegate
- (void)photoViewRequestPhotoData:(PhotoView *)view{
	if( [delegate_ respondsToSelector:@selector(photoViewController:requestPhotoData:photoIndex:)] ){
		[delegate_ photoViewController:self requestPhotoData:view.photoData.imageUrl photoIndex:view.photoData.index] ;
	}
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	[self adjustPhotoViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[self startAutoScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[self stopAutoScroll];
}

@end
