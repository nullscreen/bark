//
//  ALAppDelegate.h
//  DemoProject
//
//  Created by Austin Louden on 7/3/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBWindow.h"

@interface SBAppDelegate : UIResponder <UIApplicationDelegate, SBWindowDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
