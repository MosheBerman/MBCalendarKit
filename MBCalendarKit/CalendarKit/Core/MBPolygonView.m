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
@end

@implementation MBPolygonView

//
//  Convenience method to convert between Degrees and Radians
//

float degToRad(float deg)
{
    return deg*(M_PI/180);
}

//
//  Designated initializer
//

- (id)initWithFrame:(CGRect)frame numberOfSides:(NSInteger)numberOfSides andRotation:(CGFloat)rotation andScale:(CGFloat) scale
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
    }
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    //
    //  Create a poly image
    //
    
    UIImage *i = [self polyImage];
    
    self.imageView.image = i;
    [self.imageView sizeToFit];
    
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
        
        [self addConstraints:@[centerX, centerY]];
        
        //
        //  Set up a long press to remove the poly from the screen
        //
        
        UILongPressGestureRecognizer *removeGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cleanUp)];
        removeGesture.minimumPressDuration = 1.0;
        [self addGestureRecognizer:removeGesture];
    }
}

//
//  Draw a a polygon into a UIImage and returns the image
//

- (UIImage *)polyImage
{
    // Drawing code
    
    //Create an image context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    
    //Get a context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //  Clear the background
     CGContextClearRect(context, self.frame);
    
    //Save the state of the context
    CGContextSaveGState(context);
    
    // Flip for RTL languages
    NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
    NSString * languageCode = [locale languageCode];
    NSLocaleLanguageDirection languageDirection = [NSLocale characterDirectionForLanguage:languageCode];
    
    if (languageDirection == NSLocaleLanguageDirectionRightToLeft)
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
    CGPoint point = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
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
        point.x += self.frame.size.width/2;
        point.y +=self.frame.size.height/2;
        
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
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    
    
    //clean up the context
    UIGraphicsEndImageContext();
    
    //return the image
    return image;
}

- (void) cleanUp{
    self.isDeleted = YES;
}
@end
