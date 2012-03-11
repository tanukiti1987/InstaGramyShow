//
//  AppManager.m
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppManager.h"
#import "WebConnection.h"
#import "PopularDataAccessor.h"

@implementation AppManager
static AppManager* sharedManager = nil ;

- (id)init {
    self = [super init];
    if (self) {
		photoViewController = [[PhotoViewController alloc] init];
		photoViewController.delegate = self ;
    }
	
    return self;
}

+ (AppManager*)sharedManager {  
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

- (UIView*)view{
	return photoViewController.view;
}

#pragma mark - PhotoViewControllerDelegate
- (void)photoViewController:(PhotoViewController *)vc 
	   requestPhotoDataJSON:(PhotoDataType)type {
	switch (type) {
		case POPULAR_PHOTO:
		{
			// 成功時
			WebConnectionResultBlock succeed = ^(id Obj){
				NSDictionary* dic = (NSDictionary*)Obj;
				NSArray* photoData = [PopularDataAccessor popularPhotoData:dic];
				// photoViewControllerにセット
				[vc setPhotoDataArray:photoData];
			};
			// 失敗時
			WebConnectionResultBlock failure = ^(id Obj){
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"ConnectionFailure"
																message:@"データの取得に失敗しました。アプリを再起動してください"
															   delegate:nil 
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil, nil];
				[alert show];
				[alert release];
			};
			
			[[WebConnection sharedManager] getDataSynchronous:POPULAR_PHOTOS_URL
													  succeed:succeed
													  failure:failure];
		}
			break;
		default:
			break;
	}
}

- (void)photoViewController:(PhotoViewController *)vc
		   requestPhotoData:(NSString*)url
				 photoIndex:(int)index{
	WebConnectionResultBlock succeed = ^(id Obj){
		// 指定インデックスにデータをセット
		[vc setPhotoImage:Obj index:index];
	};
	WebConnectionResultBlock failure = ^(id Obj){
		// retry
		[self photoViewController:vc requestPhotoData:url photoIndex:index];
	};
	
	[[WebConnection sharedManager] getDataAsynchronous:url
											   succeed:succeed
											   failure:failure];
}

@end
