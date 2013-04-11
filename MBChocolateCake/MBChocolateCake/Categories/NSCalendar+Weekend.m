//
//  NSCalendar+Weekend.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+Weekend.h"
#import "NSCalendar+Ranges.h"   //  To get the number of days in a week

@implementation NSCalendar (Weekend)

#pragma mark - First/Last Week

- (NSDate *)firstDayOfTheWeek
{
    return [self firstDayOfTheWeekUsingReferenceDate:[NSDate date]];
}

- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date
{
    
    NSUInteger allComponents = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit;
    
    NSDateComponents *c = [self components:allComponents fromDate:date];
    
    [c setWeekday:1];
    
    return [self dateFromComponents:c];
}

- (NSDate *)lastDayOfTheWeek
{
    return [self firstDayOfTheWeekUsingReferenceDate:[NSDate date]];
}

- (NSDate *)lastDayOfTheWeekUsingReferenceDate:(NSDate *)date
{
    
    NSUInteger allComponents = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit;
    
    NSDateComponents *c = [self components:allComponents fromDate:date];
    
    [c setWeekday:[self daysPerWeekUsingReferenceDate:date]];
    
    return [self dateFromComponents:c];
}


#pragma mark - First/Last of Month

- (NSDate *)firstDayOfTheMonth
{
    return [self firstDayOfTheMonthUsingReferenceDate:[NSDate date]];
}

- (NSDate *)firstDayOfTheMonthUsingReferenceDate:(NSDate *)date
{
    NSUInteger allComponents = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit;
    
    NSDateComponents *c = [self components:allComponents fromDate:date];
    
    [c setDay:1];
    
    return [self dateFromComponents:c];
}

- (NSDate *)lastDayOfTheMonth
{
    return [self firstDayOfTheMonthUsingReferenceDate:[NSDate date]];
}

- (NSDate *)lastDayOfTheMonthUsingReferenceDate:(NSDate *)date
{
    NSUInteger allComponents = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit;
    
    NSDateComponents *c = [self components:allComponents fromDate:date];
    
    [c setDay:[self daysPerMonthUsingReferenceDate:date]];
    
    return [self dateFromComponents:c];
}

#pragma mark 
@end
