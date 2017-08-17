//
//  UIView+Border.h
//  NachumSegalNetwork
//
//  Created by Moshe Berman on 12/28/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

@import UIKit;
@import QuartzCore;

@interface UIView (Border)

// MARK: Toggling the Border

/**
 Shows the a border around the `UIView` instance.
 */
- (void)showBorder;

/**
 Hides the border by setting `self.layer.borderWidth` to 0.0 and `self.layer.borderColor` to `UIColor.clearColor.CGColor`.
 */
- (void)hideBorder;


// MARK: - Changing the Border Color

/**
 Sets the border's color using `self.layer.borderColor`.

 The default is `[UIColor redColor]`.
 
 @param color The color to set.
 */
- (void)setBorderColor:(nullable UIColor *)color;


// MARK: - Changing the Border Width

/**
 Sets the border's thickness by using `self.layer.borderWidth`.

 The default is 0.0;
 
 @param width The width of the border.
 */
- (void)setBorderWidth:(CGFloat)width;

@end
