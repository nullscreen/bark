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
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:50.0f/255.0f alpha:1.0];
    self.navigationController.navigationBar.hidden =  YES;
    self.view.backgroundColor = [UIColor colorWithWhite:(245.0f/255.0f) alpha:1.0f];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                                target:self
                                                                                                                action:@selector(cancelPressed)];

    
    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 200.0f, 30.0f)];
    createLabel.text = @"Create an Issue";
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    createLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    [self.view addSubview:createLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(255.0f, 11.0f, 50.0f, 30.0f);
    cancelButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    UITextField *titleField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 45.0f, self.view.frame.size.width, 50.0f)];
    titleField.text = @"Title";
    titleField.delegate = self;
    titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleField.backgroundColor = [UIColor colorWithRed:(59.0f/255.0f) green:(123.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f];
    titleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    titleField.textAlignment = NSTextAlignmentCenter;
    titleField.textColor = [UIColor whiteColor];
    [self.view addSubview:titleField];
    
    UIButton *assignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [assignButton setBackgroundColor:[UIColor colorWithRed:(61.0f/255.0f) green:(154.0f/255.0f) blue:(232.0f/255.0f) alpha:1.0f]];
    assignButton.frame = CGRectMake(0.0f, 95.0f, self.view.frame.size.width/2, 50.0f);
    assignButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    assignButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    assignButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [assignButton setTitle:@"Tap to assign\na teammate" forState:UIControlStateNormal];
    [assignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [assignButton addTarget:self action:@selector(assignPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:assignButton];
    
    UIButton *milestoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [milestoneButton setBackgroundColor:[UIColor colorWithRed:(89.0f/255.0f) green:(163.0f/255.0f) blue:(252.0f/255.0f) alpha:1.0f]];
    milestoneButton.frame = CGRectMake(self.view.frame.size.width/2, 95.0f, self.view.frame.size.width/2, 50.0f);
    milestoneButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    milestoneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    milestoneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [milestoneButton setTitle:@"Tap to set\na milestone" forState:UIControlStateNormal];
    [milestoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [milestoneButton addTarget:self action:@selector(milestonePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:milestoneButton];
    
    UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 150.0f, 200.0f, 30.0f)];
    bodyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    bodyLabel.text = @"Leave a Comment";
    bodyLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    bodyLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bodyLabel];
    
    UITextView *bodyField = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 180.0f, self.view.frame.size.width-20.0f, 150.0f)];
    bodyField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bodyField];
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 330.0f, 200.0f, 30.0f)];
    tagLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    tagLabel.text = @"Add Tags";
    tagLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    tagLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tagLabel];

    
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
