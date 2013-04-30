//
//  NSCalendar+Ranges.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+Ranges.h"
#import "NSCalendar+DateManipulation.h"

@implementation NSCalendar (Ranges)

#pragma mark - Units Per Week

/* days per week */

- (NSUInteger)daysPerWeek
{
    return [self daysPerWeekUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)daysPerWeekUsingReferenceDate:(NSDate *)date
{
    NSDate *weekLater = [self dateByAddingWeeks:1 toDate:date];
    return [[self components:NSDayCalendarUnit fromDate:date toDate:weekLater options:0] day];
}

#pragma mark - Units Per Month

- (NSUInteger)daysPerMonth
{
    return [self daysPerMonthUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)daysPerMonthUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (NSUInteger)weeksPerMonth
{
    return [self weeksPerMonthUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)weeksPerMonthUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

#pragma mark - Units Per Year

- (NSUInteger)daysPerYear
{
    return [self daysPerYearUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)daysPerYearUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:date].length;
}

- (NSUInteger)weeksPerYear
{
    return [self weeksPerMonthUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)weeksPerYearUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSWeekCalendarUnit inUnit:NSYearCalendarUnit forDate:date].length;
}


- (NSUInteger)monthsPerYear
{
    return [self monthsPerYearUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)monthsPerYearUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:date].length;
}

#pragma mark - Number of Units Between Dates

- (NSInteger)secondsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    return [[self components:NSSecondCalendarUnit fromDate:fromDate toDate:toDate options:0] second];
}

- (NSInteger)minutesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    return [[self components:NSMinuteCalendarUnit fromDate:fromDate toDate:toDate options:0] minute];
}

- (NSInteger)hoursFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    return [[self components:NSHourCalendarUnit fromDate:fromDate toDate:toDate options:0] hour];
}

- (NSInteger)daysFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[self components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0] day];
}

- (NSInteger)weeksFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[self components:NSWeekCalendarUnit fromDate:fromDate toDate:toDate options:0] week];
}

- (NSInteger)monthsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[self components:NSMonthCalendarUnit fromDate:fromDate toDate:toDate options:0] month];
}

- (NSInteger)yearsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate
{
    return [[self components:NSYearCalendarUnit fromDate:fromDate toDate:toDate options:0] year];
}


#pragma mark - Date Comparison

- (BOOL)date:(NSDate *)firstDate isBeforeDate:(NSDate *)anotherDate
{
    if (!firstDate || !anotherDate)
    {
        return NO;
    }
    
    return [self secondsFromDate:firstDate toDate:anotherDate] > 0;
}

- (BOOL)date:(NSDate *)firstDate isAfterDate:(NSDate *)anotherDate
{
    if (!firstDate || !anotherDate)
    {
        return NO;
    }
    
    return [self secondsFromDate:firstDate toDate:anotherDate] < 0;
}


@end
