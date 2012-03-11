//
//  WebConnection.m
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WebConnection.h"
#import "JSON.h"

@implementation WebConnection
static WebConnection* sharedManager = nil ;

- (id)init {
    self = [super init];
    if (self) {
		asyncConnections = [[NSMutableArray alloc] init];
    }
	
    return self;
}

+ (WebConnection*)sharedManager {  
    @synchronized(self) {  
        if (sharedManager == nil) {  
            sharedManager = [[self alloc] init];
        }  
    }  
    return sharedManager;  
}  

+ (id)allocWithZone:(NSZone *)zone {  
    @synchronized(self) {  
        if (sharedManager == nil) {  
            sharedManager = [super allocWithZone:zone];  
            return sharedManager;  
        }  
    }  
    return nil;  
}  

- (id)copyWithZone:(NSZone*)zone {  
    return self;
}  

- (id)retain {  
    return self;
}  

- (unsigned)retainCount {  
    return UINT_MAX;
}  

- (oneway void)release {  
}  

- (id)autorelease {  
    return self;
}  

#pragma mark - Instance Methods
- (id)procResponse:(NSURLResponse*)response data:(NSData*)data{
	NSString* mimeType = [response MIMEType];
	if( [mimeType isEqualToString:MIME_TYPE_JSON] ){
		NSString* jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSDictionary* dic = [jsonStr JSONValue];
		return dic;
	} else if( [mimeType isEqualToString:MIME_TYPE_JPEG] ){
		UIImage* image = [UIImage imageWithData:data];
		return image;
	}
	
	return nil;
}

- (BOOL)getDataSynchronous:(NSString *)urlStr
				   succeed:(WebConnectionResultBlock)succeed 
				   failure:(WebConnectionResultBlock)failure{
	// request
	NSURL *url = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection	sendSynchronousRequest:request
										 returningResponse:&response
													 error:&error];

	// error
	NSString *error_str = [error localizedDescription];
	if (0 < [error_str length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RequestError"
														message:error_str
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return NO;
	}
	
	// response
	id result = [self procResponse:response data:data];
	
	if( result != nil ){
		succeed(result);
	}else{
		failure(result);
	}
	
	return YES;
}

- (BOOL)getDataAsynchronous:(NSString *)urlStr 
					succeed:(WebConnectionResultBlock)succeed
					failure:(WebConnectionResultBlock)failure{
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error) {
								   failure(nil);
								   return;
                               }
							   id result = [self procResponse:response data:data];
							   if( result != nil ){
								   succeed(result);
							   }else{
								   failure(nil);
							   }
                           }];
	
	return YES;
}

@end
