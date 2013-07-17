//
//  SBLoginViewController.h
//  DemoProject
//
//  Created by Austin Louden on 7/12/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SBLoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) NSString *repositoryName;
@property (nonatomic, strong) NSString *defaultAssignee;
@property (nonatomic, strong) NSString *defaultMilestone;
@end
