//
//  ClassAppDelegate.h
//  ImageGalleryDemo
//
//  Created by wenbo on 10/26/12.
//  Copyright (c) 2012 wenbo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestFlight.h"

@class ClassViewController;

@interface ClassAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ClassViewController *viewController;

@end
