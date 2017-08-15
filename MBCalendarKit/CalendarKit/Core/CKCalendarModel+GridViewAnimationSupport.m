//
//  CKCalendarModel+GridViewAnimationSupport.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/13/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel+GridViewAnimationSupport.h"
@import ObjectiveC;

const void *kAnimatesWeekTransitionsKey = "com.mosheberman.calendarkit.animates-weeks";

@implementation CKCalendarModel (GridViewAnimationSupport)


// MARK: - Determining if Animation is Appropriate


/**
 Looks up the associated object for the `kAnimatesWeekTransitionsKey` key and returns its BOOL value.

 @return The BOOL value for the associate object. If the object is nil, returns `NO` by default.
 */
- (BOOL)animatesWeekTransitions;
{
    NSNumber *shouldAnimate = objc_getAssociatedObject(self, kAnimatesWeekTransitionsKey);
    
    if (!shouldAnimate)
    {
        shouldAnimate = @NO;
    }
    
    return shouldAnimate.boolValue;
}


/**
 Sets the value for the animatesWeekTranstions preference.

 @param animates The value to set `YES` to enable week transitions, `NO` to disable them.
 */
- (void)setAnimatesWeekTransitions:(BOOL)animates;
{
    objc_setAssociatedObject(self, kAnimatesWeekTransitionsKey, @(animates), OBJC_ASSOCIATION_ASSIGN);
}

/**
 Determines if we should animate transition from one date to another.
 
 @param fromDate The date before the change.
 @param toDate The date after the change.
 @return `YES` if we want a change, otherwise `NO`.
 */
- (BOOL)shouldAnimateTransitionFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
{
    BOOL isAppropriate = YES;
    BOOL sameMonth = [self.calendar isDate:fromDate equalToDate:toDate toUnitGranularity:NSCalendarUnitMonth];
    BOOL sameWeek = [self.calendar isDate:fromDate equalToDate:toDate toUnitGranularity:NSCalendarUnitWeekOfYear];
    
    if (self.displayMode == CKCalendarViewDisplayModeMonth && sameMonth)
    {
        isAppropriate = NO;
    }
    if (self.displayMode == CKCalendarViewDisplayModeWeek && (sameWeek || !self.animatesWeekTransitions))
    {
        isAppropriate = NO;
    }
    
    return isAppropriate;
}

// MARK: - Determining the Axis of Animation

/**
 Returns an appropriate axis to animate along, depending on the display mode.
 
 @return Either `CKCalendarGridTransitionAxisHorizontal` or `CKCalendarGridTransitionAxisVertical`.
 */
- (CKCalendarGridTransitionAxis)transitionAxis;
{
    if (self.displayMode == CKCalendarViewDisplayModeMonth)
    {
        return CKCalendarGridTransitionAxisVertical;
    }
    
    return CKCalendarGridTransitionAxisHorizontal;
}

// MARK: - Calculating Row Counts for Animation

/**
 The number of rows that the grid view should display for a given date.

 @param date The date to calculate for.
 @return The number of rows necessary to display enough data for the given date.
 */
- (NSUInteger)numberOfRowsForDate:(NSDate *)date;
{
    NSInteger numberOfRows = 0;
    
    if (self.displayMode == CKCalendarViewDisplayModeMonth)
    {
        numberOfRows = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date].length;
    }
    else if (self.displayMode == CKCalendarViewDisplayModeWeek)
    {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}

@end
