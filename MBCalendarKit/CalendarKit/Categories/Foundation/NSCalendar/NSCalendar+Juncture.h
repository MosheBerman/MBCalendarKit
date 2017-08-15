//
//  NSCalendar+Juncture.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Juncture)


// MARK - Getting the First and Last Days of the Week

/**
 Returns the first day of the week, using `[NSDate date]` as the reference date.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy, nullable) NSDate *firstDayOfTheWeek;

- (nullable NSDate *)firstDayOfTheWeekUsingReferenceDate:(nonnull NSDate *)date;

/**
 The first day of the week, based on the reference day.

 If you pass a value larger than 7, it will probably wrap around, but no guarantees. :D
 
 @param date The date to use to calculate the start of the week.
 @param day An integer value 1-7 representing the weekday. 1 is Sunday, 2 is Monday, etc.
 @return The first weekday of a given week as an NSDate.
 */
- (nullable NSDate *)firstDayOfTheWeekUsingReferenceDate:(nonnull NSDate *)date andStartDay:(NSInteger)day;


/**
 Returns the last day of the week, using `[NSDate date]` as the reference date.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy, nullable) NSDate *lastDayOfTheWeek;

/**
 Returns a date representing the start of the last day of the week that the reference date falls in.
 
 @param date An `NSDate`.
 @return The first day of the month, as an `NSDate`, if `NSCalendar` was successful at computing it.
 */
- (nullable NSDate *)lastDayOfTheWeekUsingReferenceDate:(nonnull NSDate *)date;


// MARK: - Getting Dates Representing the First and Last Days of Month

/**
 Returns the first day of the month, using `[NSDate date]` as the reference date.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy, nullable) NSDate *firstDayOfTheMonth;

/**
 Returns a date representing the start of the first day of the month that the reference date falls in.

 @param date An `NSDate`.
 @return The first day of the month, as an `NSDate`, if `NSCalendar` was successful at computing it.
 */
- (nullable NSDate *)firstDayOfTheMonthUsingReferenceDate:(nonnull NSDate *)date;

/**
 The last of the month, using `[NSDate date]` as the reference date.
 */
@property (NS_NONATOMIC_IOSONLY, readonly, copy, nullable) NSDate *lastDayOfTheMonth;

/**
 Returns a date representing the last day of the month that the reference date falls in.
 
 @param date An `NSDate`.
 @return The first day of the month, as an `NSDate`, if `NSCalendar` was successful at computing it.
 */
- (nullable NSDate *)lastDayOfTheMonthUsingReferenceDate:(nonnull NSDate *)date;

@end
