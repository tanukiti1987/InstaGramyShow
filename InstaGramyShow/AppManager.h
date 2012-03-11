//
//  AppManager.h
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"

@interface AppManager : NSObject<PhotoViewControllerDelegate>{
	PhotoViewController* photoViewController ;
}

+ (AppManager*)sharedManager ;
+ (id)allocWithZone:(NSZone *)zone ;
- (UIView*)view;

@end
