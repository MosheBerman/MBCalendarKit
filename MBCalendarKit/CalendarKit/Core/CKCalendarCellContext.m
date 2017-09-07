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
- (nonnull instancetype)initWithDate:(nonnull NSDate *)date andCalendarView:(nonnull CKCalendarView *)calendarView;
{
    self = [super init];
    
    if (self)
    {
        _date = date;
        _isToday = [calendarView.calendar isDate:date equalToDate:NSDate.date toUnitGranularity:NSCalendarUnitDay];
        _isSelected = [calendarView.calendar isDate:date equalToDate:calendarView.date toUnitGranularity:NSCalendarUnitDay];
        
        [self _updateContextForMonthEqualityWithDate:date andCalendarView:calendarView];
        [self _updateContextForClampingWithDate:date andCalendarView:calendarView];
        
        [self _updateIdentifierBasedOnFlags];
    }
    
    return self;
}

// MARK: - Updating Contexts In Response To Changes

/**
 Updates the `isInSameMonthAsToday` flag.
 
 @param date The date to compare to the calendar view.
 @param calendarView The calendar view to use to put the date in context.
 */
- (void)_updateContextForMonthEqualityWithDate:(NSDate *)date andCalendarView:(nonnull CKCalendarView *)calendarView
{
    _isInSameMonthAsToday = [calendarView.calendar isDate:date equalToDate:calendarView.date toUnitGranularity:NSCalendarUnitMonth];
}

/**
 Updates the minimum/maximum properties.
 
 @param date The date to compare to the calendar view.
 @param calendarView The calendar view to use to put the date in context.
 */
- (void)_updateContextForClampingWithDate:(nonnull NSDate *)date andCalendarView:(nonnull CKCalendarView *)calendarView
{
    NSDate *minimumDate = calendarView.minimumDate;
    NSDate *maximumDate = calendarView.maximumDate;
    
    _isBeforeMinimumDate = minimumDate == nil? NO : [calendarView.calendar date:date isBeforeDate:minimumDate];
    _isAfterMaximumDate = maximumDate == nil ? NO : [calendarView.calendar date:maximumDate isBeforeDate:date];
}

// MARK: - Calculating the Identifier

/**
 Recomputes the context identifier based on the flags we've set.
 */
- (void)_updateIdentifierBasedOnFlags
{
    if (_isToday && _isInSameMonthAsToday && !_isBeforeMinimumDate && !_isAfterMaximumDate)
    {
        _identifier = CKCalendarCellContextIdentifierToday;
    }
    else if (_isAfterMaximumDate || _isBeforeMinimumDate)
    {
        _identifier = CKCalendarCellContextIdentifierOutOfRange;
    }
    else if(!_isInSameMonthAsToday)
    {
        _identifier = CKCalendarCellContextIdentifierOutOfCurrentScope;
    }
    else
    {
        _identifier = CKCalendarCellContextIdentifierDefault;
    }
}


@end
