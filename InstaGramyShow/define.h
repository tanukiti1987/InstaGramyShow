//
//  define.h
//  InstaGramyShow
//
//  Created by 関口 隆介 on 12/03/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef InstaGramyShow_define_h
#define InstaGramyShow_define_h

typedef enum{
	POPULAR_PHOTO,
	MY_PHOTO,
	FOLLOWERS_PHOTO
} PhotoDataType ;

typedef void (^WebConnectionResultBlock)(id Obj);

#define POPULAR_PHOTOS_URL @"https://api.instagram.com/v1/media/popular?client_id=fb389a262a54413dab41cceace3d2786"

// MIME Type
#define MIME_TYPE_JSON	@"application/json"
#define MIME_TYPE_JPEG	@"image/jpeg"

#endif
