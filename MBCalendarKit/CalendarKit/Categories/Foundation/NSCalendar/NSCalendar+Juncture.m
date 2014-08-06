//
//  NSCalendar+Juncture.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+Juncture.h"
#import "NSCalendar+Ranges.h"       //  To get the number of days in a week
#import "NSCalendar+Components.h"   //  To get specific components
#import "NSCalendar+DateManipulation.h"

@implementation NSCalendar (Juncture)

#pragma mark - First/Last of Week

- (NSDate *)firstDayOfTheWeek
{
    return [self firstDayOfTheWeekUsingReferenceDate:[NSDate date]];
}

- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date
{
    return [self firstDayOfTheWeekUsingReferenceDate:date andStartDay:1];
}

/**
 *  @return The first weekday of a given week as an NSDate.
 *
 *  @param data The date to use to calculate the start of the week.
 *  @param day An integer value 1-7 representing the weekday. 1 is Sunday, 2 is Monday, etc.
 *  If you pass a value larger than 7, it will probably wrap around, but no guarantees. :D
 *
 */

- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date andStartDay:(NSInteger)day
{
    NSInteger weekday = [self weekdayInDate:date]-day;
    return [self dateBySubtractingDays:weekday fromDate:date];
}

- (NSDate *)lastDayOfTheWeek
{
    return [self lastDayOfTheWeekUsingReferenceDate:[NSDate date]];
}

- (NSDate *)lastDayOfTheWeekUsingReferenceDate:(NSDate *)date
{
    
    NSDate *d = [self firstDayOfTheWeekUsingReferenceDate:date];
    NSUInteger daysPerWeek = [self daysPerWeekUsingReferenceDate:d];
    return [self dateByAddingDays:daysPerWeek-1 toDate:d];
}


#pragma mark - First/Last of Month

- (NSDate *)firstDayOfTheMonth
{
    return [self firstDayOfTheMonthUsingReferenceDate:[NSDate date]];
}

- (NSDate *)firstDayOfTheMonthUsingReferenceDate:(NSDate *)date
{
    NSDateComponents *c = [self components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    [c setDay:1];
    
    return [self dateFromComponents:c];
}

- (NSDate *)lastDayOfTheMonth
{
    return [self lastDayOfTheMonthUsingReferenceDate:[NSDate date]];
}

- (NSDate *)lastDayOfTheMonthUsingReferenceDate:(NSDate *)date
{
    
    NSDateComponents *c = [self components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    
    [c setDay:[self daysPerMonthUsingReferenceDate:date]];
    
    return [self dateFromComponents:c];
}

#pragma mark 
@end
