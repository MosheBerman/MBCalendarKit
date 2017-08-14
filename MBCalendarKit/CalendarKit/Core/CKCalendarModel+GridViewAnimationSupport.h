//
//  CKCalendarModel+GridViewAnimationSupport.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/13/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel.h"
#import "CKCalendarGridTransitionAxis.h"

@interface CKCalendarModel (GridViewAnimationSupport)

// MARK: - Determining if Animation is Appropriate

/**
 Determines if the calendar view should animate from week to week.
 
 Prior to MBCalendarKit 5.0.0, only month transitions animated.
 With this enabled, week to week transitions can animate as well.
 
 The default value is `NO`, to remain consistent with the legacy iPhone calendar.
 */
@property (nonatomic, assign) BOOL animatesWeekTransitions;

/**
 Determines if we should animate transition from one date to another.

 @param fromDate The date before the change.
 @param toDate The date after the change.
 @return `YES` if we want a change, otherwise `NO`.
 */
- (BOOL)shouldAnimateTransitionFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

// MARK: - Determining the Axis of Animation

/**
 Returns an appropriate axis to animate along, depending on the display mode.

 @return Either `CKCalendarGridTransitionAxisHorizontal` or `CKCalendarGridTransitionAxisVertical`.
 */
- (CKCalendarGridTransitionAxis)transitionAxis;

// MARK: - Calculating Row Counts for Animation

/**
 The number of rows that the grid view should display for a given date.
 
 @param date The date to calculate for.
 @return The number of rows necessary to display enough data for the given date.
 */
- (NSUInteger)numberOfRowsForDate:(NSDate *)date;

@end
