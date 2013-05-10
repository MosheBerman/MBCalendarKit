//
//   MBCalendarKitTests.m
//   MBCalendarKitTests
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "MBCalendarKitTests.h"

#import "NSCalendar+Ranges.h"

#import "NSDate+Components.h"

#import "NSCalendar+Juncture.h"

#import "NSCalendar+Components.h"

@interface MBCalendarKitTests ()

@property (nonatomic, strong) NSCalendar *gregorianCalendar;
@property (nonatomic, strong) NSCalendar *hebrewCalendar;
@property (nonatomic, strong) NSDate *workingDate;

@end

@implementation MBCalendarKitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    _gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _hebrewCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSHebrewCalendar];
    
    _workingDate = nil;
}

- (void)tearDown
{
    // Tear-down code here.
 
    _gregorianCalendar = nil;
    _workingDate = nil;
    
    [super tearDown];
}

#pragma mark - NSDate+Components

/* 
 
 For this test, we create a date using NSDateComponents
 and another from the convenience method. Then assert
 that the resultant date objects are equal.
 
 Each test uses a different calendar, but the process 
 remains the same.

 */

- (void)testDayMonthYearDateConvenienceInitializerWithGregorianCalendar
{
    NSDateComponents *comps = [NSDateComponents new];
    [comps setYear:2013];
    [comps setMonth:2];
    [comps setDay:3];
    
    NSDate *dateFromComponents = [[self gregorianCalendar] dateFromComponents:comps];
    NSDate *dateFromConvenienceMethod = [NSDate dateWithDay:3 Month:2 Year:2013 andCalendar:[self gregorianCalendar]];
    
    STAssertEqualObjects(dateFromComponents, dateFromConvenienceMethod, @"The date objects are not supposed to be different.");
}

- (void)testDayMonthYearDateConvenienceInitializerWithHebrewCalendar
{
    NSDateComponents *comps = [NSDateComponents new];
    [comps setYear:5773];
    [comps setMonth:1];
    [comps setDay:1];
    
    NSDate *dateFromComponents = [[self hebrewCalendar] dateFromComponents:comps];
    NSDate *dateFromConvenienceMethod = [NSDate dateWithDay:1 Month:1 Year:5773 andCalendar:[self hebrewCalendar]];
    
    STAssertEqualObjects(dateFromComponents, dateFromConvenienceMethod, @"The date objects are not supposed to be different.");
}

#pragma mark - NSCalendar+Components

/* 
    
 For this test, we create a date using convenience intializer
 which we tested in the preceeding tests. Then we pull out the
 date components using our convenience methods. We assert that
 the resulting integers are equal to the values that we passed
 in to the initializer.
 
 */

- (void)testDayMonthYearCalendarComponentsWithGregorianCalendar
{
    NSDate *workingDate = [NSDate dateWithDay:23 Month:10 Year:1991 andCalendar:[self gregorianCalendar]];
    
    NSInteger day = [[self gregorianCalendar] daysInDate:workingDate];
    NSInteger month = [[self gregorianCalendar] monthsInDate:workingDate];
    NSInteger year = [[self gregorianCalendar] yearsInDate:workingDate];
    
    STAssertEquals(day, 23, @"Day: %i", day);
    STAssertEquals(month, 10, @"Month: %i", month);
    STAssertEquals(year, 1991, @"Year:%i", year);
}

- (void)testDayMonthYearCalendarComponentsWithHebrewCalendar
{
    NSDate *workingDate = [NSDate dateWithDay:1 Month:1 Year:5773 andCalendar:[self gregorianCalendar]];
    
    NSInteger day = [[self gregorianCalendar] daysInDate:workingDate];
    NSInteger month = [[self gregorianCalendar] monthsInDate:workingDate];
    NSInteger year = [[self gregorianCalendar] yearsInDate:workingDate];
    
    STAssertEquals(day, 1, @"Day: %i", day);
    STAssertEquals(month, 1, @"Month: %i", month);
    STAssertEquals(year, 5773, @"Year:%i", year);
}


#pragma mark - NSCalendar+Range 

- (void)testDaysPerWeekForGregorianCalendar
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

- (void)testDaysPerGregorianYear2010
{
    
    NSDate *jan12010 = [NSDate dateWithDay:1 month:1 year:2010];
    NSDate *jan12011 = [NSDate dateWithDay:1 month:1 year:2011];
    
    NSUInteger assumedResult = 365;
    NSUInteger actualResult = [[self gregorianCalendar] daysFromDate:jan12010 toDate:jan12011];
    
    STAssertEquals(assumedResult, actualResult, @"Assumed: %i Actual: %i", assumedResult, actualResult); 
}


- (void)testDaysPerGregorianYear2012
{
    
    NSDate *jan12012 = [NSDate dateWithDay:1 month:1 year:2012];
    NSDate *jan12013 = [NSDate dateWithDay:1 month:1 year:2013];
    
    NSUInteger assumedResult = 366;
    NSUInteger actualResult = [[self gregorianCalendar] daysFromDate:jan12012 toDate:jan12013];
    
    STAssertEquals(assumedResult, actualResult, @"Assumed: %i Actual: %i", assumedResult, actualResult);
}

#pragma mark - NSCalendar+Juncture

- (void)testFirstDayOfTheWeek
{
    //  April 12, 2013 is a Friday. The preceeding sunday is April 7
    NSDate *april12 = [NSDate dateWithDay:12 month:4 year:2013];
    NSDate *april7 = [NSDate dateWithDay:7 month:4 year:2013];
    
    NSDate *result = [[self gregorianCalendar] firstDayOfTheWeekUsingReferenceDate:april12];
    
    STAssertEqualObjects(result, april7, @"Result :%@", result);
}

- (void)testLastDayOfTheWeek
{
    //  April 15, 2013 is a Monday. The preceeding sunday is April 7
    NSDate *april15 = [NSDate dateWithDay:15 month:4 year:2013];
    NSDate *april20 = [NSDate dateWithDay:20 month:4 year:2013];
    
    NSDate *result = [[self gregorianCalendar] lastDayOfTheWeekUsingReferenceDate:april15];
                      
    
    STAssertEqualObjects(result, april20, @"Result :%@", result);
}

#pragma mark - NSCalendar+Comparison

- (void)testCompareDates
{
    //  TODO: Test comparisons
}

@end
