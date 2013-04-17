//
//  NSDate+Description.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Description)

- (NSString *)description;

// Returns a three letter abbreviation of weekday name
- (NSString *)dayNameOnCalendar:(NSCalendar *)calendar;

//  Prints out "January", "February", etc for Gregorian dates.
- (NSString *)monthNameOnCalendar:(NSCalendar *)calendar;

//  Prints out "January 2012", "February 2012", etc for Gregorian dates.
- (NSString *)monthAndYearOnCalendar:(NSCalendar *)calendar;

//  Prints out "Jan 2012", "Feb 2012", etc for Gregorian dates.
- (NSString *)monthAbbreviationAndYearOnCalendar:(NSCalendar *)calendar;

//  Prints out "January 3", "February 28", etc for Gregorian dates.
- (NSString *)monthAndDayOnCalendar:(NSCalendar *)calendar;

//  Prints out "Jan", "Feb", etc for Gregorian dates.
- (NSString *)monthAbbreviationOnCalendar:(NSCalendar *)calendar;

//  Prints out a number, representing the day of the month
- (NSString *)dayOfMonthOnCalendar:(NSCalendar *)calendar;

//  Prints out, for example, January 12, 2013
- (NSString *)monthAndDayAndYearOnCalendar:(NSCalendar *)calendar;

// Prints out dates such as 12, 2013
- (NSString *)dayOfMonthAndYearOnCalendar:(NSCalendar *)calendar;
@end
