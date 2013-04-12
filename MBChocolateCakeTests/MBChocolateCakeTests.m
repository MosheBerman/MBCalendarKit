//
//  MBChocolateCakeTests.m
//  MBChocolateCakeTests
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBChocolateCakeTests.h"

#import "NSCalendar+Ranges.h"

#import "NSDate+Components.h"

@interface MBChocolateCakeTests ()

@property (nonatomic, strong) NSCalendar *gregorianCalendar;
@property (nonatomic, strong) NSDate *workingDate;

@end

@implementation MBChocolateCakeTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _workingDate = nil;
}

- (void)tearDown
{
    // Tear-down code here.
 
    _gregorianCalendar = nil;
    _workingDate = nil;
    
    [super tearDown];
}

#pragma mark - Convenience Date Methods

/* 
 
 For this test, we create a date using NSDateComponents
 and another from the convenience method. Then assert
 that the resultant date objects are equal.

 */

- (void)testDayMonthYear
{
    NSDateComponents *comps = [NSDateComponents new];
    [comps setYear:2013];
    [comps setMonth:2];
    [comps setDay:3];
    
    NSDate *dateFromComponents = [[self gregorianCalendar] dateFromComponents:comps];
    NSDate *dateFromConvenienceMethod = [NSDate dateWithDay:3 Month:2 Year:2013 andCalendar:[self gregorianCalendar]];
    
    STAssertEqualObjects(dateFromComponents, dateFromConvenienceMethod, @"The date objects are not supposed to be different.");
}


#pragma mark - Gregorian Range Tests

- (void)testDaysPerWeek
{
    NSInteger daysPerWeek = [[self gregorianCalendar] daysPerWeek];
    STAssertEquals(@(daysPerWeek), @(7), @"Since when are there not 7 days in a Gregorian week?");
}

/* Test February during a standard year - 28 days */

- (void)testDaysPerMonthForStandardGregorianYear
{
    
    const NSUInteger kMonthsPerGregorianYear = 12;
    
    NSUInteger daysPerMonth[kMonthsPerGregorianYear] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    
    for(NSUInteger month = 0; month < kMonthsPerGregorianYear; month++){
        
        NSDate *referenceDate = [NSDate dateWithDay:1 Month:(month+1) Year:2013 andCalendar:[self gregorianCalendar]];
    
        NSUInteger assumedResult = daysPerMonth[month];
        NSUInteger daysPerMonth = [[self gregorianCalendar] daysPerMonthUsingReferenceDate:referenceDate];
    
        STAssertEquals(assumedResult, daysPerMonth, @"Month: %i", month+1);
    }
}

/* Test case is 2016 - the next leap year */

- (void)testDaysPerMonthForGregorianLeapYear
{
    
    const NSUInteger kMonthsPerGregorianYear = 12;
    
    NSUInteger daysPerMonth[kMonthsPerGregorianYear] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    
    for(NSUInteger month = 0; month < kMonthsPerGregorianYear; month++){
        
        NSDate *referenceDate = [NSDate dateWithDay:1 Month:month+1 Year:2016 andCalendar:[self gregorianCalendar]];
        
        NSUInteger assumedResult = daysPerMonth[month];
        NSUInteger daysPerMonth = [[self gregorianCalendar] daysPerMonthUsingReferenceDate:referenceDate];
        
        STAssertEquals(assumedResult, daysPerMonth, @"Assumed and actual month lengths aren't equal.");
    }
}

/* Test Weeks per month in 2013 */

- (void)testWeeksPerMonthForGregorianYear2013
{
    const NSUInteger kMonthsPerGregorianYear = 12;
    
    NSUInteger weeksPerMonth[kMonthsPerGregorianYear] = {5, 5, 6, 5, 5, 6, 5, 5, 5, 5, 5, 5};
    
    
    for(NSUInteger month = 0; month < kMonthsPerGregorianYear; month++){
        
        NSDate *referenceDate = [NSDate dateWithDay:1 Month:month+1 Year:2013 andCalendar:[self gregorianCalendar]];
        
        NSUInteger assumedResult = weeksPerMonth[month];
        NSUInteger daysPerMonth = [[self gregorianCalendar] weeksPerMonthUsingReferenceDate:referenceDate];
        
        STAssertEquals(assumedResult, daysPerMonth, @"Month: %i, Assumed: %i Actual: %i", month, assumedResult, daysPerMonth);
    }
    
}

/* Test Weeks per month in 2009 - February should have 4 weeks */ 

- (void)testWeeksPerMonthForGregorianYear2009
{
    const NSUInteger kMonthsPerGregorianYear = 12;
    
    NSUInteger weeksPerMonth[kMonthsPerGregorianYear] = {5, 4, 5, 5, 6, 5, 5, 6, 5, 5, 5, 5};
    
    
    for(NSUInteger month = 0; month < kMonthsPerGregorianYear; month++){
        
        NSDate *referenceDate = [NSDate dateWithDay:1 Month:month+1 Year:2009 andCalendar:[self gregorianCalendar]];
        
        NSUInteger assumedResult = weeksPerMonth[month];
        NSUInteger daysPerMonth = [[self gregorianCalendar] weeksPerMonthUsingReferenceDate:referenceDate];
        
        STAssertEquals(assumedResult, daysPerMonth, @"Month: %i, Assumed: %i Actual: %i", month, assumedResult, daysPerMonth);
    }
    
}


@end
