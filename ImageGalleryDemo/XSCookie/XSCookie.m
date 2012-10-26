//
//  XSCookie.m
//  XSRequest - X Server Request Class
//
//  Created by Yichao Peak Ji on 11-11-22.
//  Copyright (c) 2011 PeakJi Design. All rights reserved.
//

#import "XSCookie.h"

@implementation XSCookie

#pragma mark - Initializing
-(id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(id)initForDomain:(NSString *)domain withName:(NSString *)name value:(NSString *)value{
    self = [super init];
    if (self) {
        self=[NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 domain, NSHTTPCookieDomain,
                                                 @"\\", NSHTTPCookiePath,
                                                 name, NSHTTPCookieName,
                                                 value, NSHTTPCookieValue,
                                                 nil]];
    }
    return self;
}


+(XSCookie *)cookieForDomain:(NSString *)domain withName:(NSString *)name value:(NSString *)value{
    return [[self alloc] initForDomain:domain withName:name value:value];
}


@end
