//
//  PhotoData.h
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@interface PhotoData : NSObject
@property (nonatomic, assign)	int			index;
@property (nonatomic, copy)		NSString*	userName;
@property (nonatomic, copy)		NSString*	title;
@property (nonatomic, copy)		NSString*	imageUrl;
@property (nonatomic, retain)	UIImage*	image;
@property (nonatomic, assign)	int			likes;
@property (nonatomic, assign)	int			comments;

@end
