//
//  NSDate+Description.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSDate+Description.h"
#import "CKCache.h"

@implementation NSDate (Description)

- (NSString *)description
{
    NSDateFormatter *formatter = [CKCache.sharedCache dateFormatterWithFormat:@""];
    formatter.timeStyle = NSDateFormatterNoStyle;
    formatter.dateStyle = NSDateFormatterLongStyle;
    return [formatter stringFromDate:self];
}

- (NSString *)dayNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"ccc"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}

- (NSString *)monthNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"MMMM"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}

- (NSString *)monthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"MMMM yyyy"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}

- (NSString *)monthAbbreviationAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"MMM yyyy"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}


- (NSString *)monthAbbreviationOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"MMM"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"MMM d"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}

- (NSString *)dayOfMonthOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"d"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"MMM d yyyy"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}


- (NSString *)dayOfMonthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [CKCache.sharedCache dateFormatterWithFormat:@"d yyyy"];
    f.calendar = calendar;
    f.locale = calendar.locale;
    return [f stringFromDate:self];
}

@end
