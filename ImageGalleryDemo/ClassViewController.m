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
#import "NSMutableURLRequest+XSURLRequest.h"
#import "EGOPhotoGlobal.h"
#import "MyPhotoSource.h"
#import "MyPhoto.h"
#import "WebViewJavascriptBridge.h"

@interface ClassViewController ()
{
    HomeView *homeView;
    UIButton *loginButton;
    UIButton *showImageButton;
    UIWebView *webView;
    NSString *_url;
    NSString *_previousUrl;
    WebViewJavascriptBridge *bridge;
}
@property (nonatomic, strong) FBRequestConnection *requestConnection;
@end

@implementation ClassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    homeView = [[HomeView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(0, 0, 100, 30);
    [loginButton setTitle:@"login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [homeView addSubview: loginButton];
    
    showImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    showImageButton.frame = CGRectMake(100, 0, 100, 30);
    [showImageButton setTitle:@"show image" forState:UIControlStateNormal];
    [showImageButton addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
    [homeView addSubview: showImageButton];

    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,homeView.frame.size.height ,homeView.frame.size.width)];
    webView.scalesPageToFit = YES;
    webView.autoresizesSubviews = YES;
   [webView stringByEvaluatingJavaScriptFromString:@"var e = document.createEvent('Events'); e.initEvent('orientationchange', true, false); document.dispatchEvent(e);"];
    
    _url = @"http://www.realestate.com.au/home-ideas/";
    //    _url = @"http://10.18.10.2:8080";
    [self loadUrl: _url];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies]) {
        NSLog(@"------%@", cookie);
    }
    

    [homeView addSubview:webView];
    self.view = homeView;
    
    [WebViewJavascriptBridge enableLogging];
    
    bridge = [WebViewJavascriptBridge bridgeForWebView:webView handler:^(id data, WVJBResponse *response) {
        NSLog(@"=====%@", data);
        NSDictionary *actualData = data;
        NSString *pageUrl = [actualData objectForKey:@"pageUrl"];
        NSLog(@"==pageUrl:%@", pageUrl);
        NSString *imageUrl = [actualData objectForKey:@"imageUrl"];
        NSLog(@"==imageUrl:%@", imageUrl);
        [self showGallery:pageUrl andImageUrl:imageUrl];
    }];
    webView.delegate = self;
}

- (void) loadUrl: (NSString*) urlStr
{
    NSLog(@"###########loading url :%@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
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
    FBRequestHandler handler =
    ^(FBRequestConnection *connection, id result, NSError *error) {
        [self requestCompleted:connection andResult:result andError:error];
    };
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
    [self setHomeIdeasCookie:userInfo andVanityUrl:user.username];
    [self loadUrl:_url];
//    NSLog(@"------------");
//    
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (cookie in [cookieJar cookies]) {
//        NSLog(@"------%@", cookie);
//    }
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

-(void)setHomeIdeasCookie:(NSString *)token andVanityUrl:(NSString *)vanityUrl
{

    NSMutableURLRequest * request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];

    XSCookie * cookie1=[[XSCookie alloc] initForDomain:_url withName:@"s_tok" value:token];
    XSCookie * cookie2=[[XSCookie alloc] initForDomain:_url withName:@"s_vani" value:vanityUrl];
    
    NSArray * myCookieBag=[NSArray arrayWithObjects:cookie1,cookie2,nil];
    
    [request setAllCookies:myCookieBag];
    [webView loadRequest:request];
}

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://www.realestate.com.au/home-ideas/api/results-kitchens-modern/list-1"]

-(void)showImage:(id)sender{
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

-(void) showGallery:(NSString*) pageUrl andImageUrl:(NSString*) imageUrl
{
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:pageUrl]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    [json enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop){
        NSString *keyValue = key;
        NSLog(@"======================%@", keyValue);
     }];
    
    NSArray* images = [json objectForKey:@"images"]; //2
    
    NSMutableArray *photos = [[NSMutableArray alloc] initWithCapacity:[images count]];
    for (NSDictionary *image in images) {
        NSString *imageUrl = [image objectForKey:@"imageUrl"];
        MyPhoto *myPhoto = [[MyPhoto alloc] initWithImageURL:[NSURL URLWithString:imageUrl]];
        [photos addObject:myPhoto];
        NSLog(@"====%@", imageUrl);
    }
    
    MyPhotoSource *source = [[MyPhotoSource alloc] initWithPhotos:photos];
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoController];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:navController animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *currentUrl = request.URL.relativePath;
    if (!currentUrl) {
        return NO;
    }
    NSLog(@"===url:%@", currentUrl);
    NSRange findGallery = [currentUrl rangeOfString:@"gallery-"];
    NSRange findResult = [currentUrl rangeOfString:@"results-"];
    if (findGallery.location != NSNotFound) {
        NSLog(@"===NO:%@", _previousUrl);
        NSMutableString *apiUrl = [NSMutableString stringWithString:@"http://www.realestate.com.au/"];
        [apiUrl appendString:[_previousUrl stringByReplacingOccurrencesOfString:@"home-ideas" withString:@"home-ideas/api"]];
        NSLog(@"===apiUrl:%@", apiUrl);
        [self showGallery:apiUrl andImageUrl:currentUrl];
        return NO;
    } else if (findResult.location != NSNotFound){
        NSLog(@"===find url:%@", currentUrl);
        _previousUrl = currentUrl;
    }
    NSLog(@"===YES");
    return YES;
}
@end
