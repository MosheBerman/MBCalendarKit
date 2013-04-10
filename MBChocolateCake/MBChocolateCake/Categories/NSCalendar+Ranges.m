//
//  NSCalendar+Ranges.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+Ranges.h"

@implementation NSCalendar (Ranges)

#pragma mark - Units Per Week

/* days per week */

- (NSUInteger)daysPerWeek
{
    return [self daysPerWeekUsingReferenceDate:[NSDate date]];
}

- (NSUInteger)daysPerWeekUsingReferenceDate:(NSDate *)date
{
    return [self rangeOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date].length;
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
    return [self weeksPerMonthUsingDate:[NSDate date]];
}

- (NSUInteger)weeksPerMonthUsingDate:(NSDate *)date
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
    return [self weeksPerMonthUsingDate:[NSDate date]];
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

@end
