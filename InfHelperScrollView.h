//
//  InfHelperScrollView.h
//  chinese
//
//  Created by Dymov, Yuri on 8/2/15.
//  Copyright (c) 2015 Dymov, Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfHelperScrollView;

@protocol InfHelperScrollViewDelegate <NSObject>

- (void)scrollViewLayoutSubviews:(InfHelperScrollView*)scrollView;

@end

@interface InfHelperScrollView : UIScrollView

@property (nonatomic, weak) id<InfHelperScrollViewDelegate, UIScrollViewDelegate> delegate;

@end
