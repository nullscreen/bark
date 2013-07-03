//
//  ALWindow.m
//  DemoProject
//
//  Created by Austin Louden on 7/3/13.
//  Copyright (c) 2013 Austin Louden. All rights reserved.
//

#import "ALWindow.h"

@implementation ALWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
        NSLog(@"here");
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
