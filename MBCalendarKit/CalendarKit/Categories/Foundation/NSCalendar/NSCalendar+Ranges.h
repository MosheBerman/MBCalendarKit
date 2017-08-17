//
//  NSCalendar+Ranges.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Ranges)

#pragma mark - Units Per Minute

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerMinute;
- (NSUInteger)secondsPerMinuteUsingReferenceDate:(nonnull NSDate *)date;

#pragma mark - Units Per Hour

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerHour;
- (NSUInteger)secondsPerHourUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerHour;
- (NSUInteger)minutesPerHourUsingReferenceDate:(nonnull NSDate *)date;

#pragma mark - Units Per Day

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerDay;
- (NSUInteger)secondsPerDayUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerDay;
- (NSUInteger)minutesPerDayUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerDay;
- (NSUInteger)hoursPerDayUsingReferenceDate:(nonnull NSDate *)date;

#pragma mark - Units Per Week

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerWeek;
- (NSUInteger)secondsPerWeekUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerWeek;
- (NSUInteger)minutesPerWeekUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerWeek;
- (NSUInteger)hoursPerWeekUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger daysPerWeek;
- (NSUInteger)daysPerWeekUsingReferenceDate:(nonnull NSDate *)date;

#pragma mark - Units Per Month

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerMonth;
- (NSUInteger)secondsPerMonthUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerMonth;
- (NSUInteger)minutesPerMonthUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerMonth;
- (NSUInteger)hoursPerMonthUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger daysPerMonth;
- (NSUInteger)daysPerMonthUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger weeksPerMonth;
- (NSUInteger)weeksPerMonthUsingReferenceDate:(nonnull NSDate *)date;

#pragma mark - Units Per Year

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerYear;
- (NSUInteger)secondsPerYearUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerYear;
- (NSUInteger)minutesPerYearUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerYear;
- (NSUInteger)hoursPerYearUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger daysPerYear;
- (NSUInteger)daysPerYearUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger weeksPerYear;
- (NSUInteger)weeksPerYearUsingReferenceDate:(nonnull NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger monthsPerYear;
- (NSUInteger)monthsPerYearUsingReferenceDate:(nonnull NSDate *)date;

#pragma mark - Ranges Between Dates

//  Negative values indicate that fromDate is after toDate
- (NSInteger)secondsFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate;
- (NSInteger)minutesFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate;
- (NSInteger)hoursFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate;
- (NSInteger)daysFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate;
- (NSInteger)weeksFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate;
- (NSInteger)monthsFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate;
- (NSInteger)yearsFromDate:(nonnull NSDate *)fromDate toDate:(nonnull NSDate *)toDate;

// MARK: - Date Comparison

- (BOOL)date:(nonnull NSDate *)firstDate isBeforeDate:(nonnull NSDate *)anotherDate;
- (BOOL)date:(nonnull NSDate *)firstDate isAfterDate:(nonnull NSDate *)anotherDate;

@end
