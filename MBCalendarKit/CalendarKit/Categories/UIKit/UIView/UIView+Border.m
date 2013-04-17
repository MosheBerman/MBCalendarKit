//
//  UIView+Border.m
//  Utils
//
//  Created by Moshe Berman on 12/28/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "UIView+Border.h"
#import <objc/runtime.h>

@implementation UIView (Border)

- (void) showBorder
{
    
    if (![self borderColor]) {
        [self setBorderColor:[UIColor redColor]];
    }
    
    if (![self borderWidth]) {
        [self setBorderWidth:1.0];
    }
    
    [[self layer] setBorderColor:[self borderColor].CGColor];
    [[self layer] setBorderWidth:[self borderWidth]];
}

- (void) hideBorder{
    [[self layer] setBorderWidth:0.0];
    [[self layer] setBorderColor:[UIColor clearColor].CGColor];
}

#pragma mark - Border Color

static char * kBorderColorKey = "border color key";

- (void) setBorderColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kBorderColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)borderColor
{
    return objc_getAssociatedObject(self, kBorderColorKey);
}

#pragma mark - Border Width

static char * kBorderWidthKey = "border width key";

- (void) setBorderWidth:(CGFloat)width
{
    objc_setAssociatedObject(self, kBorderWidthKey, @(width), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)borderWidth
{
    return [objc_getAssociatedObject(self, kBorderWidthKey) floatValue];
}


@end
