//
//  NSCalendar+Components.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Components)

// MARK: - Extracting Components from Dates

- (NSInteger)weekdayInDate:(nonnull NSDate *)date;
- (NSInteger)secondsInDate:(nonnull NSDate *)date;
- (NSInteger)minutesInDate:(nonnull NSDate *)date;
- (NSInteger)hoursInDate:(nonnull NSDate *)date;
- (NSInteger)daysInDate:(nonnull NSDate *)date;
- (NSInteger)weekOfMonthInDate:(nonnull NSDate *)date;
- (NSInteger)weekOfYearInDate:(nonnull NSDate *)date;
- (NSInteger)monthsInDate:(nonnull NSDate *)date;
- (NSInteger)yearsInDate:(nonnull NSDate *)date;
- (NSInteger)eraInDate:(nonnull NSDate *)date;

@end
