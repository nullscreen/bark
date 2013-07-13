//
//  ALWindow.m
//  DemoProject
//
//  Created by Austin Louden on 7/3/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBWindow.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <sys/utsname.h>
#import "UAGithubEngine.h"
#import "SBIssueViewController.h"
#import "SBLoginViewController.h"

@implementation SBWindow
@synthesize emailSubject = _emailSubject, emailRecipients = _emailRecipients, emailBody = _emailBody,
            attachScreenshot = _attachScreenshot, repositoryName = _repositoryName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _attachScreenshot = YES;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Send Email", @"Create GitHub Issue", nil];
        [actionSheet showInView:self];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [self showEmailView];
    } else if (buttonIndex == 1) {
        
        SBLoginViewController *loginViewController = [[SBLoginViewController alloc] init];
        [self.rootViewController presentViewController:loginViewController animated:YES completion:nil];
        
        /*
        UAGithubEngine *engine = [[UAGithubEngine alloc] initWithUsername:@"austinlouden@gmail.com" password:@"3LOFuWw1" withReachability:YES];
        [engine repository:_repositoryName success:^(id response) {
            SBIssueViewController *issueView = [[SBIssueViewController alloc] init];
            issueView.repository = [response objectAtIndex:0];
            issueView.engine = engine;
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:issueView];
            [self.rootViewController presentViewController:navController animated:YES completion:nil];
        } failure:^(NSError *error) {
            NSLog(@"Request failed with error: %@", error);
        }];
         */
         
        
    }
}

#pragma mark - MFMailComposer

- (void)showEmailView
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        // set subject, recipients
        [mailer setSubject:_emailSubject ? _emailSubject : @""];
        if(_emailRecipients) {
            [mailer setToRecipients:_emailRecipients];
        }
        
        // get app version, build number, ios version
        NSString *iosVersion = [UIDevice currentDevice].systemVersion;
        NSString *iphoneModel = machineName();
        NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString *build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        NSString *defaultBody = [NSString stringWithFormat:@"Issue:\n\nExpected Behavior:\n\niOS Version: %@\nModel: %@\nApp Version: %@\nBuild: %@", iosVersion, iphoneModel, appVersion,build];
        [mailer setMessageBody:_emailBody ? _emailBody : defaultBody isHTML:NO];
        
        // take screen shot - note, this will not capture OpenGL ES elements
        if(_attachScreenshot) {
            UIGraphicsBeginImageContext(self.bounds.size);
            [self.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *data = UIImagePNGRepresentation(image);
            [mailer addAttachmentData:data mimeType:@"image/png" fileName:@"screenshot"];
        }
        
        [self.rootViewController presentViewController:mailer animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Your device does not support email."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

NSString* machineName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device = [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
    NSString *deviceString = @"Unknown";
    
    // why is there no switch(NSString) in ObjC
    if([device isEqualToString:@"x86_64"]) {
        return @"iPhone Simulator";
    } else if([device isEqualToString:@"iPod1,1"]) {
        return @"iPod Touch First Generation";
    } else if([device isEqualToString:@"iPod2,1"]) {
        return @"iPod Touch Second Generation";
    } else if([device isEqualToString:@"iPod3,1"]) {
        return @"iPod Touch Third Generation";
    } else if([device isEqualToString:@"iPod4,1"]) {
        return @"iPod Touch Fourth Generation";
    } else if([device isEqualToString:@"iPhone1,1"]) {
        return @"iPhone";
    } else if([device isEqualToString:@"iPhone1,2"]) {
        return @"iPhone 3G";
    } else if([device isEqualToString:@"iPhone2,1"]) {
        return @"iPhone 3GS";
    } else if([device isEqualToString:@"iPad1,1"]) {
        return @"iPad";
    } else if([device isEqualToString:@"iPad2,1"]) {
        return @"iPad 2";
    } else if([device isEqualToString:@"iPad3,1"]) {
        return @"iPad Third Generation";
    } else if([device isEqualToString:@"iPhone3,1"]) {
        return @"iPhone 4";
    } else if([device isEqualToString:@"iPhone4,1"]) {
        return @"iPhone 4S";
    } else if([device isEqualToString:@"iPhone5,1"]) {
        return @"iPhone 5 (model A1428)";
    } else if([device isEqualToString:@"iPhone5,2"]) {
        return @"iPhone 5 (model A1429)";
    } else if([device isEqualToString:@"iPad3,4"]) {
        return @"iPad Fourth Generation";
    } else if([device isEqualToString:@"iPad2,5"]) {
        return @"iPad Mini";
    }
    
    return deviceString;
}

@end
