//
//  CKCalendarGridTransitionCollectionViewFlowLayout.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/11/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import UIKit;

#import "CKCalendarGridTransitionDirection.h"
#import "CKCalendarGridTransitionAxis.h"

@interface CKCalendarGridTransitionCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 Defines if we are animating forward or backward.
 */
@property (nonatomic, assign) CKCalendarTransitionDirection transitionDirection;

/**
 Determines along which axis to animate along. (i.e. Do we slide in from the bottom/top or left/right?)
 */
@property (nonatomic, assign) CKCalendarGridTransitionAxis transitionAxis;

/**
 The animation offsets along the X and Y axes.
 */
@property (nonatomic, assign) CGPoint initialOffset;

@end
