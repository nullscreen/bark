//
//  ALIssueViewController.m
//  DemoProject
//
//  Created by Austin Louden on 7/8/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "ALIssueViewController.h"
#import "UAGithubEngine.h"

@interface ALIssueViewController ()

@end

@implementation ALIssueViewController
@synthesize engine = _engine, repository = _repository, issueDictionary = _issueDictionary, labels = _labels, asignees = _asignees, milestones = _milestones;

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
    self.navigationController.navigationBar.hidden =  YES;
    self.view.backgroundColor = [UIColor colorWithWhite:(245.0f/255.0f) alpha:1.0f];
    [self setupUI];
    [self getRepoData];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
}

- (void)setupUI
{
    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 30.0f)];
    createLabel.text = @"New Issue";
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    createLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    [self.view addSubview:createLabel];
    
    UILabel *repoLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0f, 10.0f, 165.0f, 30.0f)];
    repoLabel.text = [NSString stringWithFormat:@"(%@)", [_repository objectForKey:@"name"]];
    repoLabel.backgroundColor = [UIColor clearColor];
    repoLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    repoLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    [self.view addSubview:repoLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(265.0f, 11.0f, 50.0f, 30.0f);
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
    
    UITextView *bodyField = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 145.0f, self.view.frame.size.width, 150.0f)];
    bodyField.delegate = self;
    bodyField.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    bodyField.backgroundColor = [UIColor whiteColor];
    bodyField.text = @"Leave a comment...";
    [self.view addSubview:bodyField];
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 300.0f, 200.0f, 30.0f)];
    tagLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    tagLabel.text = @"Add Tags";
    tagLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    tagLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tagLabel];
    
    UIButton *createIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [createIssueButton setBackgroundColor:[UIColor colorWithRed:(30.0f/255.0f) green:(71.0f/255.0f) blue:(122.0f/255.0f) alpha:1.0f]];
    createIssueButton.frame = CGRectMake(0.0f, self.view.frame.size.height-50.0f, self.view.frame.size.width, 50.0f);
    createIssueButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    createIssueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    createIssueButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [createIssueButton setTitle:@"Create Issue" forState:UIControlStateNormal];
    [createIssueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createIssueButton addTarget:self action:@selector(createIssuePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createIssueButton];
}

- (void)getRepoData
{
    [_engine labelsForRepository:[_repository objectForKey:@"full_name"] success:^(id response) {
        _labels = response;
    } failure:^(NSError *error) {
        NSLog(@"Request failed with error %@", error);
    }];
    
    [_engine assigneesForRepository:[_repository objectForKey:@"full_name"] success:^(id response) {
        _asignees = response;
    } failure:^(NSError *error) {
        ;
    }];
    
    [_engine milestonesForRepository:@"" success:^(id response) {
        _milestones = response;
    } failure:^(NSError *error) {
        ;
    }];
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

- (void)createIssuePressed:(UIButton *)button
{
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
    self.view.userInteractionEnabled = NO;
    _issueDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Test Issue #1", @"title",
                                                                    @"This is the body of the issue.", @"body",
                                                                    @[@"test"],@"labels", nil];
    [button setTitle:@"Submitting issue..." forState:UIControlStateNormal];
    [_engine addIssueForRepository:[_repository objectForKey:@"full_name"] withDictionary:_issueDictionary success:^(id response) {
        [button setTitle:@"Success!" forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
#pragma mark - UITextViewDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField.text isEqualToString:@"Title"]) {
        textField.text = @"";
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"Leave a comment..."]) {
        textView.text = @"";
    }
    
}

#pragma mark = UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    [self dismissKeyboard];
    return YES;
}

- (void)dismissKeyboard
{
    for(UIView* view in [self.view subviews]) {
        if([view isKindOfClass:[UITextField class]] && [view isFirstResponder]) {
            [view resignFirstResponder];
        } else if ([view isKindOfClass:[UITextView class]] && [view isFirstResponder]) {
            [view resignFirstResponder];
        }
    }
}

@end
