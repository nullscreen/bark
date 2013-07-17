//
//  SBLoginViewController.m
//  DemoProject
//
//  Created by Austin Louden on 7/12/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBLoginViewController.h"
#import "UAGithubEngine.h"
#import "SBWindow.h"
#import "SBIssueViewController.h"
#import "UICKeyChainStore.h"

@interface SBLoginViewController ()
{
    UITextField *nameField;
    UITextField *passField;
    UIButton *loginButton;
    CGFloat animatedDistance;
}
@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation SBLoginViewController
@synthesize repositoryName = _repositoryName, defaultMilestone = _defaultMilestone, defaultAssignee = _defaultAssignee;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithWhite:(249.0f/255.0f) alpha:1.0f];
    self.navigationController.navigationBar.hidden = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"github_logo.png"]];
    imageView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(imageView.bounds),40.0f, 175.0f, 47.0f);
    [self.view addSubview:imageView];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 145.0f, self.view.frame.size.width-20, 50.0f)];
    nameField.delegate = self;
    nameField.placeholder = @"Username or Email";
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    nameField.textAlignment = NSTextAlignmentCenter;
    nameField.textColor = [UIColor colorWithWhite:25.0f/255.0f alpha:1.0f];
    [nameField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:nameField];
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 200.0f, self.view.frame.size.width-20, 50.0f)];
    passField.delegate = self;
    passField.placeholder = @"Password";
    passField.returnKeyType = UIReturnKeyDone;
    passField.autocorrectionType = UITextAutocorrectionTypeNo;
    passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passField.backgroundColor = [UIColor whiteColor];
    passField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f];
    passField.textAlignment = NSTextAlignmentCenter;
    passField.textColor = [UIColor colorWithWhite:25.0f/255.0f alpha:1.0f];
    [passField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    passField.secureTextEntry = YES;
    [self.view addSubview:passField];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setBackgroundColor:[UIColor colorWithWhite:(100.0f/255.0f) alpha:1.0f]];
    loginButton.frame = CGRectMake(10.0f, 260.0f, self.view.frame.size.width-20.0f, 50.0f);
    loginButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
    [loginButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginButton.enabled = NO;
    [self.view addSubview:loginButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(self.view.frame.size.width-50.0f, 5.0f, 50, 30.0f);
    cancelButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    [cancelButton setTitle:@"Close" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithWhite:(100.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
}

- (void)login
{
    UAGithubEngine *engine = [[UAGithubEngine alloc] initWithUsername:nameField.text password:passField.text withReachability:YES];
    [engine repository:_repositoryName success:^(id response) {
        [UICKeyChainStore setString:nameField.text forKey:@"username"];
        [UICKeyChainStore setString:passField.text forKey:@"password"];
        SBIssueViewController *issueView = [[SBIssueViewController alloc] initWithAssignee:_defaultAssignee milestone:_defaultMilestone];
        issueView.repository = [response objectAtIndex:0];
        issueView.engine = engine;
        [self.navigationController pushViewController:issueView animated:YES];
    } failure:^(NSError *error) {
        UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:@"Invalid User Credentials"
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"OK", nil];
        [loginAlertView show];
    }];
    
}

- (void)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([[UIScreen mainScreen] bounds].size.height != 568.0f) {
        CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
        CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
        CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
        CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
        CGFloat heightFraction = numerator / denominator;
        
        if (heightFraction < 0.0) {
            heightFraction = 0.0;
        } else if (heightFraction > 1.0) {
            heightFraction = 1.0;
        }
        
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        } else {
            animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        }
        
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y -= animatedDistance;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([[UIScreen mainScreen] bounds].size.height != 568.0f) {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y += animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldChanged
{
    if(nameField.text.length != 0 && passField.text.length != 0) {
        loginButton.enabled = YES;
        [loginButton setBackgroundColor:[UIColor colorWithRed:(0.0f/255.0f) green:(153.0f/255.0f) blue:(255.0f/255.0f) alpha:1.0f]];
    } else if(nameField.text.length == 0 || passField.text.length == 0) {
        loginButton.enabled = NO;
        [loginButton setBackgroundColor:[UIColor colorWithWhite:(100.0f/255.0f) alpha:1.0f]];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
