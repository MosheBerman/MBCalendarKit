//
//  MBPolygonView.h
//  Polygon
//
//  Created by Moshe Berman on 7/22/12.
//  Copyright (c) 2012 Moshe Berman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPolygonView : UIView

//
//
//

@property (nonatomic) BOOL isDeleted;

//
//  Designated Initializer
//

- (id)initWithFrame:(CGRect)frame numberOfSides:(NSInteger)numberOfSides andRotation:(CGFloat)rotation andScale:(CGFloat) scale;

//
//  Draw a a polygon into a UIImage and returns the image
//

- (UIImage *)polyImage;



@end
