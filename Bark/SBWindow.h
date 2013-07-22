//
//  ALWindow.h
//  DemoProject
//
//  Created by Austin Louden on 7/3/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol SBWindowDelegate
@optional
- (BOOL)shouldShowActionSheet;
@end

@interface SBWindow : UIWindow <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, assign) id <SBWindowDelegate> windowDelegate;
@property (nonatomic, strong) NSString *repositoryName;
@property (nonatomic, strong) NSArray *emailRecipients;
@property (nonatomic, strong) NSString *emailSubject;
@property (nonatomic, strong) NSString *emailBody;
@property BOOL attachScreenshot;
@property (nonatomic, strong) NSString *defaultAssignee;
@property (nonatomic, strong) NSString *defaultMilestone;
@property BOOL attachDeviceInfo;
+ (NSString*)machineName;
@end
