//
//  MBPolygonView.m
//  Polygon
//
//  Created by Moshe Berman on 7/22/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import "MBPolygonView.h"
#import "Math.h"
#import "CKCalendarHeaderColors.h"

@interface MBPolygonView ()
@property NSInteger numberOfSides;
@property CGFloat scalingFactor;
@property CGFloat rotation;
@property (strong) UIImageView *imageView;

/**
 Draws a polygon in a graphics context and returns it as a UIImage.
 
 @return An image containing the polygon.
 */
@property (nonatomic, strong) UIImage *polyImage;

@end

@implementation MBPolygonView

/**
 A convenience method to convert between degrees and radians
 
 @param deg The numer of degrees.
 @return A corresponding value, in radians.
 */
float degToRad(float deg)
{
    return deg*(M_PI/180);
}

// MARK: - Initializing a Polygon View

/**
 Initialize a Frame
 
 @param frame The frame of the polygon view. In an autolayout world, this property is essentially ignored.
 @param numberOfSides The number of sides to draw the polygon with.
 @param rotation A measure, in degrees, specifying how much to rotate the polygon.
 @param scale An arbitrary scale used to grow or shrink the polygon.
 @return A polygon view, ready for drawing.
 */
- (instancetype)initWithFrame:(CGRect)frame numberOfSides:(NSInteger)numberOfSides andRotation:(CGFloat)rotation andScale:(CGFloat) scale;
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _numberOfSides = numberOfSides;
        _scalingFactor = scale;
        _rotation = rotation;
        _isDeleted = NO;
        _fillColor = kCalendarColorHeaderMonth;
        [self setOpaque:NO];
        _imageView = [[UIImageView alloc] init];
        [self configureGesture];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame numberOfSides:3 andRotation:0.0 andScale:1.0];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self initWithFrame:CGRectZero numberOfSides:3 andRotation:0.0 andScale:1.0];
    if (self) {
        
    }
    return self;
}

// MARK: - Layout

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    if (![self.subviews containsObject:self.imageView])
    {
        [self addSubview:self.imageView];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.0
                                                                   constant:0.0];
        
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.imageView
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0];
        
        [self addConstraints:@[centerX, centerY, height, width]];
    }
    
    [super updateConstraints];
}

// MARK: - Layout Subviews

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *image = [self polyImage];
    
    self.imageView.image = image;
    [self.imageView sizeToFit];
}

// MARK: - Rendering a Polygon

/**
 Draws a polygon in a graphics context and returns it as a UIImage.
 
 @return An image containing the polygon.
 */
- (UIImage *)polyImage;
{
    if(!_polyImage)
    {
        // Drawing code
        
        //Create an image context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
        
        //Get a context
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //  Clear the background
        CGContextClearRect(context, self.frame);
        
        //Save the state of the context
        CGContextSaveGState(context);
        
        if (self.shouldRenderFlipped)
        {
            CGContextTranslateCTM(context, self.bounds.size.width, 0.0);
            CGContextScaleCTM(context, -1.0, 1.0);
        }
        
        //Set the stroke to white
        [self.fillColor set];
        
        //Define the number of degrees in a polygon
        const CGFloat kDegreesInPoly = 360;
        
        //  Calculate the angle in degrees.
        CGFloat angle = (kDegreesInPoly/self.numberOfSides);
        
        //  Calculate the starting point
        CGPoint point = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        //  We draw an extra line to connect the start and end points
        for(int i=0; i<=self.numberOfSides; i++){
            
            //  Calculate the working angle in degrees
            CGFloat workingAngle = i*angle;
            
            //  Convert to radians
            CGFloat angleInRadians = degToRad(workingAngle+self.rotation);
            
            //  Calculate the x and Y coordinates
            point.x = sin(angleInRadians);
            point.y = cos(angleInRadians);
            
            //  Apply the scale factor
            point.x *= self.scalingFactor;
            point.y *= self.scalingFactor;
            
            //  Offset to the center
            point.x += self.bounds.size.width/2;
            point.y +=self.bounds.size.height/2;
            
            //  Set the starting point if we're working
            //  the inital point. Core Graphics needs this.
            if (i == 0) {
                CGContextMoveToPoint(context, point.x, point.y);
            }
            
            //  Add the new line to the context
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        
        //  Render it all out
        CGContextFillPath(context);
        
        //Restore the state
        CGContextRestoreGState(context);
        
        //Grab an image from the context
        _polyImage = UIGraphicsGetImageFromCurrentImageContext();
        
        //clean up the context
        UIGraphicsEndImageContext();
        
    }
    //return the image
    return _polyImage;
}

// MARK: - Cleaning Up

- (void)configureGesture
{
    // Set up a gesture to clear the polygon.
    UILongPressGestureRecognizer *removeGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cleanUp)];
    removeGesture.minimumPressDuration = 1.0;
    [self addGestureRecognizer:removeGesture];
}

// MARK: - Cleaning Up In Between Rendering Passes

- (void) cleanUp
{
    self.isDeleted = YES;
    _polyImage = nil;
}

// MARK: - RTL Support


/**
 Determines if the image should render flipped, checking NSLocale's `characterDirectionForLanguage` and `self.semanticContentAttribute`.
 
 @return `YES` if the view should be drawn right-to-left, otherwise, `NO` for left-to-right.
 */
- (BOOL)shouldRenderFlipped
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString * languageCode = [locale objectForKey:NSLocaleLanguageCode];
    NSLocaleLanguageDirection languageDirection = [NSLocale characterDirectionForLanguage:languageCode];
    
    BOOL isNaturallyRTL = languageDirection == NSLocaleLanguageDirectionRightToLeft;
    
    BOOL isSemanticallyRTL = NO;
    if ([self respondsToSelector:@selector(semanticContentAttribute)])
    {
        isSemanticallyRTL = self.semanticContentAttribute == UISemanticContentAttributeForceRightToLeft;
    }
    
    BOOL shouldRenderFlipped = isNaturallyRTL || isSemanticallyRTL;
    
    return shouldRenderFlipped;
}

@end
