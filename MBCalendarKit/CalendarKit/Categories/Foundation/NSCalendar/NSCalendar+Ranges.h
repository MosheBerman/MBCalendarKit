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

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerMinute;
- (NSUInteger)secondsPerMinuteUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Hour

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerHour;
- (NSUInteger)secondsPerHourUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerHour;
- (NSUInteger)minutesPerHourUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Day

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerDay;
- (NSUInteger)secondsPerDayUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerDay;
- (NSUInteger)minutesPerDayUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerDay;
- (NSUInteger)hoursPerDayUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Week

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerWeek;
- (NSUInteger)secondsPerWeekUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerWeek;
- (NSUInteger)minutesPerWeekUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerWeek;
- (NSUInteger)hoursPerWeekUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger daysPerWeek;
- (NSUInteger)daysPerWeekUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Month

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerMonth;
- (NSUInteger)secondsPerMonthUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerMonth;
- (NSUInteger)minutesPerMonthUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerMonth;
- (NSUInteger)hoursPerMonthUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger daysPerMonth;
- (NSUInteger)daysPerMonthUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger weeksPerMonth;
- (NSUInteger)weeksPerMonthUsingReferenceDate:(NSDate *)date;

#pragma mark - Units Per Year

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger secondsPerYear;
- (NSUInteger)secondsPerYearUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger minutesPerYear;
- (NSUInteger)minutesPerYearUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger hoursPerYear;
- (NSUInteger)hoursPerYearUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger daysPerYear;
- (NSUInteger)daysPerYearUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger weeksPerYear;
- (NSUInteger)weeksPerYearUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger monthsPerYear;
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
