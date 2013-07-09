//
//  ALIssueViewController.h
//  DemoProject
//
//  Created by Austin Louden on 7/8/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAGithubEngine.h"

@interface ALIssueViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UAGithubEngine *engine;
@property (nonatomic, strong) NSDictionary *repository;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *asignees;
@property (nonatomic, strong) NSMutableDictionary *issueDictionary;
@end
