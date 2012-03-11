//
//  PhotoViewController.h
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoView.h"

@protocol PhotoViewControllerDelegate;

@interface PhotoViewController : UIViewController <PhotoViewDelegate,UIScrollViewDelegate> {
	NSMutableArray*				photoViewArray;
	UIActivityIndicatorView*	indicator;
	UIScrollView*				photoScrollView;
	int							showIndex;		// 画面上部に表示されている写真インデックス
	NSTimer*					timer;
	NSTimer*					reloadTimer;
}

- (void)setPhotoDataArray:(NSArray*)dataArray;
- (void)setPhotoImage:(UIImage*)image index:(int)index;

@property (nonatomic, assign) id<PhotoViewControllerDelegate> delegate ;

@end

@protocol PhotoViewControllerDelegate <NSObject>
- (void)photoViewController:(PhotoViewController*)vc requestPhotoDataJSON:(PhotoDataType)type;
- (void)photoViewController:(PhotoViewController *)vc requestPhotoData:(NSString*)url photoIndex:(int)index;
@end