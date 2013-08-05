//
//  SBAppDelegate.m
//  DemoProject
//
//  Created by Austin Louden on 7/3/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBAppDelegate.h"
#import "SBRootViewController.h"
#import "SBWindow.h"

@implementation SBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // create an instance of the SBWindow subclass which will dispatch kSBWindowDidShakeNotification when window shake
    SBWindow *window = [[SBWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // configure bart
    SBBark *bark = [SBBark sharedBark];
    bark.repositoryName = @"stagebloc/bark";
    bark.delegate = self;
    // hook bark to shake motion
    [[NSNotificationCenter defaultCenter] addObserverForName:kSBWindowDidShakeNotification object:window queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [bark showBark];
    }];
    
    /* optional settings
     
     // email
     bark.emailRecipients = @[@"hi@stagebloc.com", @"ratchet@stagebloc.com"];
     bark.emailSubject = @"Subject";
     bark.emailBody = @"Body"; // note that this will override sending device info
     bark.attachScreenshot = YES; // defaults to YES
     
     // github
     bark.defaultAssignee = @"austinlouden";
     bark.defaultMilestone = @"1.0";
     bark.attachDeviceInfo = YES; // defaults to YES
     */
    
    self.window = window;
    
    // Override point for customization after application launch.
    SBRootViewController *rootViewController = [[SBRootViewController alloc] init];
    self.window.rootViewController = rootViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - SBWindowDelegate

- (BOOL)shouldShowActionSheet
{
    /* 
    add the logic to determine whether or not to show the action sheet. Something like:
     if([currentUser isAdmin]) {
        return YES;
     } else return NO;
    */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
