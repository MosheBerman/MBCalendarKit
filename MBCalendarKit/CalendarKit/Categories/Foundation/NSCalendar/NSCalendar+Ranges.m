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

#pragma mark - Units per Minute

- (NSUInteger)secondsPerMinute
{
    return [self secondsPerMinuteUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)secondsPerMinuteUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSSecondCalendarUnit inUnit:NSMinuteCalendarUnit forDate:date].length;
}

#pragma mark - Units Per Hour

- (NSUInteger)secondsPerHour
{
    return [self secondsPerHourUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)secondsPerHourUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSSecondCalendarUnit inUnit:NSHourCalendarUnit forDate:date].length;
}

- (NSUInteger)minutesPerHour
{
    return [self minutesPerHourUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)minutesPerHourUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSMinuteCalendarUnit inUnit:NSHourCalendarUnit forDate:date].length;
}

#pragma mark - Units per Day

- (NSUInteger)secondsPerDay
{
    return [self secondsPerDayUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)secondsPerDayUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSSecondCalendarUnit inUnit:NSDayCalendarUnit forDate:date].length;
}

- (NSUInteger)minutesPerDay
{
    return [self minutesPerDayUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)minutesPerDayUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSMinuteCalendarUnit inUnit:NSDayCalendarUnit forDate:date].length;
}

- (NSUInteger)hoursPerDay
{
    return [self hoursPerDayUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)hoursPerDayUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSHourCalendarUnit inUnit:NSDayCalendarUnit forDate:date].length;
}

#pragma mark - Units Per Week

- (NSUInteger)secondsPerWeek
{
    return [self secondsPerWeekUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)secondsPerWeekUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSSecondCalendarUnit inUnit:NSWeekCalendarUnit forDate:date].length;
}

- (NSUInteger)minutesPerWeek
{
    return [self minutesPerWeekUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)minutesPerWeekUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSMinuteCalendarUnit inUnit:NSWeekCalendarUnit forDate:date].length;
}

- (NSUInteger)hoursPerWeek
{
    return [self hoursPerWeekUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)hoursPerWeekUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSHourCalendarUnit inUnit:NSWeekCalendarUnit forDate:date].length;
}

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

- (NSUInteger)secondsPerMonth
{
    return [self secondsPerMonthUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)secondsPerMonthUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSSecondCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (NSUInteger)minutesPerMonth
{
    return [self minutesPerMonthUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)minutesPerMonthUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSMinuteCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

- (NSUInteger)hoursPerMonth
{
    return [self hoursPerMonthUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)hoursPerMonthUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSHourCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
}

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

- (NSUInteger)secondsPerYear
{
    return [self secondsPerYearUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)secondsPerYearUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSSecondCalendarUnit inUnit:NSYearCalendarUnit forDate:date].length;
}

- (NSUInteger)minutesPerYear
{
    return [self minutesPerYearUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)minutesPerYearUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSMinuteCalendarUnit inUnit:NSYearCalendarUnit forDate:date].length;
}

- (NSUInteger)hoursPerYear
{
    return [self hoursPerYearUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)hoursPerYearUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSHourCalendarUnit inUnit:NSYearCalendarUnit forDate:date].length;
}

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
    return [[self components:NSCalendarUnitWeekOfYear fromDate:fromDate toDate:toDate options:0] weekOfYear];
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
//        NSLog(@"(MBCalendarKit | NSCalendar + Ranges) : One of the dates are missing, can't compare.");
        return NO;
    }
    
    return [firstDate timeIntervalSinceDate:anotherDate] < 0;
}

- (BOOL)date:(NSDate *)firstDate isAfterDate:(NSDate *)anotherDate
{
    if (!firstDate || !anotherDate)
    {
//        NSLog(@"(MBCalendarKit | NSCalendar + Ranges) : One of the dates are missing, can't compare.");
        return NO;
    }
    
    return [firstDate timeIntervalSinceDate:anotherDate] > 0;
}


@end
