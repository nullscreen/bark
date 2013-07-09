//
//  ALIssueViewController.h
//  DemoProject
//
//  Created by Austin Louden on 7/8/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALIssueViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSDictionary *repository;
@property (nonatomic, strong) NSDictionary *issueDictionary;
@end
