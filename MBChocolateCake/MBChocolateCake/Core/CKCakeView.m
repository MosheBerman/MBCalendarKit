//
//  CKCakeCalendarView.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCakeView.h"

//  Categories
#import "NSCalendar+DateManipulation.h"
#import "NSCalendar+Ranges.h"
#import "NSCalendar+Weekend.h"
#import "NSCalendar+Components.h"
#import "NSCalendar+DateComparison.h"

//  Cells
#import "CKCakeMonthCell.h"
//Cell for hourly events

@interface CKCakeView ()

@property (nonatomic, strong) NSMutableSet* cells;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) UIView *titleView;

@end

@implementation CKCakeView

#pragma mark - Initializer

- (id)init
{
    self = [super init];
    
    if (self) {
        _locale = [NSLocale currentLocale];
        _calendar = [NSCalendar currentCalendar];
        [_calendar setLocale:_locale];
        _timeZone = nil;
        _date = [NSDate date];
        _displayMode = CKCakeViewModeMonth;
        _cells = [NSMutableSet new];
    }
    return self;
}

- (id)initWithMode:(CKCakeDisplayMode)cakeDisplayMode
{
    self = [self init];
    if (self) {
        _displayMode = cakeDisplayMode;
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self layoutSubviews];
}

-(void)removeFromSuperview
{
    for (CKCakeMonthCell *cell in [self cells]) {
        [cell removeFromSuperview];
    }
    
    [super removeFromSuperview];
}

#pragma mark - Size and Layout

- (void)layoutSubviews
{
    CGRect frame = [self rectForDisplayMode:[self displayMode]];
    [self setFrame:frame];
    
    [self layoutCellsAnimated:NO];
}

- (CGRect)rectForDisplayMode:(CKCakeDisplayMode)displayMode
{
    CGSize cellSize = [self cellSize];
    
    CGRect rect = CGRectZero;
    
    //  Attempt to use the superview bounds as the default frame
    if ([self superview]) {
        rect = [[self superview] bounds];
    }
    
    //  Otherwise, the default is the bounds of the key window
    else
    {
        rect = [[[UIApplication sharedApplication] keyWindow] bounds];
    }
    
    //  Show one row of days for week mode
    if (displayMode == CKCakeViewModeWeek) {
        NSUInteger daysPerWeek = [[self calendar] daysPerWeekUsingReferenceDate:[self date]];
        rect = CGRectMake(0, 0, (CGFloat)daysPerWeek*cellSize.width, cellSize.height);
        rect.size.height += [[self titleView] frame].size.height;
    }
    
    //  Show enough for all the visible weeks
    else if(displayMode == CKCakeViewModeMonth)
    {        
        CGFloat width = (CGFloat)[self _columnCountForDisplayMode:CKCakeViewModeMonth] * cellSize.width;
        CGFloat height = (CGFloat)[self _rowCountForDisplayMode:CKCakeViewModeMonth] * cellSize.height;
        height += [[self titleView] frame].size.height;
        
        rect = CGRectMake(0, 0, width, height);
    }

    return rect;
}

- (void)layoutCellsAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self layoutCells];
        }];
    }
    else
    {
        [self layoutCells];
    }
}

- (void)layoutCells
{
    
    for (CKCakeMonthCell *cell in [self cells]) {
        [cell removeFromSuperview];
    }
    
    //  Count the rows and columns that we'll need
    NSUInteger rowCount = [self _rowCountForDisplayMode:[self displayMode]];
    NSUInteger columnCount = [self _columnCountForDisplayMode:[self displayMode]];
    
    //  Cache the cell values for easier readability below
    CGFloat width = [self cellSize].width;
    CGFloat height = [self cellSize].height;
    
    //  Cache the start date
    NSDate *workingDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    
    for (NSUInteger row = 0; row < rowCount; row++) {
        for (NSUInteger column = 0; column < columnCount; column++) {

            NSUInteger day = [[self calendar] daysInDate:workingDate];
            
            BOOL cellRepresentsToday = [[self calendar] date:workingDate isSameDayAs:[NSDate date]];
            BOOL isThisMonth = [[self calendar] date:workingDate isSameMonthAs:[self date]];
            
            CKCakeMonthCell *cell = [self dequeueCell];
            
            CGRect frame = CGRectMake(column*width, row*height, width, height);
            [cell setFrame:frame];
            
            [cell setNumber:@(day)];
            
            if (cellRepresentsToday) {
                [cell setState:CKCakeMonthCellStateTodaySelected];
            }
            if (!isThisMonth) {
                [cell setState:CKCakeMonthCellStateInactive];
            }
            
            [self addSubview:cell];
            
            //  Move to the next date
            workingDate = [[self calendar] dateByAddingDays:1 toDate:workingDate];
        }
    }
    
}

- (CKCakeMonthCell *)dequeueCell
{
    CKCakeMonthCell *cell = [[CKCakeMonthCell alloc] initWithSize:[self cellSize]];
    
    //  Move the used cells to the appropriate set
    [[self cells] addObject:cell];
    
    [cell prepareForReuse];
    
    return cell;
}


#pragma mark - Setters
- (void)setCalendar:(NSCalendar *)calendar
{
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    
    _calendar = calendar;
    [_calendar setLocale:_locale];

    [self layoutSubviews];
}

- (void)setLocale:(NSLocale *)locale
{
    if (locale == nil) {
        locale = [NSLocale currentLocale];
    }
    
    _locale = locale;
    [[self calendar] setLocale:locale];
    
    [self layoutSubviews];
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
    if (!timeZone) {
        timeZone = [NSTimeZone localTimeZone];
    }
    
    [[self calendar] setTimeZone:timeZone];
    
    [self layoutSubviews];    
}

- (void)setDisplayMode:(CKCakeDisplayMode)displayMode
{
    [self setDisplayMode:displayMode animated:NO];
}

- (void)setDisplayMode:(CKCakeDisplayMode)displayMode animated:(BOOL)animated
{
    _displayMode = displayMode;
    
    [self layoutCellsAnimated:animated];
}

- (void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{
    
    date = [NSDate date];
    
    _date = date;
    
    [self layoutCellsAnimated:animated];
    
}

#pragma mark - Rows and Columns

- (NSUInteger)_rowCountForDisplayMode:(CKCakeDisplayMode)displayMode
{
    if (displayMode == CKCakeViewModeWeek) {
        return 1;
    }
    else if(displayMode == CKCakeViewModeMonth)
    {
        return [[self calendar] weeksPerMonthUsingReferenceDate:[self date]];
    }
    
    return 1; 
}

- (NSUInteger)_columnCountForDisplayMode:(NSUInteger)displayMode
{
    return [[self calendar] daysPerWeekUsingReferenceDate:[self date]];
}

#pragma mark - Date Calculations

- (NSDate *)_firstVisibleDateForDisplayMode:(CKCakeDisplayMode)displayMode
{
    // for the day mode, just return today
    if (displayMode == CKCakeViewModeDay) {
        return [self date];
    }
    else if(displayMode == CKCakeViewModeWeek)
    {
        return [[self calendar] firstDayOfTheWeekUsingReferenceDate:[self date]];
    }
    else if(displayMode == CKCakeViewModeMonth)
    {
        NSDate *firstOfTheMonth = [[self calendar] firstDayOfTheMonthUsingReferenceDate:[self date]];
        
        return [[self calendar] firstDayOfTheWeekUsingReferenceDate:firstOfTheMonth];
    }
    
    return [self date];
}

- (NSDate *)_lastVisibleDateForDisplayMode:(CKCakeDisplayMode)displayMode
{
    // for the day mode, just return today
    if (displayMode == CKCakeViewModeDay) {
        return [self date];
    }
    else if(displayMode == CKCakeViewModeWeek)
    {
        return [[self calendar] lastDayOfTheWeekUsingReferenceDate:[self date]];
    }
    else if(displayMode == CKCakeViewModeMonth)
    {
        NSDate *lastOfTheMonth = [[self calendar] lastDayOfTheMonthUsingReferenceDate:[self date]];
        return [[self calendar] lastDayOfTheWeekUsingReferenceDate:lastOfTheMonth];
    }
    
    return [self date];
}

- (NSUInteger)_numberOfVisibleDaysforDisplayMode:(CKCakeDisplayMode)displayMode
{
    //  If we're showing one day, well, we only one
    if (displayMode == CKCakeViewModeDay) {
        return 1;
    }
    
    //  If we're showing a week, count the days per week
    else if (displayMode == CKCakeViewModeWeek)
    {
        return [[self calendar] daysPerWeek];
    }
    
    //  If we're showing a month, we need to account for the
    //  days that complete the first and last week of the month
    else if (displayMode == CKCakeViewModeMonth)
    {
        
        NSDate *firstVisible = [self _firstVisibleDateForDisplayMode:CKCakeViewModeMonth];
        NSDate *lastVisible = [self _lastVisibleDateForDisplayMode:CKCakeViewModeMonth];
        return [[self calendar] daysFromDate:firstVisible toDate:lastVisible];
    }
    
    //  Default to 1;
    return 1;
}

#pragma mark - Cell Size

- (CGSize)cellSize
{
    return CGSizeMake(46, 44);
}

@end
