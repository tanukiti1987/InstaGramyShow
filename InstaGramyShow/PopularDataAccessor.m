//
//  PopularDataAccessor.m
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopularDataAccessor.h"
#import "PhotoData.h"

@implementation PopularDataAccessor
+ (int)dataCount:(NSDictionary*)data{
	NSArray* array = [data objectForKey:@"data"];
	
	return [array count];
}

+ (NSArray*)popularPhotoData:(NSDictionary*)data{
	if( data == nil || [data isMemberOfClass:[NSNull class]]){
		return nil;
	}
	int dataCount = [PopularDataAccessor dataCount:data];
	
	NSMutableArray* array = [[[NSMutableArray alloc] initWithCapacity:dataCount] autorelease];
	NSArray* dataArray = [data objectForKey:@"data"];

	for( int i = 0 ; i < dataCount ; i++ ){
		PhotoData* photoData = [[[PhotoData alloc] init] autorelease];
		photoData.index = i;
		photoData.userName = [[[dataArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"username"];
		if( ![[[dataArray objectAtIndex:i] objectForKey:@"caption"] isMemberOfClass:[NSNull class]] ){
			photoData.title = [[[dataArray objectAtIndex:i] objectForKey:@"caption"] objectForKey:@"text"];
		}
		
		if( [UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0){
			photoData.imageUrl = [[[[dataArray objectAtIndex:i] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"];
		}else{
			photoData.imageUrl = [[[[dataArray objectAtIndex:i] objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
		}
		photoData.likes = [[[[dataArray objectAtIndex:i] objectForKey:@"likes"] objectForKey:@"count"] intValue];
		photoData.comments = [[[[dataArray objectAtIndex:i] objectForKey:@"comments"] objectForKey:@"count"] intValue] ;

		[array addObject:photoData];
	}
	
	return array;
}

@end
