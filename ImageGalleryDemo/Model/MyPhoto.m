//
//  MyPhoto.m
//  EGOPhotoViewerDemo_iPad
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyPhoto.h"

@implementation MyPhoto

@synthesize URL=_URL;
@synthesize caption=_caption;
@synthesize image=_image;
@synthesize size=_size;
@synthesize failed=_failed;

- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName image:(UIImage*)aImage{
	
	if (self = [super init]) {
#if !__has_feature(objc_arc)	
		_URL=[aURL retain];
		_caption=[aName retain];
		_image=[aImage retain];
#else
        _URL=aURL;
		_caption=aName;
		_image=aImage;
#endif
	}
	
	return self;
}

- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName{
	return [self initWithImageURL:aURL name:aName image:nil];
}

- (id)initWithImageURL:(NSURL*)aURL{
	return [self initWithImageURL:aURL name:nil image:nil];
}

- (id)initWithImage:(UIImage*)aImage{
	return [self initWithImageURL:nil name:nil image:aImage];
}

#if !__has_feature(objc_arc)
- (void)dealloc{
	[_URL release], _URL=nil;
	[_image release], _image=nil;
	[_caption release], _caption=nil;
	[super dealloc];
}
#endif


@end
