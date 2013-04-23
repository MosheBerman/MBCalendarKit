//
//  NSCalendar+Ranges.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Ranges)

#pragma mark - Units Per Week

- (NSUInteger)daysPerWeek;
- (NSUInteger)daysPerWeekUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Month

- (NSUInteger)daysPerMonth;
- (NSUInteger)daysPerMonthUsingReferenceDate:(NSDate *)date;

- (NSUInteger)weeksPerMonth;
- (NSUInteger)weeksPerMonthUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Year

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
