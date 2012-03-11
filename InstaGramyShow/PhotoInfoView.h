//
//  PhotoInfoView.h
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "PhotoData.h"

@protocol PhotoInfoViewDelegate;

@interface PhotoInfoView : UIView{
	UIControl* controlView;
}

- (id)initWithFrame:(CGRect)frame photoData:(PhotoData*)data ;

@property (nonatomic, assign) id<PhotoInfoViewDelegate> delegate;
@end

@protocol PhotoInfoViewDelegate <NSObject>
- (void)photoInfoViewDidTouchUpInside:(PhotoInfoView*)photoInfoView ;
@end