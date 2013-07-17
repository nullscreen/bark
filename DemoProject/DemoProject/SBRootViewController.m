//
//  ALRootViewController.m
//  DemoProject
//
//  Created by Austin Louden on 7/3/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "SBRootViewController.h"

@interface SBRootViewController ()

@end

@implementation SBRootViewController

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
	// Do any additional setup after loading the view.
    
    UILabel *shakeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height/2.0f, self.view.frame.size.width, 100.0f)];
    shakeLabel.numberOfLines = 2;
    shakeLabel.textAlignment =  NSTextAlignmentCenter;
    shakeLabel.text = @"Shake me!\n(ctrl+cmd+z on the simulator)";
    [self.view addSubview:shakeLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
