//
//  CKCalendarCellContext.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarCellContext.h"
#import "CKCalendarView.h"
#import "CKCalendarView_Private.h"
#import "CKCalendarModel.h"
#import "NSCalendarCategories.h"

@implementation CKCalendarCellContext

// MARK: - Creating a Context Object

/**
 Create a context object. The `calendarView` is not retained.
 
 @param date The date that we are contextualizing relative to the calendar view's current state.
 @param calendarView The calendar view to calculate the context for.
 @return The context object based on the current date and the configuration of the calendar view.
 */
- (nonnull instancetype)initWithDate:(nonnull NSDate *)date andCalendarView:(nonnull CKCalendarView *)calendarView;
{
    return [self initWithDate:date andCalendarModel:calendarView.calendarModel];
}
/**
 Create a context object. The `calendarModel` is not retained.
 
 @param date The date that we are contextualizing relative to the calendar view's current state.
 @param model The model to use to calculate the context.
 @return The context object based on the current date and the configuration of the calendar view.
 */
- (nonnull instancetype)initWithDate:(nonnull NSDate *)date andCalendarModel:(CKCalendarModel *)model;
{
    self = [super init];
    
    if (self)
    {
        _date = date;
        _isToday = [model.calendar isDate:date equalToDate:NSDate.date toUnitGranularity:NSCalendarUnitDay];
        _isSelected = [model.calendar isDate:date equalToDate:model.date toUnitGranularity:NSCalendarUnitDay];
        
        [self _updateContextForScopeEqualityWithDate:date andCalendarModel:model];
        [self _updateContextForClampingWithDate:date andCalendarModel:model];
        
        [self _updateIdentifierBasedOnFlags];
    }
    
    return self;
}

// MARK: - Updating Contexts In Response To Changes

/**
 Updates the `isInSameMonthAsToday` flag.
 
 @param date The date to compare to the calendar view.
 @param model The calendar model to use to put the date in context.
 */
- (void)_updateContextForScopeEqualityWithDate:(NSDate *)date andCalendarModel:(nonnull CKCalendarModel *)model
{
    _isInSameMonthAsToday = [model.calendar isDate:date equalToDate:model.date toUnitGranularity:NSCalendarUnitMonth];
}

/**
 Updates the minimum/maximum properties.
 
 @param date The date to compare to the calendar view.
 @param model The calendar model to use to put the date in context.
 */
- (void)_updateContextForClampingWithDate:(nonnull NSDate *)date andCalendarModel:(nonnull CKCalendarModel *)model
{
    NSDate *minimumDate = model.minimumDate;
    NSDate *maximumDate = model.maximumDate;
    
    _isBeforeMinimumDate = minimumDate == nil? NO : [model.calendar date:date isBeforeDate:minimumDate];
    _isAfterMaximumDate = maximumDate == nil ? NO : [model.calendar date:maximumDate isBeforeDate:date];
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

// MARK: -

- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    [self _updateIdentifierBasedOnFlags];
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    [self _updateIdentifierBasedOnFlags];
}

- (void)setIsInSameMonthAsToday:(BOOL)isInSameMonthAsToday
{
    _isInSameMonthAsToday = isInSameMonthAsToday;
    [self _updateIdentifierBasedOnFlags];
}

-(void)setIsBeforeMinimumDate:(BOOL)isBeforeMinimumDate
{
    _isBeforeMinimumDate = isBeforeMinimumDate;
    [self _updateIdentifierBasedOnFlags];
}

- (void)setIsAfterMaximumDate:(BOOL)isAfterMaximumDate
{
    _isAfterMaximumDate = isAfterMaximumDate;
    [self _updateIdentifierBasedOnFlags];
}

@end
