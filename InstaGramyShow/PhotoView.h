//
//  PhotoView.h
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoData.h"
#import "PhotoInfoView.h"

@protocol PhotoViewDelegate ;

@interface PhotoView : UIView <PhotoInfoViewDelegate>{
	UIView*						infoView_ ;
	UIView*						photo;
	UIActivityIndicatorView*	indicator;
	PhotoInfoView*				infoView ;
}

- (id)initWithData:(PhotoData*)data delegate:(id)dlgt;
- (void)setPhotoImage:(UIImage*)image ;

@property (nonatomic, assign) PhotoData* photoData ;
@property (nonatomic, assign) id<PhotoViewDelegate> delegate;

@end

@protocol PhotoViewDelegate <NSObject>
- (void)photoViewRequestPhotoData:(PhotoView*)view;
@end
