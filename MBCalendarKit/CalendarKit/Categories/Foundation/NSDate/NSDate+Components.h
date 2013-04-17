//
//  NSDate+Components.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Components)

#pragma mark Convenenience Intializers

+ (NSDate *)dateWithDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;
+ (NSDate *)dateWithDay:(NSUInteger)day Month:(NSUInteger)month Year:(NSUInteger)year andCalendar:(NSCalendar *)calendar;

+ (NSDate *)dateWithEra:(NSInteger)era year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second week:(NSInteger)week weekday:(NSInteger)weekday weekdayOrdinal:(NSInteger)weekdayOrdinal andCalendar:(NSCalendar *)calendar;

#pragma mark - Default values

//    All default values return components of [NSDate date].
+ (NSInteger)defaultEraForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultYearForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultMonthForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultDayForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultHourForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultMinuteForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultSecondForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultWeekForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultWeekdayForCalendar:(NSCalendar *)calendar;
+ (NSInteger)defaultWeekdayOrdinalForCalendar:(NSCalendar *)calendar;

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
