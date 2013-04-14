//
//  NSDate+Description.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSDate+Description.h"

@implementation NSDate (Description)

- (NSString *)description
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    return [formatter stringFromDate:self];
}

- (NSString *)monthNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMMM"];
    return [f stringFromDate:self];
}

- (NSString *)monthAbbreviationOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMM"];
    return [f stringFromDate:self];
}

@end
