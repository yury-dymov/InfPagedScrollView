//
//  InfPagedScrollView.m
//  infscroll
//
//  Created by Dymov, Yuri on 7/30/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

// Refactoring idea: add UITableViewCell analog to avoid using "tag" for subviews

#import "InfPagedScrollView.h"

typedef enum {
    INF_ROTATE_DIRECTION_LEFT = 1,
    INF_ROTATE_DIRECTION_RIGHT
} INF_ROTATE_DIRECTION;

@interface InfPagedScrollView() {
    NSUInteger _currentIndex;
    NSUInteger _lastCurrentIndex;
}

@property (nonatomic, strong) InfHelperScrollView *_contentView;

@end

@implementation InfPagedScrollView
@synthesize dataSource;
@synthesize _contentView;
@synthesize currentIndex;

- (CGFloat)_selfWidth {
    return CGRectGetWidth(self.bounds);
}

- (CGFloat)_selfHeight {
    return CGRectGetHeight(self.bounds);
}

- (UIScrollView*)_contentView {
    if (!_contentView) {
        self._contentView = [[InfHelperScrollView alloc] initWithFrame:CGRectMake(0, 0, [self _selfWidth], [self _selfHeight])];
        _contentView.pagingEnabled = YES;
        _contentView.contentSize = CGSizeMake(3 * [self _selfWidth], [self _selfHeight]);
        _contentView.contentOffset = CGPointMake([self _selfWidth], 0);
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.delegate = self;
    }
    return _contentView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self._contentView];
    }
    return self;
}

- (void)_initViews {
    NSUInteger numberOfViews = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    for (NSInteger i = -1; i < 2; ++i) {
        NSInteger idx = _currentIndex == 0 && i == -1 ? numberOfViews - 1:(_currentIndex + i) % numberOfViews;
        UIView *v = [self.dataSource infPagedScrollView:self viewAtIndex:idx reusableView:nil];
        v.tag = idx;
        v.frame = CGRectMake([self _selfWidth] * (i + 1) + ([self _selfWidth] - v.bounds.size.width) * 0.5f, v.frame.origin.y, v.bounds.size.width, v.bounds.size.height);
        [_contentView addSubview:v];
    }
}

- (void)_rotateToDirection:(INF_ROTATE_DIRECTION)direction {
    NSUInteger numberOfViews = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    if (direction == INF_ROTATE_DIRECTION_LEFT) {
        _currentIndex = [_contentView.subviews.firstObject tag];
    } else if (direction == INF_ROTATE_DIRECTION_RIGHT) {
        _currentIndex = [_contentView.subviews.lastObject tag];
    }

    UIView *oldView = nil;
    if (direction == INF_ROTATE_DIRECTION_LEFT) {
        oldView = _contentView.subviews.lastObject;
    } else if (direction == INF_ROTATE_DIRECTION_RIGHT) {
        oldView = _contentView.subviews.firstObject;
    }
    [oldView removeFromSuperview];
    for (UIView *v in _contentView.subviews) {
        v.frame = CGRectMake(v.frame.origin.x - [self _selfWidth] * (direction == INF_ROTATE_DIRECTION_RIGHT) + [self _selfWidth] * (direction == INF_ROTATE_DIRECTION_LEFT), v.frame.origin.y, v.bounds.size.width, v.bounds.size.height);
    }
    NSUInteger newIndex = 0;
    if (direction == INF_ROTATE_DIRECTION_LEFT) {
        newIndex = _currentIndex == 0 ? numberOfViews - 1 : _currentIndex - 1;
    } else if (direction == INF_ROTATE_DIRECTION_RIGHT) {
        newIndex = (_currentIndex + 1) % numberOfViews;
    }
    oldView = [self.dataSource infPagedScrollView:self viewAtIndex:newIndex reusableView:oldView];
    oldView.tag = newIndex;
    oldView.frame = CGRectMake([self _selfWidth] * 2 * (INF_ROTATE_DIRECTION_RIGHT == direction) + ([self _selfWidth] - oldView.bounds.size.width) * 0.5f, oldView.frame.origin.y, oldView.bounds.size.width, oldView.bounds.size.height);
    if (direction == INF_ROTATE_DIRECTION_RIGHT)
        [_contentView addSubview:oldView];
    else
        [_contentView insertSubview:oldView atIndex:0];

    _contentView.contentOffset = CGPointMake([self _selfWidth], 0);
}


- (void)_rotateSubviews {
    CGFloat offsetX = _contentView.contentOffset.x;
    if (offsetX - [self _selfWidth] * 2 > 0) {
        [self _rotateToDirection:INF_ROTATE_DIRECTION_RIGHT];
    } else if (offsetX < 0) {
        [self _rotateToDirection:INF_ROTATE_DIRECTION_LEFT];
    } else {
        // scroll to next page not finished yet. Doing nothing
    }
}

- (void)scrollViewLayoutSubviews:(InfHelperScrollView *)scrollView {
     NSUInteger numberOfViews = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    if (numberOfViews > 0) {
        if (!_contentView.subviews.count) {
            [self _initViews];
        } else {
            [self _rotateSubviews];
        }

        if (numberOfViews == 1) {
            _contentView.scrollEnabled = NO;
        } else {
            // lock scrolling if only element left to avoid scrolling to self
            _contentView.scrollEnabled = YES;
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_lastCurrentIndex != [self currentIndex]) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)_reloadData {
    for (UIView *v in _contentView.subviews) {
        [v removeFromSuperview];
    }
    NSUInteger numberOfPages = [self.dataSource numberOfPagesInInfPagedScrollView:self];
    if (_currentIndex >= numberOfPages) {
        _currentIndex = 0;
    }
    [_contentView layoutSubviews];
}

- (void)reloadData {
    [self _reloadData];
    if (_lastCurrentIndex != [self currentIndex]) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (NSUInteger)currentIndex {
    for (UIView *subview in _contentView.subviews) {
        if (subview.frame.origin.x - _contentView.contentOffset.x < [self _selfWidth] * 0.5f && subview.frame.origin.x - _contentView.contentOffset.x > 0) {
            _lastCurrentIndex = subview.tag;
            return subview.tag;
        }
    }
    return 0;
}

- (void)setCurrentIndex:(NSUInteger)aCurrentIndex {
    _currentIndex = aCurrentIndex;
    [self _reloadData];
    _lastCurrentIndex = _currentIndex;
}

- (NSArray*)allObjects {
    return _contentView.subviews;
}

@end
