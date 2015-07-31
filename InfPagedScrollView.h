//
//  InfPagedScrollView.h
//  infscroll
//
//  Created by Dymov, Yuri on 7/30/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfPagedScrollView;

@protocol InfPagedScrollViewDataSource <NSObject>

- (UIView*)infPagedScrollView:(InfPagedScrollView*)infPagedScrollView viewAtIndex:(NSUInteger)idx reusableView:(UIView*)view;
- (NSUInteger)numberOfPagesInInfPagedScrollView:(InfPagedScrollView*)infPagedScrollView;

@end

@interface InfPagedScrollView : UIScrollView<UIScrollViewDelegate>

- (void)reloadData;
- (NSUInteger)currentIndex;

@property (nonatomic, weak) id<InfPagedScrollViewDataSource> dataSource;

@end
