//
//  SBIssueViewController.h
//  DemoProject
//
//  Created by Austin Louden on 7/8/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAGithubEngine.h"

@interface SBIssueViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UAGithubEngine *engine;
@property (nonatomic, strong) NSDictionary *repository;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *asignees;
@property (nonatomic, strong) NSArray *milestones;
@property (nonatomic, strong) NSMutableDictionary *issueDictionary;
@property (nonatomic, strong) NSString *defaultAssignee;
@property (nonatomic, strong) NSString *defaultMilestone;
@property BOOL attachDeviceInfo;
- (id)initWithAssignee:(NSString*)assignee milestone:(NSString*)milestone;
@end
