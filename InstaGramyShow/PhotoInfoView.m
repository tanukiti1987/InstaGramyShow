//
//  PhotoInfoView.m
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoInfoView.h"

#define TITLE_LABEL_X		60
#define TITLE_LABEL_Y		60
#define TITLE_LABEL_W		236
#define TITLE_LABEL_H		60
#define TITLE_FONT_SIZE		30

#define USER_NAME_LABEL_X	60
#define USER_NAME_LABEL_Y	120
#define USER_NAME_LABEL_W	236
#define USER_NAME_LABEL_H	24
#define USER_NAME_FONT_SIZE	24

#define LIKE_IMG_X			10
#define LIKE_IMG_Y			216

#define LIKE_LABEL_X		98
#define LIKE_LABEL_Y		221
#define LIKE_LABEL_W		70
#define LIKE_LABEL_H		50
#define LIKE_FONT_SIZE		30

#define COMMENT_IMG_X		163
#define COMMENT_IMG_Y		211

#define COMMENT_LABEL_X		231
#define COMMENT_LABEL_Y		221
#define COMMENT_LABEL_W		70
#define COMMENT_LABEL_H		50
#define COMMENT_FONT_SIZE	LIKE_FONT_SIZE

@interface PhotoInfoView (private)
- (void)didTouchUpInside;
@end

@implementation PhotoInfoView
@synthesize delegate = delegate_;

- (id)initWithFrame:(CGRect)frame photoData:(PhotoData*)data {
    self = [super init];
    if (self) {
		self.backgroundColor = [UIColor clearColor] ;
		self.frame = frame ;
		self.clipsToBounds = YES;
		[self.layer setCornerRadius:5.0f];
		
		controlView = [[[UIControl alloc] initWithFrame:self.frame] autorelease];
		controlView.backgroundColor = [UIColor whiteColor] ;
		controlView.alpha = 0.7 ;
		controlView.clipsToBounds = YES;
		[controlView.layer setCornerRadius:5.0f];
		[controlView addTarget:self action:@selector(didTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:controlView];
		
        UILabel* titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_X,
																		 TITLE_LABEL_Y, 
																		 TITLE_LABEL_W, 
																		 TITLE_LABEL_H)] autorelease];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.text = data.title;
		titleLabel.font = [UIFont fontWithName:@"ArialMT" size:TITLE_FONT_SIZE];
		titleLabel.textAlignment = UITextAlignmentLeft;
		[titleLabel setLineBreakMode:UILineBreakModeWordWrap];//改行モード
		[titleLabel setNumberOfLines:2];
		[self addSubview:titleLabel];

        UILabel* userNameLabel = [[[UILabel alloc] initWithFrame:CGRectMake(USER_NAME_LABEL_X,
																			USER_NAME_LABEL_Y, 
																			USER_NAME_LABEL_W, 
																			USER_NAME_LABEL_H)] autorelease];
		userNameLabel.backgroundColor = [UIColor clearColor];
		userNameLabel.text = [NSString stringWithFormat:@"@%@",data.userName];
		userNameLabel.font = [UIFont fontWithName:@"ArialMT3" size:USER_NAME_FONT_SIZE];
		userNameLabel.textAlignment = UITextAlignmentRight;
//		userNameLabel.textColor = [UIColor grayColor];
		[userNameLabel setLineBreakMode:UILineBreakModeWordWrap];//改行モード
		[userNameLabel setNumberOfLines:0];
		
		[self addSubview:userNameLabel];

		UIImage* likeImage = [UIImage imageNamed:@"like"];
		NSAssert((likeImage != nil), @"like.png is not exist.");
		CALayer* likeLayer = [CALayer layer];
		likeLayer.contents = (UIView*)likeImage.CGImage;
		likeLayer.frame = CGRectMake(LIKE_IMG_X, LIKE_IMG_Y, likeImage.size.width, likeImage.size.height);
		likeLayer.backgroundColor = [[UIColor clearColor] CGColor];
		
		[self.layer addSublayer:likeLayer];
		
        UILabel* likeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(LIKE_LABEL_X,
																		LIKE_LABEL_Y, 
																		LIKE_LABEL_W, 
																		LIKE_LABEL_H)] autorelease];
		likeLabel.backgroundColor = [UIColor clearColor];
		likeLabel.text = [NSString stringWithFormat:@"%d",data.likes];
		likeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:LIKE_FONT_SIZE];
		likeLabel.textAlignment = UITextAlignmentLeft;
		
		[self addSubview:likeLabel];

		UIImage* commentImage = [UIImage imageNamed:@"comment"];
		NSAssert((commentImage != nil), @"comment.png is not exist.");
		CALayer* commentLayer = [CALayer layer];
		commentLayer.contents = (UIView*)commentImage.CGImage;
		commentLayer.frame = CGRectMake(COMMENT_IMG_X, COMMENT_IMG_Y, commentImage.size.width, commentImage.size.height);
		commentLayer.backgroundColor = [[UIColor clearColor] CGColor];
		
		[self.layer addSublayer:commentLayer];
		
        UILabel* commentLabel = [[[UILabel alloc] initWithFrame:CGRectMake(COMMENT_LABEL_X,
																		   COMMENT_LABEL_Y, 
																		   COMMENT_LABEL_W, 
																		   COMMENT_LABEL_H)] autorelease];
		commentLabel.backgroundColor = [UIColor clearColor];
		commentLabel.text = [NSString stringWithFormat:@"%d",data.comments];
		commentLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:COMMENT_FONT_SIZE];
		commentLabel.textAlignment = UITextAlignmentLeft;
		
		[self addSubview:commentLabel];
    }
    return self;
}

- (void)dealloc{
	[controlView release];
	[super dealloc];
}

- (void)didTouchUpInside{
	if( [delegate_ respondsToSelector:@selector(photoInfoViewDidTouchUpInside:)] ){
		[delegate_ photoInfoViewDidTouchUpInside:self];
	}
}

@end
