//
//  NSCalendar+Ranges.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Ranges)

#pragma mark - Per Weeks

- (NSUInteger)daysPerWeek;
- (NSUInteger)daysPerWeekUsingReferenceDate:(NSDate *)date;

#pragma mark - Per Month

- (NSUInteger)daysPerMonth;
- (NSUInteger)daysPerMonthUsingReferenceDate:(NSDate *)date;

- (NSUInteger)weeksPerMonth;
- (NSUInteger)weeksPerMonthUsingDate:(NSDate *)date;

#pragma mark - Per Year

- (NSUInteger)daysPerYear;
- (NSUInteger)daysPerYearUsingReferenceDate:(NSDate *)date;

- (NSUInteger)weeksPerYear;
- (NSUInteger)weeksPerYearUsingReferenceDate:(NSDate *)date;

- (NSUInteger)monthsPerYear;
- (NSUInteger)monthsPerYearUsingReferenceDate:(NSDate *)date;

@end
