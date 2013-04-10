//
//  CKCakeCalendarView.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCakeView.h"
#import "NSCalendar+Ranges.h"

@interface CKCakeView ()

@property (nonatomic, strong) NSMutableSet* usedCells;
@property (nonatomic, strong) NSMutableSet* spareCells;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) NSDate *firstVisibleDate;
@property (nonatomic, strong) NSDate *lastVisibleDate;

@end

@implementation CKCakeView

#pragma mark - Initializer

- (id)init
{
    CGRect frame = [[[UIApplication sharedApplication] keyWindow] bounds];
    self = [super initWithFrame:frame];
    
    if (self) {
        _locale = [NSLocale currentLocale];
        _calendar = [NSCalendar currentCalendar];
        _timeZone = nil;
        _date = [NSDate date];
    }
    return self;
}

#pragma mark - Setters

- (void)setCalendar:(NSCalendar *)calendar
{
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    _calendar = calendar;
}

- (void)setLocale:(NSLocale *)locale
{
    if (locale == nil) {
        locale = [NSLocale currentLocale];
    }
    
    _locale = locale;
}

#pragma mark - Bounds Calculations

- (NSDate *)firstVisibleDateForDisplayMode:(CKCakeViewMode)displayMode
{

    // for the day mode, just return today
    if (displayMode == CKCakeViewModeDay) {
        return [self date];
    }
    else if(displayMode == CKCakeViewModeWeek)
    {
            
    }
    
}

- (NSDate *)lastVisibleDateForDisplayMode:(CKCakeViewMode)displayMode
{
    // for the day mode, just return today
    if (displayMode == CKCakeViewModeDay) {
        return [self date];
    }
    
    
}

#pragma mark - Current Date 

- (NSInteger)weekday
{
    return [[self calendar] components:NSWeekdayCalendarUnit fromDate:[self date]].weekday;
}

#pragma mark - Date Bounds 

- (NSDate *)firstDateOfTheWeek
{
    NSInteger weekday = [self weekday];
    NSInteger weekStart = [self firstDayOfTheWeek];
    
    NSUInteger difference = abs(weekday - weekStart);
    
    NSDate *firstDay;
    
    if (weekStart > weekday) {
        
    }
}

- (NSDate *)lastDayOfTheWeek
{
    
}

#pragma mark - Cell Configuration

/* Returns the size of a cell */

- (CGSize)sizeForCell
{
    CGRect frame = [self frame];
    
    CGFloat side = frame.size.width/7;
    
    return CGSizeMake(side, side);
}

@end
