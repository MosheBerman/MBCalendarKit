//
//  CKCalendarModel.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel.h"
#import "NSCalendar+Juncture.h"
#import "NSCalendarCategories.h"

#import "CKCalendarCellContextCache.h"

@interface CKCalendarModel ()

/**
 The date that was last selected by the user, either by tapping on a cell or one of the arrows in the header.
 */
@property (nonatomic, strong) NSDate *previousDate;

// MARK: - Caching Cell Context

/**
 A cache which maintains the cell contexts and responds to date, calendar, and other changes.
 */
@property (nonnull, nonatomic, strong) CKCalendarCellContextCache *cellContextCache;

@end

@implementation CKCalendarModel

// MARK: - Initializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendar = [NSCalendar autoupdatingCurrentCalendar];
        _displayMode = CKCalendarViewDisplayModeMonth;
        _date = [NSDate date];
    }
    return self;
}

// MARK: - Settings the Date

- (void)setDate:(NSDate *)date
{
    if (!date) {
        date = [NSDate date];
    }
    
    if (date.timeIntervalSinceReferenceDate == _date.timeIntervalSinceReferenceDate)
    {
        return;
    }
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    date = [self.calendar dateFromComponents:components];
    
    BOOL minimumIsBeforeMaximum = [self _minimumDateIsBeforeMaximumDate];
    
    if (minimumIsBeforeMaximum) {
        
        if ([self _dateIsBeforeMinimumDate:date]) {
            date = self.minimumDate;
        }
        else if([self _dateIsAfterMaximumDate:date])
        {
            date = self.maximumDate;
        }
    }
    
    if ([self.observer respondsToSelector:@selector(calendarModel:willChangeFromDate:toNewDate:)])
    {
        [self.observer calendarModel:self willChangeFromDate:self.date toNewDate:date];
    }
    
    _previousDate = self.date;
    _date = date;
    
    if([self.observer respondsToSelector:@selector(calendarModel:didChangeFromDate:toNewDate:)])
    {
        [self.observer calendarModel:self didChangeFromDate:self.previousDate toNewDate:self.date];
    }
}

- (void)setDisplayMode:(CKCalendarViewDisplayMode)mode
{
    _displayMode = mode;
    
    [self informObserverOfInvalidatedState];
}

// MARK: - Getting the First Visible Date

/**
 Returns the first visible date in the calendar grid view.
 
 @return A date representing the first day of the week, respecting the calendar's start date.
 */
- (nonnull NSDate *)firstVisibleDate;
{
    CKCalendarViewDisplayMode displayMode = self.displayMode;
    NSDate *firstVisibleDate = self.date; /* Default to self.date */
    
    // for the day mode, just return today
    if (displayMode == CKCalendarViewDisplayModeDay)
    {
        // The default suits this case well
    }
    else if(displayMode == CKCalendarViewDisplayModeWeek)
    {
        firstVisibleDate = [self.calendar firstDayOfTheWeekUsingReferenceDate:self.date andStartDay:self.calendar.firstWeekday];
    }
    else if(displayMode == CKCalendarViewDisplayModeMonth)
    {
        NSDate *firstOfTheMonth = [self.calendar firstDayOfTheMonthUsingReferenceDate:self.date];
        
        firstVisibleDate = [self.calendar firstDayOfTheWeekUsingReferenceDate:firstOfTheMonth andStartDay:self.calendar.firstWeekday];
    }
    
    return firstVisibleDate;
}

/**
 Returns the first visible date in the calendar grid view.
 
 @return A date representing the first day of the week, respecting the calendar's start date.
 */
- (nonnull NSDate *)lastVisibleDate;
{
    CKCalendarViewDisplayMode displayMode = self.displayMode;
    NSDate *lastVisibleDate = self.date; /* Default to self.date */
    
    // for the day mode, just return today
    if (displayMode == CKCalendarViewDisplayModeDay) {
        // The default is fine.
    }
    else if(displayMode == CKCalendarViewDisplayModeWeek)
    {
        lastVisibleDate = [self.calendar lastDayOfTheWeekUsingReferenceDate:self.date];
    }
    else if(displayMode == CKCalendarViewDisplayModeMonth)
    {
        NSDate *lastOfTheMonth = [self.calendar lastDayOfTheMonthUsingReferenceDate:self.date];
        lastVisibleDate = [self.calendar lastDayOfTheWeekUsingReferenceDate:lastOfTheMonth];
    }
    
    return lastVisibleDate;
}

// MARK: - Minimum and Maximum Dates

- (void)setMinimumDate:(NSDate *)minimumDate
{
    if([self _dateIsAfterMaximumDate:minimumDate])
    {
        NSLog(@"It is an error to set a minimum date that is later than the maximum date.");
        return;
    }
    
    _minimumDate = minimumDate;
    
    if (minimumDate && [self _dateIsBeforeMinimumDate:self.date])
    {
        self.date = minimumDate;
        // This will also invalidate, so we don't need to call the observer again here.
    }
    else
    {
        [self informObserverOfInvalidatedState];
    }
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    if([self _dateIsBeforeMinimumDate:maximumDate])
    {
        NSLog(@"It is an error to set a maximum date that is earlier than the minimum date.");
        return;
    }
    
    _maximumDate = maximumDate;
    
    if(maximumDate && [self _dateIsAfterMaximumDate:self.date])
    {
        self.date = maximumDate;
        // This will also invalidate, so we don't need to call the observer again here.
    }
    else
    {
        [self informObserverOfInvalidatedState];
    }
}

- (BOOL)_minimumDateIsBeforeMaximumDate
{
    //  If either isn't set, return YES
    if (![self _hasNonNilMinimumAndMaximumDates]) {
        return YES;
    }
    
    return [self.calendar date:self.minimumDate isBeforeDate:self.maximumDate];
}

- (BOOL)_hasNonNilMinimumAndMaximumDates
{
    return self.minimumDate != nil && self.maximumDate != nil;
}

- (BOOL)_dateIsBeforeMinimumDate:(NSDate *)date
{
    return [self.calendar date:date isBeforeDate:self.minimumDate];
}

- (BOOL)_dateIsAfterMaximumDate:(NSDate *)date
{
    return [self.calendar date:date isAfterDate:self.maximumDate];
}


/**
 Determines if the supplied date is within range of the minimum and maximum dates. 

 @param date The date to check.
 @return `YES` as long as the `date` is not before `minimum` or after `maximum`.
 */
- (BOOL)dateIsBetweenMinimumAndMaximumDates:(NSDate *)date;
{
    //  If there are both the minimum and maximum dates are unset,
    //  behave as if all dates are in range.
    if (!self.minimumDate && !self.maximumDate) {
        return YES;
    }
    
    //  If there's no minimum, treat all dates that are before
    //  the maximum as valid
    else if(!self.minimumDate)
    {
        return [self.calendar date:date isBeforeDate:self.maximumDate];
    }
    
    //  If there's no maximum, treat all dates that are before
    //  the minimum as valid
    else if(!self.maximumDate)
    {
        return [self.calendar date:date isAfterDate:self.minimumDate];
    }
    
    return [self.calendar date:date isAfterDate:self.minimumDate] && [self.calendar date:date isBeforeDate:self.maximumDate];
}

// MARK: - Inform Observer of Invalidated State


/**
 This method lets the observer know that some property has changed.
 Usually this is the calendar view, so that it knows to re-render.
 */
- (void)informObserverOfInvalidatedState
{
    if ([self.observer respondsToSelector:@selector(calendarModelDidInvalidate:)])
    {
        [self.observer calendarModelDidInvalidate:self];
    }
}

// MARK: - Vending Cell Contexts

- (CKCalendarCellContextCache *)cellContextCache
{
    if(!_cellContextCache)
    {
        _cellContextCache = [[CKCalendarCellContextCache alloc] initWithCalendarModel:self];
    }
    
    return _cellContextCache;
}

/**
 Returns a context object for the supplied date.
 
 @param date The date for which we want context.
 @return The context object describing the date.
 */
- (nonnull CKCalendarCellContext *)contextForDate:(nonnull NSDate *)date;
{
    return [self.cellContextCache contextForDate:date];
}
@end
