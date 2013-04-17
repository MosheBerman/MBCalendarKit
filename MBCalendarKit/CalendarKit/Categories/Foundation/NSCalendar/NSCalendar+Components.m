//
//  NSCalendar+Components.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+Components.h"

@implementation NSCalendar (Components)

- (NSInteger)weekOfMonthInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSWeekOfMonthCalendarUnit fromDate:date];
    return [comps weekOfMonth];
}


- (NSInteger)weekOfYearInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSWeekOfYearCalendarUnit fromDate:date];
    return [comps weekOfYear];
}

- (NSInteger)weekdayInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSWeekdayCalendarUnit fromDate:date];
    return [comps weekday];
}


- (NSInteger)secondsInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSSecondCalendarUnit fromDate:date];
    return [comps second];
}

- (NSInteger)minutesInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSMinuteCalendarUnit fromDate:date];
    return [comps minute];
}

- (NSInteger)hoursInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSHourCalendarUnit fromDate:date];
    return [comps hour];
}

- (NSInteger)daysInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSDayCalendarUnit fromDate:date];
    return [comps day];
}

- (NSInteger)monthsInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSMonthCalendarUnit fromDate:date];
    return [comps month];
}

- (NSInteger)yearsInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSYearCalendarUnit fromDate:date];
    return [comps year];
}

- (NSInteger)eraInDate:(NSDate*)date
{
    NSDateComponents *comps = [self components:NSEraCalendarUnit fromDate:date];
    return [comps era];
}



@end
