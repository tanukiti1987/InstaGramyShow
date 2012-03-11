//
//  WebConnection.h
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@interface WebConnection : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
	NSMutableArray*		asyncConnections;
}

+ (WebConnection*)sharedManager ;
+ (id)allocWithZone:(NSZone *)zone ;

- (BOOL)getDataSynchronous:(NSString*)urlStr succeed:(WebConnectionResultBlock)succeed failure:(WebConnectionResultBlock)failure;
- (BOOL)getDataAsynchronous:(NSString*)urlStr succeed:(WebConnectionResultBlock)succeed failure:(WebConnectionResultBlock)failure;

@end
