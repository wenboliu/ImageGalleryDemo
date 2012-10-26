//
//  XSCookie.h
//  XSRequest - X Server Request Class
//
//  Created by Yichao Peak Ji on 11-11-22.
//  Copyright (c) 2011 PeakJi Design. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XSCookie;

@interface XSCookie : NSDictionary
-(id)init;
-(id)initForDomain:(NSString *)domain withName:(NSString *)name value:(NSString *)value;
+(XSCookie *)cookieForDomain:(NSString *)domain withName:(NSString *)name value:(NSString *)value;
@end
