//
//  ALIssueViewController.h
//  DemoProject
//
//  Created by Austin Louden on 7/8/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAGithubEngine.h"

@interface ALIssueViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UAGithubEngine *engine;
@property (nonatomic, strong) NSDictionary *repository;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *asignees;
@property (nonatomic, strong) NSArray *milestones;
@property (nonatomic, strong) NSMutableDictionary *issueDictionary;
@end
