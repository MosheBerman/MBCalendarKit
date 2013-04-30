//
//  NSCalendar+Ranges.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Ranges)

#pragma mark - Units Per Minute

- (NSUInteger)secondsPerMinute;
- (NSUInteger)secondsPerMinuteUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Hour

- (NSUInteger)secondsPerHour;
- (NSUInteger)secondsPerHourUsingReferenceDate:(NSDate *)date;

- (NSUInteger)minutesPerHour;
- (NSUInteger)minutesPerHourUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Day

- (NSUInteger)secondsPerDay;
- (NSUInteger)secondsPerDayUsingReferenceDate:(NSDate *)date;

- (NSUInteger)minutesPerDay;
- (NSUInteger)minutesPerDayUsingReferenceDate:(NSDate *)date;

- (NSUInteger)hoursPerDay;
- (NSUInteger)hoursPerDayUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Week

- (NSUInteger)secondsPerWeek;
- (NSUInteger)secondsPerWeekUsingReferenceDate:(NSDate *)date;

- (NSUInteger)minutesPerWeek;
- (NSUInteger)minutesPerWeekUsingReferenceDate:(NSDate *)date;

- (NSUInteger)hoursPerWeek;
- (NSUInteger)hoursPerWeekUsingReferenceDate:(NSDate *)date;

- (NSUInteger)daysPerWeek;
- (NSUInteger)daysPerWeekUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Month

- (NSUInteger)secondsPerMonth;
- (NSUInteger)secondsPerMonthUsingReferenceDate:(NSDate *)date;

- (NSUInteger)minutesPerMonth;
- (NSUInteger)minutesPerMonthUsingReferenceDate:(NSDate *)date;

- (NSUInteger)hoursPerMonth;
- (NSUInteger)hoursPerMonthUsingReferenceDate:(NSDate *)date;

- (NSUInteger)daysPerMonth;
- (NSUInteger)daysPerMonthUsingReferenceDate:(NSDate *)date;

- (NSUInteger)weeksPerMonth;
- (NSUInteger)weeksPerMonthUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Year

- (NSUInteger)secondsPerYear;
- (NSUInteger)secondsPerYearUsingReferenceDate:(NSDate *)date;

- (NSUInteger)minutesPerYear;
- (NSUInteger)minutesPerYearUsingReferenceDate:(NSDate *)date;

- (NSUInteger)hoursPerYear;
- (NSUInteger)hoursPerYearUsingReferenceDate:(NSDate *)date;

- (NSUInteger)daysPerYear;
- (NSUInteger)daysPerYearUsingReferenceDate:(NSDate *)date;

- (NSUInteger)weeksPerYear;
- (NSUInteger)weeksPerYearUsingReferenceDate:(NSDate *)date;

- (NSUInteger)monthsPerYear;
- (NSUInteger)monthsPerYearUsingReferenceDate:(NSDate *)date;

#pragma mark - Ranges Between Dates

//  Negative values indicate that fromDate is after toDate
- (NSInteger)secondsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)minutesFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)hoursFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)daysFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;
- (NSInteger)weeksFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;
- (NSInteger)monthsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;
- (NSInteger)yearsFromDate:(NSDate*)fromDate toDate:(NSDate *)toDate;

#pragma mark - Date Comparison

- (BOOL)date:(NSDate *)firstDate isBeforeDate:(NSDate *)anotherDate;
- (BOOL)date:(NSDate *)firstDate isAfterDate:(NSDate *)anotherDate;

@end
