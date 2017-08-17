//
//  NSDate+Description.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSDate+Description.h"

@implementation NSDate (Description)

- (NSString *)description
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:self];
}

- (NSString *)dayNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate: @"ccc"];
    return [f stringFromDate:self];
}

- (NSString *)monthNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"MMMM"];
    return [f stringFromDate:self];
}

- (NSString *)monthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"MMMM yyyy"];
    return [f stringFromDate:self];
}

- (NSString *)monthAbbreviationAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"MMM yyyy"];
    return [f stringFromDate:self];
}


- (NSString *)monthAbbreviationOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"MMM"];
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"MMM d"];
    return [f stringFromDate:self];
}

- (NSString *)dayOfMonthOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"d"];
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"MMM d yyyy"];
    return [f stringFromDate:self];
}


- (NSString *)dayOfMonthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.locale = calendar.locale;
    [f  setLocalizedDateFormatFromTemplate:@"d yyyy"];
    return [f stringFromDate:self];
}

@end
