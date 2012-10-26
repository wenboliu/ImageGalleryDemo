//
//  ClassViewController.m
//  ImageGalleryDemo
//
//  Created by wenbo on 10/26/12.
//  Copyright (c) 2012 wenbo. All rights reserved.
//

#import "ClassViewController.h"
#import "HomeView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "NSData+Base64.h"

@interface ClassViewController ()
{
    HomeView *homeView;
    UIButton *loginButton;
    UIScrollView *scrollView;
    UIWebView *webView;
}
@property (nonatomic, strong) FBRequestConnection *requestConnection;
@end

@implementation ClassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    homeView = [[HomeView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(0, 0, 100, 50);
    [loginButton setTitle:@"login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homeView addSubview: loginButton];
    
    NSLog(@"-------%f", homeView.frame.size.width);
    NSLog(@"-------%f", homeView.frame.size.height);
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, homeView.frame.size.width, homeView.frame.size.height)];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, homeView.frame.size.width, 2000.00)];
    
    webView.scalesPageToFit = YES;
    webView.autoresizesSubviews = YES;
    
    [self loadUrl:@"http://10.18.10.5:8080"];
    
    
    [scrollView addSubview:webView];
    
    [homeView addSubview:scrollView];
    self.view = homeView;
}

- (void) loadUrl: (NSString*) urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    //    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonClicked:(id)sender{
    NSLog(@"The button was tapped\n");
    if (FBSession.activeSession.isOpen)
    {
        [self sendRequests];
    }
    else
    {
        //         NSArray *permissions = [[NSArray alloc] initWithObjects:@"picture",nil];
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error) {
                                          
                                          NSLog(@"==openActiveSessionWithReadPermissions");
                                          if (error) {
                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                              message:error.localizedDescription
                                                                                             delegate:nil
                                                                                    cancelButtonTitle:@"OK"
                                                                                    otherButtonTitles:nil];
                                              [alert show];
                                          } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                                              
                                              [self sendRequests];
                                          }
                                      }];
    }
}

- (void) sendRequests
{
    NSLog(@"==sendRequests");
    [FBSettings setLoggingBehavior:[NSSet setWithObjects:
                                    FBLoggingBehaviorFBRequests, nil]];
    //    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    //
    //
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        [self requestCompleted:connection andResult:result andError:error];
    };
    //
    //    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
    //                                                      graphPath:@"me/id,name,username,link"];
    //
    //    [newConnection addRequest:request completionHandler:handler];
    //
    //    [self.requestConnection cancel];
    //
    //    self.requestConnection = newConnection;
    //    [newConnection start];
    [FBRequestConnection
     startForMeWithCompletionHandler:handler];
    
}

- (void) requestCompleted: (FBRequestConnection*)connection andResult: (id<FBGraphUser>)user andError: (NSError*)error
{
    if (self.requestConnection &&
        connection != self.requestConnection) {
        return;
    }
    self.requestConnection = nil;
    NSMutableString *userInfo = [[NSMutableString alloc] initWithCapacity:7];
    //    [userInfo appendString:[self base64Encode:user.id]];
    [userInfo appendString:[self base64Encode:@"1"]];
    NSString *separator = @"|";
    [userInfo appendString:separator];
    [userInfo appendString:[self base64Encode:@"avatarUrl"]];
    [userInfo appendString:separator];
    [userInfo appendString:[self base64Encode:user.username]];
    [userInfo appendString:separator];
    [userInfo appendString:[self base64Encode:user.name]];
    [userInfo appendString:separator];
    [userInfo appendString:[self base64Encode:[user objectForKey:@"email"]]];
    [userInfo appendString:separator];
    [userInfo appendString:[self base64Encode:@"token"]];
    [userInfo appendString:separator];
    [userInfo appendString:[self base64Encode:@"loggedInIp"]];
    NSLog(@"============");
    NSLog(@"id :%@", user.id);
    NSLog(@"name :%@", user.name);
    NSLog(@"username :%@", user.username);
    NSLog(@"link :%@", [user objectForKey:@"email"]);
    NSLog(@"test :%@", userInfo);
    NSLog(@"============");
//    [self setHomeIdeasCookie:userInfo andVanityUrl:user.username];
    //    [self loadUrl:_url];
    NSLog(@"------------");
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        NSLog(@"------%@", cookie);
    }
}

-(NSString *)base64Encode:(NSString *)str
{
    NSData *inputData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedString = [inputData base64EncodedString];
#if !__has_feature(objc_arc)
    [encodedString autorelease];
#endif
    return encodedString;
}

@end
