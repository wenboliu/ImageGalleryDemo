//
//  NSMutableURLRequest+XSURLRequest.m
//  XSRequest - X Server Request Class
//
//  Created by Yichao Peak Ji on 11-11-22.
//  Copyright (c) 2011 PeakJi Design. All rights reserved.
//

#import "NSMutableURLRequest+XSURLRequest.h"

@implementation NSMutableURLRequest (XSURLRequest)
-(void)setCookie:(XSCookie *)cookie{
    [self setAllCookies:[NSArray arrayWithObjects: cookie, nil]];
}

-(void)setAllCookies:(NSArray *)cookies{
    [self setValue:[[NSHTTPCookie requestHeaderFieldsWithCookies:cookies] objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
}

@end
