//
//  NSCalendar+Junction.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+Junction.h"
#import "NSCalendar+Ranges.h"       //  To get the number of days in a week
#import "NSCalendar+Components.h"   //  To get specific components
#import "NSCalendar+DateManipulation.h"

@implementation NSCalendar (Junction)

#pragma mark - First/Last of Week

- (NSDate *)firstDayOfTheWeek
{
    return [self firstDayOfTheWeekUsingReferenceDate:[NSDate date]];
}

//  FIXME: This seems broken...
- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date
{    
    NSInteger weekday = [self weekdayInDate:date]-1;
    return [self dateBySubtractingDays:weekday fromDate:date];
}

- (NSDate *)lastDayOfTheWeek
{
    return [self firstDayOfTheWeekUsingReferenceDate:[NSDate date]];
}

- (NSDate *)lastDayOfTheWeekUsingReferenceDate:(NSDate *)date
{
    
    NSDateComponents *c = [self components: NSYearForWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
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
    NSDateComponents *c = [self components:NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    [c setDay:1];
    
    return [self dateFromComponents:c];
}

- (NSDate *)lastDayOfTheMonth
{
    return [self firstDayOfTheMonthUsingReferenceDate:[NSDate date]];
}

- (NSDate *)lastDayOfTheMonthUsingReferenceDate:(NSDate *)date
{
    
    NSDateComponents *c = [self components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:date];
    
    [c setDay:[self daysPerMonthUsingReferenceDate:date]];
    
    return [self dateFromComponents:c];
}

#pragma mark 
@end
