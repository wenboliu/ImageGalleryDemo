//
//  NSMutableURLRequest+XSURLRequest.h
//  XSRequest - X Server Request Class
//
//  Created by Yichao Peak Ji on 11-11-22.
//  Copyright (c) 2011 PeakJi Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XSCookie.h"
@class XSCookie;

@interface NSMutableURLRequest (XSURLRequest)

-(void)setCookie:(XSCookie *)cookie;
-(void)setAllCookies:(NSArray *)cookies;

@end
