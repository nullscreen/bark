//
//  ALIssueViewController.m
//  DemoProject
//
//  Created by Austin Louden on 7/8/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "ALIssueViewController.h"

@interface ALIssueViewController ()

@end

@implementation ALIssueViewController

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
    self.title = @"Create an Issue";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:50.0f/255.0f alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithWhite:(245.0f/255.0f) alpha:1.0f];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                                target:self
                                                                                                                action:@selector(cancelPressed)];

    
    
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.view.frame.size.width, 50.0f)];
    titleField.text = @"Title";
    titleField.delegate = self;
    titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleField.backgroundColor = [UIColor colorWithWhite:(60.0f/255.0f) alpha:1.0f];
    titleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    titleField.textAlignment = NSTextAlignmentCenter;
    titleField.textColor = [UIColor whiteColor];
    [self.view addSubview:titleField];
    
    UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 78.0f, 200.0f, 30.0f)];
    bodyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    bodyLabel.text = @"Leave a Comment";
    bodyLabel.textColor = [UIColor colorWithWhite:(50.0f/255.0f) alpha:1.0f];
    bodyLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bodyLabel];
    
    UITextView *bodyField = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 110.0f, self.view.frame.size.width-20.0f, 100.0f)];
    bodyField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bodyField];
    
    UIButton *assignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [assignButton setBackgroundColor:[UIColor colorWithWhite:60.0f/255.0f alpha:1.0f]];
    assignButton.frame = CGRectMake(0.0f, 230.0f, self.view.frame.size.width, 50.0f);
    assignButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    [assignButton setTitle:@"Tap to assign a teammate" forState:UIControlStateNormal];
    [assignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [assignButton addTarget:self action:@selector(assignPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:assignButton];
    
    UIButton *milestoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [milestoneButton setBackgroundColor:[UIColor colorWithWhite:60.0f/255.0f alpha:1.0f]];
    milestoneButton.frame = CGRectMake(0.0f, 310.0f, self.view.frame.size.width, 50.0f);
    milestoneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    [milestoneButton setTitle:@"Tap to set a milestone" forState:UIControlStateNormal];
    [milestoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [milestoneButton addTarget:self action:@selector(milestonePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:milestoneButton];

    
}

#pragma mark - Actions

- (void)assignPressed
{
    NSLog(@"assign pressed");
}

- (void)milestonePressed
{
    NSLog(@"milestone pressed");
}

- (void)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@"Title"]) {
        textField.text = @"";
    }
}


@end


//- (void)addIssueForRepository:(NSString *)repositoryPath withDictionary:(NSDictionary *)issueDictionary success:(UAGithubEngineSuccessBlock)successBlock failure:(UAGithubEngineFailureBlock)failureBlock;

/*
 {
 "title": "Found a bug",
 "body": "I'm having a problem with this.",
 "assignee": "octocat",
 "milestone": 1,
 "labels": [
 "Label1",
 "Label2"
 ]
 }
 */
