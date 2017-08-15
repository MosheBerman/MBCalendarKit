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
    f.dateFormat = @"ccc";
    return [f stringFromDate:self];
}

- (NSString *)monthNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"MMMM";
    return [f stringFromDate:self];
}

- (NSString *)monthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"MMMM yyyy";
    return [f stringFromDate:self];
}

- (NSString *)monthAbbreviationAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"MMM yyyy";
    return [f stringFromDate:self];
}


- (NSString *)monthAbbreviationOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"MMM";
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"MMM d";
    return [f stringFromDate:self];
}

- (NSString *)dayOfMonthOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"d";
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"MMM d yyyy";
    return [f stringFromDate:self];
}


- (NSString *)dayOfMonthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    f.calendar = calendar;
    f.dateFormat = @"d yyyy";
    return [f stringFromDate:self];
}

@end
