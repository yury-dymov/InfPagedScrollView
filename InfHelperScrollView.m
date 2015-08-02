//
//  InfHelperScrollView.m
//  chinese
//
//  Created by Dymov, Yuri on 8/2/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import "InfHelperScrollView.h"

@implementation InfHelperScrollView
@synthesize delegate;

- (void)setDelegate:(id<InfHelperScrollViewDelegate,UIScrollViewDelegate>)adelegate {
    [super setDelegate:adelegate];
    delegate = adelegate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [delegate scrollViewLayoutSubviews:self];
}

@end
