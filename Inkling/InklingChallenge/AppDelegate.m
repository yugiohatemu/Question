//
//  AppDelegate.m
//  InklingChallenge
//
//  Copyright (c) 2011 Inkling Systems, Inc. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "ImageSearchController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[[MainViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
