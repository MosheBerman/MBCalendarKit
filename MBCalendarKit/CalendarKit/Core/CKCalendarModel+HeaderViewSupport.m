//
//  CKCalendarModel+HeaderViewSupport.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel+HeaderViewSupport.h"
#import "NSCalendarCategories.h"
#import "NSDate+Description.h"

@implementation CKCalendarModel (HeaderViewSupport)

// MARK: - CKCalendarHeaderViewDataSource

- (NSString *)titleForHeader:(CKCalendarHeaderView *)header
{
    CKCalendarDisplayMode mode = self.displayMode;
    
    if(mode == CKCalendarViewModeMonth)
    {
        return [[self date] monthAndYearOnCalendar:self.calendar];
    }
    
    else if (mode == CKCalendarViewModeWeek)
    {
        NSDate *firstVisibleDay = self.firstVisibleDate;
        NSDate *lastVisibleDay = self.lastVisibleDate;
        
        NSMutableString *result = [NSMutableString new];
        
        [result appendString:[firstVisibleDay monthAndYearOnCalendar:self.calendar]];
        
        //  Show the day and year
        if (![self.calendar date:firstVisibleDay isSameMonthAs:lastVisibleDay]) {
            result = [[firstVisibleDay monthAbbreviationAndYearOnCalendar:self.calendar] mutableCopy];
            [result appendString:@" - "];
            [result appendString:[lastVisibleDay monthAbbreviationAndYearOnCalendar:self.calendar]];
        }
        
        
        return result;
    }
    
    //Otherwise, return today's date as a string
    return [[self date] monthAndDayAndYearOnCalendar:self.calendar];
}

- (NSUInteger)numberOfColumnsForHeader:(CKCalendarHeaderView *)header
{
    return [self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self.date].length;
}

- (NSString *)header:(CKCalendarHeaderView *)header titleForColumnAtIndex:(NSInteger)index
{
    NSDate *firstDate = self.firstVisibleDate;
    NSDate *columnToShow = [self.calendar dateByAddingDays:index toDate:firstDate];
    
    return [columnToShow dayNameOnCalendar:self.calendar];
}


- (BOOL)headerShouldHighlightTitle:(CKCalendarHeaderView *)header
{
    CKCalendarDisplayMode mode = self.displayMode;
    
    if (mode == CKCalendarViewModeDay) {
        return [self.calendar date:[NSDate date] isSameDayAs:[self date]];
    }
    
    return NO;
}

- (BOOL)headerShouldDisableBackwardButton:(CKCalendarHeaderView *)header
{
    
    //  Never disable if there's no minimum date
    if (![self minimumDate]) {
        return NO;
    }
    
    CKCalendarDisplayMode mode = self.displayMode;
    
    if (mode == CKCalendarViewModeMonth)
    {
        return [self.calendar date:[self date] isSameMonthAs:[self minimumDate]];
    }
    else if(mode == CKCalendarViewModeWeek)
    {
        return [self.calendar date:[self date] isSameWeekAs:[self minimumDate]];
    }
    
    return [self.calendar date:[self date] isSameDayAs:[self minimumDate]];
}

- (BOOL)headerShouldDisableForwardButton:(CKCalendarHeaderView *)header
{
    
    //  Never disable if there's no minimum date
    if (![self maximumDate]) {
        return NO;
    }
    
    CKCalendarDisplayMode mode = self.displayMode;
    
    if (mode == CKCalendarViewModeMonth)
    {
        return [self.calendar date:[self date] isSameMonthAs:[self maximumDate]];
    }
    else if(mode == CKCalendarViewModeWeek)
    {
        return [self.calendar date:[self date] isSameWeekAs:[self maximumDate]];
    }
    
    return [self.calendar date:[self date] isSameDayAs:[self maximumDate]];
}

// MARK: - CKCalendarHeaderViewDelegate

- (void)forwardTapped
{
    NSDate *date = [self date];
    NSDate *today = [NSDate date];
    
    /* If the cells are animating, don't do anything or we'll break the view */
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    
    if (self.displayMode == CKCalendarViewModeMonth) {
        
        NSUInteger maxDays = [self.calendar daysPerMonthUsingReferenceDate:date];
        NSUInteger todayInMonth =[self.calendar daysInDate:date];
        
        //  If we're the last day of the month, just roll over a day
        if (maxDays == todayInMonth) {
            date = [self.calendar dateByAddingDays:1 toDate:date];
        }
        
        //  Otherwise, add a month and then go to the first of the month
        else{
            date = [self.calendar dateByAddingMonths:1 toDate:date];              //  Add a month
            NSUInteger day = [self.calendar daysInDate:date];                     //  Only then go to the first of the next month.
            date = [self.calendar dateBySubtractingDays:day-1 fromDate:date];
        }
        
        //  If today is in the visible month, jump to today
        if([self.calendar date:date isSameMonthAs:[NSDate date]]){
            NSUInteger distance = [self.calendar daysFromDate:date toDate:today];
            date = [self.calendar dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move ahead by a week, then jump to
     the first day of the week. If the newly visible week
     contains today, we set today as the active date.
     
     */
    
    else if(self.displayMode == CKCalendarViewModeWeek)
    {
        
        date = [self.calendar dateByAddingWeeks:1 toDate:date];                   //  Add a week
        
        NSUInteger dayOfWeek = [self.calendar weekdayInDate:date];
        date = [self.calendar dateBySubtractingDays:dayOfWeek-self.calendar.firstWeekday fromDate:date];   //  Jump to sunday
        
        //  If today is in the visible week, jump to today
        if ([self.calendar date:date isSameWeekAs:today]) {
            NSUInteger distance = [self.calendar daysFromDate:date toDate:today];
            date = [self.calendar dateByAddingDays:distance toDate:date];
        }
        
    }
    
    /*
     
     In day mode, simply move ahead by one day.
     
     */
    
    else{
        date = [self.calendar dateByAddingDays:1 toDate:date];
    }
    
    self.date = date;
}

- (void)backwardTapped
{
    
    NSDate *date = [self date];
    NSDate *today = [NSDate date];
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    if (self.displayMode == CKCalendarViewModeMonth) {
        
        date = [self.calendar dateBySubtractingMonths:1 fromDate:date];       //  Subtract a month
        NSUInteger day = [self.calendar daysInDate:date];
        date = [self.calendar dateBySubtractingDays:day-1 fromDate:date];     //  Go to the first of the month
        
        //  If today is in the visible month, jump to today
        if([self.calendar date:date isSameMonthAs:[NSDate date]]){
            NSUInteger distance = [self.calendar daysFromDate:date toDate:today];
            date = [self.calendar dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move backward by a week, then jump
     to the first day of the week. If the newly visible
     week contains today, we set today as the active date.
     
     */
    
    else if(self.displayMode == CKCalendarViewModeWeek)
    {
        date = [self.calendar dateBySubtractingWeeks:1 fromDate:date];               //  Add a week
        
        NSUInteger dayOfWeek = [self.calendar weekdayInDate:date];
        date = [self.calendar dateBySubtractingDays:dayOfWeek-1 fromDate:date];   //  Jump to sunday
        
        //  If today is in the visible week, jump to today
        if ([self.calendar date:date isSameWeekAs:today]) {
            NSUInteger distance = [self.calendar daysFromDate:date toDate:today];
            date = [self.calendar dateByAddingDays:distance toDate:date];
        }
        
    }
    
    /*
     
     In day mode, simply move backward by one day.
     
     */
    
    else{
        date = [self.calendar dateBySubtractingDays:1 fromDate:date];
    }
    
    self.date = date;
}

@end
