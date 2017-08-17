//
//  NSDate+Components.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import Foundation;

@interface NSDate (Components)

#pragma mark Convenenience Intializers

+ (nullable NSDate *)dateWithDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;
+ (nullable NSDate *)dateWithDay:(NSUInteger)day Month:(NSUInteger)month Year:(NSUInteger)year andCalendar:(nonnull NSCalendar *)calendar;

+ (nullable NSDate *)dateWithEra:(NSInteger)era year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second week:(NSInteger)week weekday:(NSInteger)weekday weekdayOrdinal:(NSInteger)weekdayOrdinal andCalendar:(nonnull NSCalendar *)calendar;

#pragma mark - Default values

//    All default values return components of [NSDate date].
+ (NSInteger)defaultEraForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultYearForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultMonthForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultDayForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultHourForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultMinuteForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultSecondForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultWeekForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultWeekdayForCalendar:(nonnull NSCalendar *)calendar;
+ (NSInteger)defaultWeekdayOrdinalForCalendar:(nonnull NSCalendar *)calendar;

//  These use [NSCalendar currentCalendar].
+ (NSInteger)defaultEra;
+ (NSInteger)defaultYear;
+ (NSInteger)defaultMonth;
+ (NSInteger)defaultDay;
+ (NSInteger)defaultHour;
+ (NSInteger)defaultMinute;
+ (NSInteger)defaultSecond;
+ (NSInteger)defaultWeek;
+ (NSInteger)defaultWeekday;
+ (NSInteger)defaultWeekdayOrdinal;



@end
