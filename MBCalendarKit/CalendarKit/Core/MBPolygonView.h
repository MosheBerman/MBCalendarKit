//
//  MBPolygonView.h
//  Polygon
//
//  Created by Moshe Berman on 7/22/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

@import UIKit;

@interface MBPolygonView : UIView

/**
 The fill color of the polygon.
 */
@property (nonatomic, strong) UIColor *fillColor UI_APPEARANCE_SELECTOR;


/**
 A flag for handling cleanup of the rendered polygon.
 */
@property (nonatomic) BOOL isDeleted;

// MARK: - Initializing a Polygon View

/**
 Initialize a Frame

 @param frame The frame of the polygon view. In an autolayout world, this property is essentially ignored.
 @param numberOfSides The number of sides to draw the polygon with.
 @param rotation A measure, in degrees, specifying how much to rotate the polygon.
 @param scale An arbitrary scale used to grow or shrink the polygon.
 @return A polygon view, ready for drawing.
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfSides:(NSInteger)numberOfSides andRotation:(CGFloat)rotation andScale:(CGFloat) scale NS_DESIGNATED_INITIALIZER;

// MARK: - Rendering a Polygon

/**
 Draws a polygon in a graphics context and returns it as a UIImage.

 @return An image containing the polygon.
 */
@property (nonatomic, readonly, strong) UIImage *polyImage;

@end
