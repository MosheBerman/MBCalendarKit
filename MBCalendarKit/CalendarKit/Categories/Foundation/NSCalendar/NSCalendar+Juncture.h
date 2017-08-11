//
//  NSCalendar+Juncture.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Juncture)

#pragma mark - First of Week

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *firstDayOfTheWeek;
- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date;

/**
 *  @return The first weekday of a given week as an NSDate.
 *
 *  @param date The date to use to calculate the start of the week.
 *  @param day An integer value 1-7 representing the weekday. 1 is Sunday, 2 is Monday, etc.
 *  If you pass a value larger than 7, it will probably wrap around, but no guarantees. :D
 *
 */

- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date andStartDay:(NSInteger)day;

#pragma mark - Last of Week

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *lastDayOfTheWeek;
- (NSDate *)lastDayOfTheWeekUsingReferenceDate:(NSDate *)date;

#pragma mark - First/Last of Month

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *firstDayOfTheMonth;
- (NSDate *)firstDayOfTheMonthUsingReferenceDate:(NSDate *)date;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *lastDayOfTheMonth;
- (NSDate *)lastDayOfTheMonthUsingReferenceDate:(NSDate *)date;

@end
