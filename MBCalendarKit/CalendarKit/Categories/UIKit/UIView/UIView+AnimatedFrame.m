//
//  UIView+AnimatedFrame.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/15/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "UIView+AnimatedFrame.h"

@implementation UIView (AnimatedFrame)

- (void)setFrame:(CGRect)frame animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = frame;
        }];
    }
    else
    {
        self.frame = frame;
    }
}

@end
