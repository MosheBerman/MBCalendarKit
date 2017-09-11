//
//  CKCalendarModel+HeaderViewSupport.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel+HeaderViewSupport.h"
#import "CKCalendarModel+DaysPerWeek.h"
#import "NSCalendarCategories.h"
#import "NSDate+Description.h"

@implementation CKCalendarModel (HeaderViewSupport)

// MARK: - CKCalendarHeaderViewDataSource

- (NSString *)titleForHeader:(CKCalendarHeaderView *)header
{
    CKCalendarViewDisplayMode mode = self.displayMode;
    
    if(mode == CKCalendarViewDisplayModeMonth)
    {
        return [self.date monthAndYearOnCalendar:self.calendar];
    }
    
    else if (mode == CKCalendarViewDisplayModeWeek)
    {
        NSDate *firstVisibleDay = self.firstVisibleDate;
        NSDate *lastVisibleDay = self.lastVisibleDate;
        
        NSMutableString *result = [NSMutableString new];
        
        [result appendString:[firstVisibleDay monthAndYearOnCalendar:self.calendar]];
        
        //  Show the day and year
        // TODO: Use NSDateIntervalFormatter on iOS 10+
        BOOL isSameMonth = [self.calendar isDate:firstVisibleDay equalToDate:lastVisibleDay toUnitGranularity:NSCalendarUnitMonth];
        if (!isSameMonth)
        {
            result = [[firstVisibleDay monthAbbreviationAndYearOnCalendar:self.calendar] mutableCopy];
            [result appendString:@" - "];
            [result appendString:[lastVisibleDay monthAbbreviationAndYearOnCalendar:self.calendar]];
        }
        
        
        return result;
    }
    
    //Otherwise, return today's date as a string
    return [self.date monthAndDayAndYearOnCalendar:self.calendar];
}

- (NSUInteger)numberOfColumnsForHeader:(CKCalendarHeaderView *)header
{
    NSInteger numberOfColumns = self.daysPerWeek;
    
    if (self.displayMode == CKCalendarViewDisplayModeDay)
    {
        numberOfColumns = 0;
    }
    
    return numberOfColumns;
}

- (NSString *)header:(CKCalendarHeaderView *)header titleForColumnAtIndex:(NSInteger)index
{
    NSDate *firstDate = self.firstVisibleDate;
    NSDate *columnToShow = [self.calendar dateByAddingDays:index toDate:firstDate];
    NSString *title = nil;
    
    if (self.displayMode != CKCalendarViewDisplayModeDay)
    {
        title = [columnToShow dayNameOnCalendar:self.calendar];
    }
    
    return title;
}

- (BOOL)headerShouldHighlightTitle:(CKCalendarHeaderView *)header
{
    CKCalendarViewDisplayMode mode = self.displayMode;
    
    if (mode == CKCalendarViewDisplayModeDay)
    {
        return [self.calendar isDate:[NSDate date] equalToDate:self.date toUnitGranularity:NSCalendarUnitDay];
    }
    
    return NO;
}

- (BOOL)headerShouldDisableBackwardButton:(CKCalendarHeaderView *)header
{
    //  Never disable if there's no minimum date
    BOOL should = NO;
    
    if (self.minimumDate != nil)
    {
        CKCalendarViewDisplayMode mode = self.displayMode;
        
        if (mode == CKCalendarViewDisplayModeMonth)
        {
            should = [self.calendar isDate:self.date equalToDate:self.minimumDate toUnitGranularity:NSCalendarUnitMonth];
        }
        else if(mode == CKCalendarViewDisplayModeWeek)
        {
            should = [self.calendar isDate:self.date equalToDate:self.minimumDate toUnitGranularity:NSCalendarUnitWeekOfYear];
        }
        else if(mode == CKCalendarViewDisplayModeDay)
        {
            should = [self.calendar isDate:self.date equalToDate:self.minimumDate toUnitGranularity:NSCalendarUnitDay];
        }
    }
    
    return should;
}

- (BOOL)headerShouldDisableForwardButton:(CKCalendarHeaderView *)header
{
    //  Never disable if there's no maximum date
    BOOL should = NO;
    
    if (self.maximumDate != nil)
    {
        CKCalendarViewDisplayMode mode = self.displayMode;
        
        if (mode == CKCalendarViewDisplayModeMonth)
        {
            should = [self.calendar isDate:self.date equalToDate:self.maximumDate toUnitGranularity:NSCalendarUnitMonth];
        }
        else if(mode == CKCalendarViewDisplayModeWeek)
        {
            should = [self.calendar isDate:self.date equalToDate:self.maximumDate toUnitGranularity:NSCalendarUnitWeekOfYear];
        }
        else if (mode == CKCalendarViewDisplayModeDay)
        {
            should = [self.calendar isDate:self.date equalToDate:self.maximumDate toUnitGranularity:NSCalendarUnitDay];
        }
    }
    
    return should;
}

// MARK: - CKCalendarHeaderViewDelegate

- (void)forwardTapped
{
    NSDate *date = self.date;
    NSDate *today = [NSDate date];
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    
    if (self.displayMode == CKCalendarViewDisplayModeMonth) {
        
        NSUInteger maxDays = [self.calendar daysPerMonthUsingReferenceDate:date];
        NSUInteger todayInMonth = [self.calendar daysInDate:date];
        
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
        
        if([self.calendar isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitMonth])
        {
            NSUInteger distance = [self.calendar daysFromDate:date toDate:today];
            date = [self.calendar dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move ahead by a week, then jump to
     the first day of the week. If the newly visible week
     contains today, we set today as the active date.
     
     */
    
    else if(self.displayMode == CKCalendarViewDisplayModeWeek)
    {
        NSDate *oldDate = date;
        date = [self.calendar dateByAddingWeeks:1 toDate:date];                   //  Add a week
        
        // If the first of the next month is in this week, jump to it.
        NSDate *firstOfMonth = [self.calendar firstDayOfTheMonthUsingReferenceDate:date];
        
        BOOL firstOfTheMonthIsSameSameAsOldDate = [self.calendar isDate:oldDate equalToDate:firstOfMonth toUnitGranularity:NSCalendarUnitWeekOfYear];
        BOOL isFirstOfMonthTheOldDate = [self.calendar isDate:oldDate inSameDayAsDate:firstOfMonth];
        
        if(firstOfTheMonthIsSameSameAsOldDate && !isFirstOfMonthTheOldDate)
        {
            date = firstOfMonth;
        }
        else
        {
            NSUInteger dayOfWeek = [self.calendar weekdayInDate:date];
            date = [self.calendar dateBySubtractingDays:dayOfWeek-self.calendar.firstWeekday fromDate:date];   //  Jump to sunday
            
            //  If today is in the visible week, jump to today
            if ([self.calendar isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitWeekOfYear]) {
                NSUInteger distance = [self.calendar daysFromDate:date toDate:today];
                date = [self.calendar dateByAddingDays:distance toDate:date];
            }
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
    
    NSDate *date = self.date;
    NSDate *today = [NSDate date];
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    if (self.displayMode == CKCalendarViewDisplayModeMonth) {
        
        date = [self.calendar dateBySubtractingMonths:1 fromDate:date];       //  Subtract a month
        NSUInteger day = [self.calendar daysInDate:date];
        date = [self.calendar dateBySubtractingDays:day-1 fromDate:date];     //  Go to the first of the month
        
        //  If today is in the visible month, jump to today
        if([self.calendar isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitMonth]){
            NSUInteger distance = [self.calendar daysFromDate:date toDate:today];
            date = [self.calendar dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move backward by a week, then jump
     to the first day of the week. If the newly visible
     week contains today, we set today as the active date.
     
     */
    
    else if(self.displayMode == CKCalendarViewDisplayModeWeek)
    {
        date = [self.calendar dateBySubtractingWeeks:1 fromDate:date];               //  Add a week
        
        NSUInteger dayOfWeek = [self.calendar weekdayInDate:date];
        date = [self.calendar dateBySubtractingDays:dayOfWeek-1 fromDate:date];   //  Jump to sunday
        
        //  If today is in the visible week, jump to today
        if ([self.calendar isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitWeekOfYear]) {
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
