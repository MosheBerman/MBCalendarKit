//
//  CKCalendarCellContext.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarCellContext.h"
#import "CKCalendarView.h"
#import "NSCalendarCategories.h"

@implementation CKCalendarCellContext

// MARK: - Creating a Context Object

/**
 Create a context object. The `calendarView` is not retained.
 
 @param date The date that we are contextualizing relative to the calendar view's current state.
 @param calendarView The calendar view to use to calculate the context.
 @return The context object based on the current date and the configuration of the calendar view.
 */
- (nonnull instancetype)initWithDate:(nonnull NSDate *)date andCalendarView:(nonnull CKCalendarView *)calendarView
{
    self = [super init];
    
    if (self)
    {
        _isToday = [calendarView.calendar isDate:date equalToDate:NSDate.date toUnitGranularity:NSCalendarUnitDay];
        _isInSameMonthAsToday = [calendarView.calendar isDate:date equalToDate:calendarView.date toUnitGranularity:NSCalendarUnitMonth];
        _isBeforeMinimumDate = [calendarView.calendar date:date isBeforeDate:calendarView.minimumDate];
        _isAfterMaximumDate = [calendarView.calendar date:calendarView.maximumDate isBeforeDate:date];
    }
    
    return self;
}

@end
