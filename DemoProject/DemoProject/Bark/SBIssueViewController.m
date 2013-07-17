//
//  ALIssueViewController.m
//  DemoProject
//
//  Created by Austin Louden on 7/8/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBIssueViewController.h"
#import "UAGithubEngine.h"
#import <QuartzCore/QuartzCore.h>

#define ASSIGN_BUTTON_TAG 1
#define MILESTONE_BUTTON_TAG 2

@interface SBIssueViewController ()
{
    UITapGestureRecognizer *recognizer;
    UIPickerView *pickerView;
    BOOL showingAssignees;
    
    UITextField *titleField;
    UITextView *bodyField;
    NSString *selectedAssignee;
    NSNumber *selectedMilestone;
    NSMutableArray *selectedLabels;
}

@end

@implementation SBIssueViewController
@synthesize engine = _engine, repository = _repository, issueDictionary = _issueDictionary, labels = _labels, asignees = _asignees, milestones = _milestones;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithAssignee:(NSString*)assignee milestone:(NSString*)milestone
{
    self = [super init];
    if(self) {
        _defaultAssignee = assignee;
        _defaultMilestone = milestone;
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
    
    recognizer = [[UITapGestureRecognizer alloc] init];
    recognizer.delegate = self;
    recognizer.enabled = NO;
    [self.view addGestureRecognizer:recognizer];
    
    selectedLabels = [NSMutableArray array];
}

#pragma mark - Setup

- (void)setupUI
{
    UILabel *createLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 100.0f, 30.0f)];
    createLabel.text = @"New Issue";
    createLabel.backgroundColor = [UIColor clearColor];
    createLabel.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    createLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    [self.view addSubview:createLabel];
    
    UILabel *repoLabel = [[UILabel alloc] initWithFrame:CGRectMake(95.0f, 10.0f, 165.0f, 30.0f)];
    repoLabel.text = [NSString stringWithFormat:@"(%@)", [_repository objectForKey:@"full_name"]];
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
    
    titleField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 45.0f, self.view.frame.size.width, 50.0f)];
    titleField.text = @"Title";
    titleField.delegate = self;
    titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    titleField.backgroundColor = [UIColor colorWithRed:(59.0f/255.0f) green:(123.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f];
    titleField.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f];
    titleField.textAlignment = NSTextAlignmentCenter;
    titleField.textColor = [UIColor whiteColor];
    [self.view addSubview:titleField];
    
    UIButton *assignButton = [UIButton buttonWithType:UIButtonTypeCustom];
    assignButton.frame = CGRectMake(0.0f, 95.0f, self.view.frame.size.width/2, 50.0f);
    assignButton.tag = ASSIGN_BUTTON_TAG;
    [assignButton setBackgroundColor:[UIColor colorWithRed:(61.0f/255.0f) green:(154.0f/255.0f) blue:(232.0f/255.0f) alpha:1.0f]];
    assignButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    assignButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    assignButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [assignButton setTitle:@"Tap to assign\na teammate" forState:UIControlStateNormal];
    [assignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [assignButton addTarget:self action:@selector(assignPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:assignButton];
    
    UIButton *milestoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    milestoneButton.frame = CGRectMake(self.view.frame.size.width/2, 95.0f, self.view.frame.size.width/2, 50.0f);
    milestoneButton.tag = MILESTONE_BUTTON_TAG;
    [milestoneButton setBackgroundColor:[UIColor colorWithRed:(89.0f/255.0f) green:(163.0f/255.0f) blue:(252.0f/255.0f) alpha:1.0f]];
    milestoneButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    milestoneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    milestoneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [milestoneButton setTitle:@"Tap to set\na milestone" forState:UIControlStateNormal];
    [milestoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [milestoneButton addTarget:self action:@selector(milestonePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:milestoneButton];
    
    bodyField = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 145.0f, self.view.frame.size.width, 150.0f)];
    bodyField.delegate = self;
    bodyField.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    bodyField.backgroundColor = [UIColor whiteColor];
    bodyField.text = @"Leave a comment...";
    [self.view addSubview:bodyField];
    
    UIButton *createIssueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [createIssueButton setBackgroundColor:[UIColor colorWithRed:(30.0f/255.0f) green:(30.0f/255.0f) blue:(34.0f/255.0f) alpha:1.0f]];
    createIssueButton.frame = CGRectMake(0.0f, self.view.frame.size.height-50.0f, self.view.frame.size.width, 50.0f);
    createIssueButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    createIssueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    createIssueButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    [createIssueButton setTitle:@"Create Issue" forState:UIControlStateNormal];
    [createIssueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createIssueButton addTarget:self action:@selector(createIssuePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createIssueButton];
}

- (void)setupLabels
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 295.0f, self.view.frame.size.height, self.view.frame.size.height-295.0f-50.0f)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsMultipleSelection = YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, 216)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
}

- (void)getRepoData
{
    
    [_engine labelsForRepository:[_repository objectForKey:@"full_name"] success:^(id response) {
        _labels = response;
        [self setupLabels];
    } failure:^(NSError *error) {
        NSLog(@"Request failed with error %@", error);
    }];
    
    [_engine assigneesForRepository:[_repository objectForKey:@"full_name"] success:^(id response) {
        _asignees = response;
        showingAssignees = YES;
        [pickerView reloadAllComponents];
        
        if(_defaultAssignee) {
            NSLog(@"here %@", _defaultAssignee);
            for(int i=0; i<_asignees.count; i++) {
                if([_defaultAssignee isEqualToString:[[_asignees objectAtIndex:i] objectForKey:@"login"]]) {
                    [pickerView selectRow:i+1 inComponent:0 animated:NO];
                    [self pickerView:pickerView didSelectRow:i+1 inComponent:0];
                }
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Request failed with error %@", error);
    }];
    
    [_engine milestonesForRepository:[_repository objectForKey:@"full_name"] success:^(id response) {
        _milestones = response;
        showingAssignees = NO;
        [pickerView reloadAllComponents];
        
        if(_defaultMilestone) {
            NSLog(@"here %@", _defaultMilestone);
            NSLog(@"%@", _milestones);
            for(int i=0; i<_milestones.count; i++) {
                if([_defaultMilestone isEqualToString:[[_milestones objectAtIndex:i] objectForKey:@"title"]]) {
                    [pickerView selectRow:i+1 inComponent:0 animated:NO];
                    [self pickerView:pickerView didSelectRow:i+1 inComponent:0];
                    NSLog(@"row %d", [pickerView selectedRowInComponent:0]);
                }
            }
        }
        
    } failure:^(NSError *error) {
        NSLog(@"Request failed with error %@", error);
    }];
}

#pragma mark - Actions

- (void)assignPressed
{
    [self dismissKeyboard];
    showingAssignees = YES;
    recognizer.enabled = YES;
    [pickerView reloadAllComponents];
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [pickerView setFrame:CGRectMake(0, self.view.frame.size.height-216, 320, 216)];
    [UIView commitAnimations];
}

- (void)milestonePressed
{
    [self dismissKeyboard];
    showingAssignees = NO;
    recognizer.enabled = YES;
    [pickerView reloadAllComponents];
    
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [pickerView setFrame:CGRectMake(0, self.view.frame.size.height-216, 320, 216)];
    [UIView commitAnimations];
}

- (void)cancelPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createIssuePressed:(UIButton *)button
{
    self.view.userInteractionEnabled = NO;
    
    _issueDictionary = [NSMutableDictionary dictionary];
    if(![titleField.text isEqualToString:@"Title"] && ![titleField.text isEqualToString:@""]) { [_issueDictionary setObject:titleField.text forKey:@"title"]; }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hold on!"
                                                            message:@"Issues must have a title."
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        
        self.view.userInteractionEnabled = YES;
        return;
    }
    
    if(selectedAssignee) { [_issueDictionary setObject:selectedAssignee forKey:@"assignee"]; }
    if(selectedMilestone) { [_issueDictionary setObject:selectedMilestone forKey:@"milestone"]; }
    if(![bodyField.text isEqualToString:@"Leave a comment..."] && ![bodyField.text isEqualToString:@""]) {[_issueDictionary setObject:bodyField.text forKey:@"body"];}
    if(selectedLabels.count > 0) { [_issueDictionary setObject:selectedLabels forKey:@"labels"]; }
    
    __weak typeof(self) weakSelf = self;
    [button setTitle:@"Submitting issue..." forState:UIControlStateNormal];
    [_engine addIssueForRepository:[_repository objectForKey:@"full_name"] withDictionary:_issueDictionary success:^(id response) {
        [button setTitle:@"Success!" forState:UIControlStateNormal];
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    recognizer.enabled = YES;
    if([textField.text isEqualToString:@"Title"]) {
        textField.text = @"";
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    recognizer.enabled = YES;
    if([textView.text isEqualToString:@"Leave a comment..."]) {
        textView.text = @"";
    }
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if(!CGRectContainsPoint(pickerView.frame, [touch locationInView:self.view])) {
        [self dismissKeyboard];
        recognizer.enabled = NO;
    }
    return YES;
}

- (void)dismissKeyboard
{
    for(UIView* view in [self.view subviews]) {
        if([view isKindOfClass:[UITextField class]] && [view isFirstResponder]) {
            [view resignFirstResponder];
        } else if ([view isKindOfClass:[UITextView class]] && [view isFirstResponder]) {
            [view resignFirstResponder];
        } else if ([view isKindOfClass:[UIPickerView class]]) {
            recognizer.enabled = NO;
            [UIView beginAnimations: nil context: NULL];
            [UIView setAnimationDuration: 0.4];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
            [pickerView setFrame:CGRectMake(0, self.view.frame.size.height, 320, 216)];
            [UIView commitAnimations];
        }
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:0]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _labels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell Identifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell Identifier"];
    }
    
    NSDictionary *label = [_labels objectAtIndex:indexPath.row];
    cell.textLabel.text = [label objectForKey:@"name"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:(25.0f/255.0f) alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *labelColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 2.0f, 45.0f)];
    labelColorView.backgroundColor = [self colorFromHexString:[label objectForKey:@"color"]];
    [cell.contentView addSubview:labelColorView];
    
    UIView *labelColorView2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-2.0f, 0.0f, 2.0f, 45.0f)];
    labelColorView2.backgroundColor = [self colorFromHexString:[label objectForKey:@"color"]];
    [cell.contentView addSubview:labelColorView2];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *label = [_labels objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.layer.borderColor = [self colorFromHexString:[label objectForKey:@"color"]].CGColor;
    cell.layer.borderWidth = 2.0f;
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(2.0f, 2.0f, self.view.frame.size.width-4.0f, 41.0f)];
    alphaView.tag = 11;
    CGColorRef alphaColor = [self colorFromHexString:[label objectForKey:@"color"]].CGColor;
    alphaView.backgroundColor = [UIColor colorWithCGColor:CGColorCreateCopyWithAlpha(alphaColor, 0.2f)];
    [cell.contentView addSubview:alphaView];
    [cell.contentView sendSubviewToBack:alphaView];
    
    [selectedLabels addObject:[label objectForKey:@"name"]];
    NSLog(@"%@", selectedLabels);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.layer.borderColor = [UIColor clearColor].CGColor;
    cell.layer.borderWidth = 0.0f;
    
    for(UIView *view in [cell.contentView subviews]) {
        if(view.tag == 11) {
            [view removeFromSuperview];
        }
    }
    
    [selectedLabels removeObject:cell.textLabel.text];
    NSLog(@"%@", selectedLabels);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointZero;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return showingAssignees ? _asignees.count+1 : _milestones.count+1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(row == 0) {
        return showingAssignees ? @"No assignee" : @"No milestone";
    } else {
        NSDictionary *user = showingAssignees ? [_asignees objectAtIndex:row-1] : [_milestones objectAtIndex:row-1];
        return showingAssignees ? [user objectForKey:@"login"] : [user objectForKey:@"title"];
    }
}

#pragma mark = UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    if(showingAssignees) {
        if(row == 0) {
            [(UIButton*)[self.view viewWithTag:ASSIGN_BUTTON_TAG] setTitle:@"Tap to assign\na teammate" forState:UIControlStateNormal];
            selectedAssignee = nil;
        } else {
            [(UIButton*)[self.view viewWithTag:ASSIGN_BUTTON_TAG] setTitle:[NSString stringWithFormat:@"%@\nis assigned", [[_asignees objectAtIndex:row-1] objectForKey:@"login"]] forState:UIControlStateNormal];
            selectedAssignee = [[_asignees objectAtIndex:row-1] objectForKey:@"login"];
        }
    } else {
        if(row == 0) {
            [(UIButton*)[self.view viewWithTag:MILESTONE_BUTTON_TAG] setTitle:@"Tap to set\na milestone" forState:UIControlStateNormal];
            selectedMilestone = nil;
        } else {
            [(UIButton*)[self.view viewWithTag:MILESTONE_BUTTON_TAG] setTitle:[NSString stringWithFormat:@"%@", [[_milestones objectAtIndex:row-1] objectForKey:@"title"]] forState:UIControlStateNormal];
            selectedMilestone = [NSNumber numberWithInt:[[[_milestones objectAtIndex:row-1] objectForKey:@"number"] integerValue]];
        }
    }
}

@end
