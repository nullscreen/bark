//
//  SBLoginViewController.m
//  DemoProject
//
//  Created by Austin Louden on 7/12/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBLoginViewController.h"

@interface SBLoginViewController ()
{
    UITextField *nameField;
    UITextField *passField;
    UIButton *loginButton;
}
@end

@implementation SBLoginViewController

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"github_logo.png"]];
    imageView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - CGRectGetMidX(imageView.bounds),40.0f, 175.0f, 47.0f);
    [self.view addSubview:imageView];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 145.0f, self.view.frame.size.width-20, 50.0f)];
    nameField.delegate = self;
    nameField.placeholder = @"Username or Email";
    nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    nameField.textAlignment = NSTextAlignmentCenter;
    nameField.textColor = [UIColor colorWithWhite:25.0f/255.0f alpha:1.0f];
    [nameField addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:nameField];
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 200.0f, self.view.frame.size.width-20, 50.0f)];
    passField.delegate = self;
    passField.placeholder = @"Password";
    passField.autocorrectionType = UITextAutocorrectionTypeNo;
    passField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passField.backgroundColor = [UIColor whiteColor];
    passField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
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
    loginButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [loginButton setTitle:@"Sign in" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    loginButton.enabled = NO;
    [self.view addSubview:loginButton];
    
}

- (void)textFieldChanged
{
    if(nameField.text.length != 0 && passField.text.length != 0) {
        loginButton.enabled = YES;
        [loginButton setBackgroundColor:[UIColor colorWithRed:(43.0f/255.0f) green:(216.0f/255.0f) blue:(252.0f/255.0f) alpha:1.0f]];
    }
}

- (void)login
{
    NSLog(@"login");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
