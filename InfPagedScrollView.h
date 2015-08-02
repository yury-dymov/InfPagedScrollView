//
//  InfPagedScrollView.h
//  infscroll
//
//  Created by Dymov, Yuri on 7/30/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfHelperScrollView.h"

@class InfPagedScrollView;

@protocol InfPagedScrollViewDataSource <NSObject>

- (UIView*)infPagedScrollView:(InfPagedScrollView*)infPagedScrollView viewAtIndex:(NSUInteger)idx reusableView:(UIView*)view;
- (NSUInteger)numberOfPagesInInfPagedScrollView:(InfPagedScrollView*)infPagedScrollView;

@end

@interface InfPagedScrollView : UIControl<UIScrollViewDelegate, InfHelperScrollViewDelegate>

@property (nonatomic, assign) NSUInteger currentIndex;

- (void)reloadData;
- (NSArray*)allObjects;

@property (nonatomic, weak) id<InfPagedScrollViewDataSource> dataSource;

@end
