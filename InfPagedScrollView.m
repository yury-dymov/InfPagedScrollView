//
//  InfPagedScrollView.m
//  infscroll
//
//  Created by Dymov, Yuri on 7/30/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

// Refactoring idea: add UITableViewCell analog to avoid using "tag" for subviews

#import "InfPagedScrollView.h"

@interface InfPagedScrollView() {
    NSUInteger _currentIndex;
}

@end

@implementation InfPagedScrollView
@synthesize dataSource;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.contentSize = CGSizeMake(3 * self.frame.size.width, self.frame.size.height);
        self.contentOffset = CGPointMake(frame.size.width, 0);
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
    }
    return self;
}

- (void)_initViews {
    NSUInteger numberOfViews = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    for (NSInteger i = -1; i < 2; ++i) {
        NSInteger idx = _currentIndex == 0 && i == -1 ? numberOfViews - 1:(_currentIndex + i) % numberOfViews;
        UIView *v = [self.dataSource infPagedScrollView:self viewAtIndex:idx reusableView:nil];
        v.tag = idx;
        v.frame = CGRectMake(self.frame.size.width * (i + 1) + (self.frame.size.width - v.frame.size.width) * 0.5f, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        [self _addSubview:v];
    }
}

- (void)_rotateRight {
     NSUInteger numberOfViews = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    _currentIndex = [self.subviews.lastObject tag];
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    UIView *oldView = self.subviews.firstObject;
    [oldView removeFromSuperview];
    for (UIView *v in self.subviews) {
        v.frame = CGRectMake(v.frame.origin.x - self.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
    }
    oldView = [self.dataSource infPagedScrollView:self viewAtIndex:(_currentIndex + 1) % numberOfViews reusableView:oldView];
    oldView.frame = CGRectMake(self.frame.size.width * 2 + (self.frame.size.width - oldView.frame.size.width) * 0.5f, oldView.frame.origin.y, oldView.frame.size.width, oldView.frame.size.height);
    oldView.tag = (_currentIndex + 1) % numberOfViews;
    [self _addSubview:oldView];
}

- (void)_rotateLeft {
     NSUInteger numberOfViews = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    _currentIndex = [self.subviews.firstObject tag];
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    UIView *oldView = self.subviews.lastObject;
    [oldView removeFromSuperview];
    for (UIView *v in self.subviews) {
        v.frame = CGRectMake(v.frame.origin.x + self.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
    }
    oldView = [self.dataSource infPagedScrollView:self viewAtIndex:_currentIndex == 0 ? numberOfViews - 1 : _currentIndex - 1 reusableView:oldView];
    oldView.tag = _currentIndex == 0 ? numberOfViews - 1: _currentIndex - 1;
    oldView.frame = CGRectMake((self.frame.size.width - oldView.frame.size.width) * 0.5f, oldView.frame.origin.y, oldView.frame.size.width, oldView.frame.size.height);
    [self insertSubview:oldView atIndex:0];
}

- (void)_rotateSubviews {
    CGFloat offsetX = self.contentOffset.x;
    if (offsetX - self.frame.size.width * 2 > 0) {
        [self _rotateRight];
    } else if (offsetX < 0) {
        [self _rotateLeft];
    } else {
        // scroll to next page not finished yet. Doing nothing
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
     NSUInteger numberOfViews = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    if (numberOfViews > 0) {
        if (!self.subviews.count) {
            [self _initViews];
        } else {
            [self _rotateSubviews];
        }

        if (numberOfViews == 1) {
            self.scrollEnabled = NO;
        } else {
            // lock scrolling if only element left to avoid scrolling to self
            self.scrollEnabled = YES;
        }
    }
}


- (void)addSubview:(UIView *)view {
}

- (void)_addSubview:(UIView*)view {
    [super addSubview:view];
}

- (void)reloadData {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    if (_currentIndex >= numberOfPages)
        _currentIndex = 0;
    [self layoutSubviews];
}

- (NSUInteger)currentIndex {
    for (UIView *subview in self.subviews) {
        if (subview.frame.origin.x - self.contentOffset.x < self.frame.size.width * 0.5f && subview.frame.origin.x - self.contentOffset.x > 0) {
            return subview.tag;
        }
    }
    return 0;
}

@end
