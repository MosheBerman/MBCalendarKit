//
//  CKCakeCalendarView.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCakeView.h"

//  Cells
#import "CKCakeHeaderView.h"
#import "CKCakeCell.h"

#import "NSCalendarCategories.h"
#import "NSDate+Description.h"

@interface CKCakeView () <CKCakeHeaderViewDataSource, CKCakeHeaderViewDelegate>

@property (nonatomic, strong) NSMutableSet* spareCells;
@property (nonatomic, strong) NSMutableSet* usedCells;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) CKCakeHeaderView *headerView;

//  The index of the highlighted cell
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation CKCakeView

#pragma mark - Initializers

// Designated Initializer
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
        _spareCells = [NSMutableSet new];
        _usedCells = [NSMutableSet new];
        _selectedIndex = [_calendar daysFromDate:[self _firstVisibleDateForDisplayMode:_displayMode] toDate:_date];
        _headerView = [CKCakeHeaderView new];
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

#pragma mark - Reload

- (void)reloadAnimated:(BOOL)animated
{
    [self _layoutCellsAnimated:animated];
    [[self headerView] reload];
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self layoutSubviews];
    [super willMoveToSuperview:newSuperview];
}

-(void)removeFromSuperview
{
    for (CKCakeCell *cell in [self usedCells]) {
        [cell removeFromSuperview];
    }
    
    [[self headerView] removeFromSuperview];
    
    [super removeFromSuperview];
}

#pragma mark - Size

//  Ensure that the calendar always has the correct size.
- (void)setFrame:(CGRect)frame
{
    frame.size = [self _rectForDisplayMode:[self displayMode]].size;
    
    [super setFrame:frame];
}

- (CGRect)_rectForDisplayMode:(CKCakeDisplayMode)displayMode
{
    CGSize cellSize = [self _cellSize];
    
    CGRect rect = CGRectZero;
    
    if(displayMode == CKCakeViewModeDay)
    {
        //  Hide the cells entirely and only show the events table
        rect = CGRectMake(0, 0, rect.size.width, 0);
        rect.size.height += [[self headerView] frame].size.height;
    }
    
    //  Show one row of days for week mode
    else if (displayMode == CKCakeViewModeWeek) {
        NSUInteger daysPerWeek = [[self calendar] daysPerWeekUsingReferenceDate:[self date]];
        rect = CGRectMake(0, 0, (CGFloat)daysPerWeek*cellSize.width, cellSize.height);
        rect.size.height += [[self headerView] frame].size.height;
    }
    
    //  Show enough for all the visible weeks
    else if(displayMode == CKCakeViewModeMonth)
    {
        CGFloat width = (CGFloat)[self _columnCountForDisplayMode:CKCakeViewModeMonth] * cellSize.width;
        CGFloat height = (CGFloat)[self _rowCountForDisplayMode:CKCakeViewModeMonth] * cellSize.height;
        height += [[self headerView] frame].size.height;
        
        rect = CGRectMake(0, 0, width, height);
    }
    

    return rect;
}

- (CGSize)_cellSize
{
    // These values must be hard coded in order for rectForDisplayMode: to work correctly
    return CGSizeMake(46, 44);
}

#pragma mark - Layout

- (void)layoutSubviews
{
    //  Enforce view dimensions appropriate for given mode
    CGRect frame = [self _rectForDisplayMode:[self displayMode]];
    CGPoint origin = [self frame].origin;
    frame.origin = origin;
    [self setFrame:frame];
    
    CGFloat width = [self _cellSize].width * (CGFloat)[[self calendar] daysPerWeekUsingReferenceDate:[self date]];
        
    CGRect headerFrame = CGRectMake(0, 0, width, 44);
        
    CKCakeHeaderView *header = [self headerView];
    [header setFrame:headerFrame];
    [header setDelegate:self];
    [header setDataSource:self];
    
    //  Show the header
    [self addSubview:[self headerView]];
    
    //  Show the cells
    [self reloadAnimated:NO];
}

- (void)_layoutCellsAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            [self _layoutCells];
        }];
    }
    else
    {
        [self _layoutCells];
    }
}

- (void)_layoutCells
{
    
    for (CKCakeCell *cell in [self usedCells]) {
        [[self spareCells] addObject:cell];
        [cell removeFromSuperview];
    }
    
    for (CKCakeCell *cell in [self spareCells]) {
        [[self usedCells] removeObject:cell];
    }
    
    //  Count the rows and columns that we'll need
    NSUInteger rowCount = [self _rowCountForDisplayMode:[self displayMode]];
    NSUInteger columnCount = [self _columnCountForDisplayMode:[self displayMode]];
    
    //  Cache the cell values for easier readability below
    CGFloat width = [self _cellSize].width;
    CGFloat height = [self _cellSize].height;
    
    //  Cache the start date & header offset
    NSDate *workingDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    CGFloat headerOffset = [[self headerView] frame].size.height;
    
    //  A working index...
    NSUInteger cellIndex = 0;
    
    for (NSUInteger row = 0; row < rowCount; row++) {
        for (NSUInteger column = 0; column < columnCount; column++) {


            /* STEP 1: create and position the cell */
            
            CKCakeCell *cell = [self _dequeueCell];
            
            CGRect frame = CGRectMake(column*width, headerOffset + (row*height), width, height);
            [cell setFrame:frame];
            
            /* STEP 2:  We need to know some information about the cells - namely, if they're in
                        the same month as the selected date and if any of them represent the system's
                        value representing "today".
             */
            
            BOOL cellRepresentsToday = [[self calendar] date:workingDate isSameDayAs:[NSDate date]];
            BOOL isThisMonth = [[self calendar] date:workingDate isSameMonthAs:[self date]];
            
            /* STEP 3:  Here we style the cells accordingly.
             
                        If the cell represents "today" then select it, and set
                        the selectedIndex.
             
                        If the cell is part of another month, gray it out.
             */
            
            if (cellRepresentsToday) {
                [cell setState:CKCakeMonthCellStateTodayDeselected];
            }
            else if (!isThisMonth) {
                [cell setState:CKCakeMonthCellStateInactive];
            }
            else{
                [cell setState:CKCakeMonthCellStateNormal];
            }
            
            /* STEP 4: Show the day of the month in the cell. */
            
            NSUInteger day = [[self calendar] daysInDate:workingDate];
            [cell setNumber:@(day)];
            
            /* STEP 5: Set the index */
            [cell setIndex:cellIndex];
            
            if (cellIndex == [self selectedIndex]) {
                [cell setSelected];
            }
            
            /* STEP 6: Install the cell in the view hierarchy. */
            [self addSubview:cell];
            
            /* STEP 7: Move to the next date before we continue iterating. */
            
            workingDate = [[self calendar] dateByAddingDays:1 toDate:workingDate];
            cellIndex++;
        }
    }
    
}

- (CKCakeCell *)_dequeueCell
{
    CKCakeCell *cell = [[self spareCells] anyObject];
    
    if (!cell) {
        cell = [[CKCakeCell alloc] initWithSize:[self _cellSize]];
    }
    
    //  Move the used cells to the appropriate set
    [[self usedCells] addObject:cell];
    
    if ([[self spareCells] containsObject:cell]) {
        [[self spareCells] removeObject:cell];
    }
    
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

    [self reloadAnimated:NO];
}

- (void)setLocale:(NSLocale *)locale
{
    if (locale == nil) {
        locale = [NSLocale currentLocale];
    }
    
    _locale = locale;
    [[self calendar] setLocale:locale];
    
    [self reloadAnimated:NO];
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
    [self setTimeZone:timeZone animated:NO];
}

- (void)setTimeZone:(NSTimeZone *)timeZone animated:(BOOL)animated
{
    if (!timeZone) {
        timeZone = [NSTimeZone localTimeZone];
    }
    
    [[self calendar] setTimeZone:timeZone];
    
    [self reloadAnimated:animated];
}

- (void)setDisplayMode:(CKCakeDisplayMode)displayMode
{
    [self setDisplayMode:displayMode animated:NO];
}

- (void)setDisplayMode:(CKCakeDisplayMode)displayMode animated:(BOOL)animated
{
    _displayMode = displayMode;
    
    [self reloadAnimated:animated];
}

- (void)setDate:(NSDate *)date
{
    [self setDate:date animated:NO];
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated
{

    if (!date) {
        date = [NSDate date];
    }
    
    _date = date;
    
    //  Update the index
    NSDate *newFirstVisible = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSUInteger index = [[self calendar] daysFromDate:newFirstVisible toDate:date];
    [self setSelectedIndex:index];
    
    [self reloadAnimated:animated];
    
    //  TODO: Call delegate "didSelectDate:"
}

#pragma mark - CKCakeHeaderViewDataSource

- (NSString *)titleForHeader:(CKCakeHeaderView *)header
{
    CKCakeDisplayMode mode = [self displayMode];
    
    if(mode == CKCakeViewModeMonth)
    {
        return [[self date] monthAndYearOnCalendar:[self calendar]];
    }
    
    else if (mode == CKCakeViewModeWeek)
    {
        NSDate *firstVisibleDay = [self _firstVisibleDateForDisplayMode:mode];
        NSDate *lastVisibleDay = [self _lastVisibleDateForDisplayMode:mode];
        
        NSMutableString *result = [NSMutableString new];
        
        //  If the dates are the same years, show MMM DD - DD YYYY
        if ([[self calendar] date:firstVisibleDay isSameYearAs:lastVisibleDay]) {
            [result appendString:[firstVisibleDay monthAndDayOnCalendar:[self calendar]]];
            [result appendString:@" - "];
            
            //  Show the day and year
            if ([[self calendar] date:firstVisibleDay isSameMonthAs:lastVisibleDay]) {
                [result appendString:[lastVisibleDay dayOfMonthAndYearOnCalendar:[self calendar]]];
            }
            
            //  Show the different month, date, and year
            else
            {
                [result appendString:[lastVisibleDay monthAndDayAndYearOnCalendar:[self calendar]]];
            }
        }
        
        //  Otherwise, show MMM DD YYYY - MMM DD YYYY
        else
        {
            [result appendString:[firstVisibleDay monthAndDayAndYearOnCalendar:[self calendar]]];
            [result appendString:@" - "];            
            [result appendString:[lastVisibleDay monthAndDayAndYearOnCalendar:[self calendar]]];
        }
        
        return result;
    }
    
    //Otherwise, return today's date as a string
    return [[self date] monthAndDayAndYearOnCalendar:[self calendar]];
}

- (NSUInteger)numberOfColumnsForHeader:(CKCakeHeaderView *)header
{
    return [self _columnCountForDisplayMode:[self displayMode]];
}

- (NSString *)titleForColumnAtIndex:(NSUInteger)index inHeader:(CKCakeHeaderView *)header
{
    NSDate *firstDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSDate *columnToShow = [[self calendar] dateByAddingDays:index toDate:firstDate];
    
    return [columnToShow dayNameOnCalendar:[self calendar]];
}

#pragma mark - CKCakeHeaderViewDelegate


- (void)forwardTapped
{
    NSDate *date = [self date];
    NSDate *today = [NSDate date];
   
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */

    
    if ([self displayMode] == CKCakeViewModeMonth) {
        
        NSUInteger day = [[self calendar] daysInDate:date];

        date = [[self calendar] dateByAddingMonths:1 toDate:date];              //  Add a month
        date = [[self calendar] dateBySubtractingDays:day-1 fromDate:date];     //  Go to the first of the month
        
        //  If today is in the visible month, jump to today
        if([[self calendar] date:date isSameMonthAs:[NSDate date]]){
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
        
        //apply the new date
        [self setDate:date animated:YES];
    }
    
    /* 
     
     For week mode, we move ahead by a week, then jump to 
     the first day of the week. If the newly visible week 
     contains today, we set today as the active date.
     
     */
    
    else if([self displayMode] == CKCakeViewModeWeek)
    {
        
        date = [[self calendar] dateByAddingWeeks:1 toDate:date];               //  Add a week

        NSUInteger dayOfWeek = [[self calendar] weekdayInDate:date];
        date = [[self calendar] dateBySubtractingDays:dayOfWeek-1 fromDate:date];   //  Jump to sunday
        
        //  If today is in the visible week, jump to today
        if ([[self calendar] date:date isSameWeekAs:today]) {
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }

    }
    
    /*
    
     In day mode, simply move ahead by one day.
     
     */
    
    else{
        date = [[self calendar] dateByAddingDays:1 toDate:date];
    }
    
    //apply the new date
    [self setDate:date animated:YES];
}

- (void)backwardTapped
{

    NSDate *date = [self date];
    NSDate *today = [NSDate date];
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    if ([self displayMode] == CKCakeViewModeMonth) {

        NSUInteger day = [[self calendar] daysInDate:date];
        
        date = [[self calendar] dateBySubtractingMonths:1 fromDate:date];       //  Subtract a month
        date = [[self calendar] dateBySubtractingDays:day-1 fromDate:date];     //  Go to the first of the month
        
        //  If today is in the visible month, jump to today
        if([[self calendar] date:date isSameMonthAs:[NSDate date]]){
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move backward by a week, then jump 
     to the first day of the week. If the newly visible 
     week contains today, we set today as the active date.
     
     */
    
    else if([self displayMode] == CKCakeViewModeWeek)
    {
        
        
        date = [[self calendar] dateBySubtractingWeeks:1 fromDate:date];               //  Add a week
        
        NSUInteger dayOfWeek = [[self calendar] weekdayInDate:date];
        date = [[self calendar] dateBySubtractingDays:dayOfWeek-1 fromDate:date];   //  Jump to sunday
        
        //  If today is in the visible week, jump to today
        if ([[self calendar] date:date isSameWeekAs:today]) {
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
        
    }
    
    /*
     
     In day mode, simply move backward by one day.
     
     */
    
    else{
        date = [[self calendar] dateBySubtractingDays:1 fromDate:date];
    }
    
    //apply the new date
    [self setDate:date animated:YES];
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
    
    return 0
;
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
        
        NSDate *firstVisible = [[self calendar] firstDayOfTheWeekUsingReferenceDate:firstOfTheMonth];
        
        return firstVisible;
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

#pragma mark - Touch Handling

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [touches anyObject];
    
    CGPoint p = [t locationInView:self];
    
    [self pointInside:p withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    
    CGRect bounds = [self bounds];
    bounds.origin.y += [self headerView].frame.size.height;
    bounds.size.height -= [self headerView].frame.size.height;
    
    if (!CGRectContainsPoint(bounds, point)) {
        return YES;
    }
    
    /* Highlight and select the appropriate cell */
     
    NSUInteger index = [self selectedIndex];
    
    for (CKCakeCell *cell in [self usedCells]) {
        CGRect rect = [cell frame];
        if (CGRectContainsPoint(rect, point)) {
            [cell setSelected];
            index = [cell index];
        }
        else
        {
            [cell setDeselected];
        }
    }
    
    [self setSelectedIndex:index];
    
    return [super pointInside:point withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSDate *firstDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSDate *dateToSelect = [[self calendar] dateByAddingDays:[self selectedIndex] toDate:firstDate];
    
    BOOL animated = ![[self calendar] date:[self date] isSameMonthAs:dateToSelect];
    
    [self setDate:dateToSelect animated:animated];
}

// If a touch was cancelled, reset the index
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSDate *firstDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    
    NSUInteger index = [[self calendar] daysFromDate:firstDate toDate:[self date]];
    
    [self setSelectedIndex:index];
}

@end
