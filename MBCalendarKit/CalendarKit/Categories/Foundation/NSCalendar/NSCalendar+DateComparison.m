//
//  NSCalendar+DateComparison.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/13/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+DateComparison.h"
#import "NSCalendar+Components.h"

@implementation NSCalendar (DateComparison)

- (BOOL)date:(NSDate *)firstDate isSameDayAs:(NSDate *)anotherDate
{

    NSInteger firstDay = [self daysInDate:firstDate];
    NSInteger secondDay = [self daysInDate:anotherDate];
    
    BOOL sameMonth = [self date:firstDate isSameMonthAs:anotherDate];
    BOOL sameDay = firstDay == secondDay;

    return sameMonth && sameDay;
}

- (BOOL)date:(NSDate*)firstDate isSameWeekAs:(NSDate *)anotherDate
{
    
    NSInteger firstMonth = [self weekOfYearInDate:firstDate];
    NSInteger secondMonth = [self weekOfYearInDate:anotherDate];
    
    BOOL sameMonth = firstMonth == secondMonth;
    BOOL sameYear = [self date:firstDate isSameYearAs:anotherDate];
    
    return sameYear && sameMonth;
}


- (BOOL)date:(NSDate*)firstDate isSameMonthAs:(NSDate *)anotherDate
{
    
    NSInteger firstMonth = [self monthsInDate:firstDate];
    NSInteger secondMonth = [self monthsInDate:anotherDate];
    
    BOOL sameMonth = firstMonth == secondMonth;
    BOOL sameYear = [self date:firstDate isSameYearAs:anotherDate];

    return sameYear && sameMonth;
}

- (BOOL)date:(NSDate *)firstDate isSameYearAs:(NSDate *)anotherDate
{
    NSInteger firstYear = [self yearsInDate:firstDate];
    NSInteger secondYear = [self yearsInDate:anotherDate];
    
    BOOL sameYear = firstYear == secondYear;
    BOOL sameEra =  [self date:firstDate isSameEraAs:anotherDate];

    return sameEra && sameYear;
}

- (BOOL)date:(NSDate *)firstDate isSameEraAs:(NSDate *)anotherDate
{
    NSInteger firstEra = [self eraInDate:firstDate];
    NSInteger secondEra = [self eraInDate:anotherDate];
    
    return firstEra == secondEra;
}

@end
