//
//  ALWindow.h
//  DemoProject
//
//  Created by Austin Louden on 7/3/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ALWindow : UIWindow <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) NSArray *emailRecipients;
@property (nonatomic, strong) NSString *emailSubject;
@property (nonatomic, strong) NSString *emailBody;
@property BOOL attachScreenshot;
@end
