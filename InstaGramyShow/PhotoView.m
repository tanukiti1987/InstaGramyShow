//
//  PhotoView.m
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoView.h"

#define PHOTO_VIEW_WIDTH	320
#define PHOTO_VIEW_HEIGHT	320

#define INDICATOR_WIDTH		50
#define INDICATOR_HEIGHT	50

@interface PhotoView(private)
- (void)flipView;
@end

@implementation PhotoView
@synthesize photoData = photoData_ ;
@synthesize delegate = delegate_;

- (id)initWithData:(PhotoData*)data delegate:(id)dlgt{
	self = [super init];
	
	if( self ){
		photoData_ = [data retain];
		self.delegate = dlgt;
		self.userInteractionEnabled = YES;
		self.frame = CGRectMake(0, 0, PHOTO_VIEW_WIDTH, PHOTO_VIEW_HEIGHT);
		photo = [[UIView alloc] initWithFrame:CGRectMake(7, 7, 306, 306)];
		photo.backgroundColor = [UIColor blackColor];
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		indicator.frame = CGRectMake((photo.frame.size.width-INDICATOR_WIDTH)/2,
									 (photo.frame.size.height-INDICATOR_HEIGHT)/2,
									 INDICATOR_WIDTH,
									 INDICATOR_HEIGHT);
		[indicator startAnimating];
		[photo addSubview:indicator];
		
		UIImage* bgImage = [UIImage imageNamed:@"photo_bg"];
		NSAssert((bgImage != nil), @"photo_bg.png is not exist.");
		
		CALayer* bgLayer = [CALayer layer];
		bgLayer.frame = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
		bgLayer.contents = (UIView*)bgImage.CGImage ;
		[self.layer addSublayer:bgLayer];

		[self addSubview:photo];
		
		// Control
		UIControl* controlView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		[controlView addTarget:self action:@selector(flipView) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:controlView];
		
		if( photoData_.image == nil ){
			if( [delegate_ respondsToSelector:@selector(photoViewRequestPhotoData:)] ){
				[delegate_ photoViewRequestPhotoData:self];
			}
		}
		
		// photoInfoView
		infoView = [[[PhotoInfoView alloc] initWithFrame:photo.frame photoData:photoData_] autorelease];
		infoView.frame = self.frame ;
		infoView.delegate = self;
		infoView.hidden = YES;
		[self addSubview:infoView];
	}
	
	return self;
}

- (void)dealloc{
	[photo release];
	self.photoData = nil;
	[infoView release];
	[super dealloc];
}

#pragma mark - instance methods
- (void)setPhotoImage:(UIImage*)image{
	self.photoData.image = image ;
	
	[indicator removeFromSuperview];
	CALayer* layer = [CALayer layer];
	layer.frame = CGRectMake(0, 0, photo.frame.size.width, photo.frame.size.height);
	layer.contents = (UIView*)image.CGImage ;
	
	photo.clipsToBounds = YES;
	[photo.layer setCornerRadius:5.0f];
	[photo.layer addSublayer:layer];
}

- (void)flipView{
	CGContextRef context = UIGraphicsGetCurrentContext();

    [UIView beginAnimations: @"TransitionAnimation" context:context];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
						   forView:self
							 cache:NO];
	infoView.hidden = NO;
    [UIView commitAnimations];
}

#pragma mark - PhotoInfoViewDelegate
- (void)photoInfoViewDidTouchUpInside:(PhotoInfoView *)photoInfoView{
	CGContextRef context = UIGraphicsGetCurrentContext();

    [UIView beginAnimations: @"TransitionAnimation" context:context];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
						   forView:self
							 cache:NO];
	photoInfoView.hidden = YES;
	[UIView commitAnimations];
}
@end
