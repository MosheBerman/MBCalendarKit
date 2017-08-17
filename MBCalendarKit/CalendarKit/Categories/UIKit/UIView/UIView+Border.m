//
//  UIView+Border.m
//  Utils
//
//  Created by Moshe Berman on 12/28/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "UIView+Border.h"
@import ObjectiveC;

static char * kBorderWidthKey = "com.mosheberman.key.border-width";
static char * kBorderColorKey = "com.mosheberman.key.border-color";

@implementation UIView (Border)

// MARK: Toggling the Border

/**
 Shows the a border around the `UIView` instance.
 */
- (void)showBorder;
{
    self.layer.borderColor = [self borderColor].CGColor;
    self.layer.borderWidth = [self borderWidth];
}

/**
 Hides the border by setting `self.layer.borderWidth` to 0.0 and `self.layer.borderColor` to `UIColor.clearColor.CGColor`.
 */
- (void)hideBorder
{
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = UIColor.clearColor.CGColor;
}

// MARK: - Border Color

- (void) setBorderColor:(UIColor *)color
{
    objc_setAssociatedObject(self, kBorderColorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nonnull UIColor *)borderColor
{
    UIColor *color = objc_getAssociatedObject(self, kBorderColorKey);
    
    if(!color)
    {
        color = [UIColor redColor];
    }
    
    return color;
}

// MARK: - Border Width

- (void) setBorderWidth:(CGFloat)width
{
    objc_setAssociatedObject(self, kBorderWidthKey, @(width), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)borderWidth
{
    NSNumber *number = objc_getAssociatedObject(self, kBorderWidthKey);
    CGFloat width = 0.0;
    
    if(number)
    {
        width = number.floatValue;
    }
    
    return width;
}


@end
