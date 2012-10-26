//
//  MyPhotoSource.m
//  EGOPhotoViewerDemo_iPad
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyPhotoSource.h"


@implementation MyPhotoSource

@synthesize photos=_photos;
@synthesize numberOfPhotos=_numberOfPhotos;


- (id)initWithPhotos:(NSArray*)photos{
	
	if (self = [super init]) {
#if !__has_feature(objc_arc)		
		_photos = [photos retain];
#else
        _photos = photos;
#endif
		_numberOfPhotos = [_photos count];
		
	}
	
	return self;

}

- (id <EGOPhoto>)photoAtIndex:(NSInteger)index{
	
	return [_photos objectAtIndex:index];
	
}

- (void)dealloc{
#if !__has_feature(objc_arc)
	[_photos release],
    _photos=nil;
	[super dealloc];
#else
    _photos=nil;
#endif
}

@end
