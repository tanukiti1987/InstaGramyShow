//
//  PhotoData.m
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoData.h"

@implementation PhotoData

@synthesize index = index_;
@synthesize userName = userName_;
@synthesize title = title_ ;
@synthesize imageUrl = imageUrl_ ;
@synthesize image = image_ ;
@synthesize likes = likes_ ;
@synthesize comments = comments ;		// desire

- (void)dealloc{
	self.userName = nil;
	self.title = nil;
	self.imageUrl = nil;
	[super dealloc];
}

@end
