//
//   CKCalendarView.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import QuartzCore;

#import "CKCalendarView.h"

//  Auxiliary Views
#import "CKCalendarHeaderView.h"
#import "CKCalendarCell.h"
#import "CKTableViewCell.h"
#import "CKCalendarAnimationWrapperView.h"

#import "NSCalendarCategories.h"
#import "NSDate+Description.h"
#import "UIView+AnimatedFrame.h"

@interface CKCalendarView () <CKCalendarHeaderViewDataSource, CKCalendarHeaderViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSUInteger _firstWeekDay;
}

@property (nonatomic, strong) NSMutableArray <CKCalendarCell *> * spareCells;
@property (nonatomic, strong) NSMutableArray <CKCalendarCell *> * usedCells;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong) CKCalendarHeaderView *headerView;

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *events;

//  The index of the highlighted cell
@property (nonatomic, assign) NSUInteger selectedIndex;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) CKCalendarAnimationWrapperView *wrapper;
@property (nonatomic, strong) NSDate *previousDate;
@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation CKCalendarView

#pragma mark - Initializers

// Designated Initializer

-(void)commonInitializer {
    _locale = [NSLocale currentLocale];
    _calendar = [NSCalendar autoupdatingCurrentCalendar];
    [_calendar setLocale:_locale];
    _timeZone = nil;
    _date = [NSDate date];
    
    NSDateComponents *components = [_calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_date];
    _date = [_calendar dateFromComponents:components];
    
    _displayMode = CKCalendarViewModeMonth;
    _spareCells = [NSMutableArray new];
    _usedCells = [NSMutableArray new];
    _selectedIndex = [_calendar daysFromDate:[self _firstVisibleDateForDisplayMode:_displayMode] toDate:_date];
    _headerView = [CKCalendarHeaderView new];
    
    
    //  Accessory Table
    _table = [UITableView new];
    [_table setDelegate:self];
    [_table setDataSource:self];
    
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"noDataCell"];
    
    //  Events for selected date
    _events = [NSMutableArray new];
    
    //  Used for animation
    _previousDate = [NSDate date];
    _wrapper = nil;
    _isAnimating = NO;
    
    //  Date bounds
    _minimumDate = nil;
    _maximumDate = nil;
    
    //  First Weekday
    _firstWeekDay = [_calendar firstWeekday];
    
}
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype)initWithMode:(CKCalendarDisplayMode)CalendarDisplayMode
{
    self = [self init];
    if (self) {
        _displayMode = CalendarDisplayMode;
    }
    return self;
}
- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitializer];
    }
    return self;
    
}

#pragma mark -

- (BOOL)translatesAutoresizingMaskIntoConstraints
{
    return NO;
}

#pragma mark - Reload

- (void)reload
{
    [self reloadAnimated:NO];
}

- (void)reloadAnimated:(BOOL)animated
{
    /**
     *  Sort the events.
     */
    
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        NSArray *sortedArray = [[[self dataSource] calendarView:self eventsForDate:[self date]] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *d1 = [obj1 date];
            NSDate *d2 = [obj2 date];
            
            return [d1 compare:d2];
        }];
        
        [self setEvents:sortedArray];
    }
    
    /**
     *  Call reloadData on the table.
     */
    
    [[self table] reloadData];
    
    /**
     *  TODO: Possibly add a delegate method here, per issue #20.
     */
    
    /**
     *  Reload the calendar view.
     */
    
    [self updateConstraintsAnimated:animated];
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [[self layer] setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [[self layer] setShadowOffset:CGSizeMake(0, 3)];
    [[self layer] setShadowOpacity:1.0];
    
    [self reloadAnimated:NO];
    
    [super willMoveToSuperview:newSuperview];
}

-(void)removeFromSuperview
{
    for (CKCalendarCell *cell in [self usedCells]) {
        [cell removeFromSuperview];
    }
    
    [[self headerView] removeFromSuperview];
    
    [super removeFromSuperview];
}

#pragma mark - Size

- (CGFloat)_heightForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    CGFloat height = CGRectGetHeight(self.headerView.bounds); /* CKCalendarViewModeDay */
    
    if (displayMode == CKCalendarViewModeWeek)
    {

        CGFloat daysPerWeek = [self.calendar daysPerWeek];
        if(daysPerWeek > 0)
        {
            height = CGRectGetHeight(self.headerView.bounds) + CGRectGetWidth(self.superview.bounds)/daysPerWeek;
        }
    }
    else if (displayMode == CKCalendarViewModeMonth)
    {
        height = CGRectGetHeight(self.headerView.bounds) + CGRectGetWidth(self.superview.bounds);
    }
    
    return height;
}

- (CGRect)_rectForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    if(self.superview)
    {
        rect = self.superview.bounds;
    }
    
    if(displayMode == CKCalendarViewModeDay)
    {
        //  Hide the cells entirely and only show the events table
        rect = CGRectMake(0, 0, rect.size.width, self.headerView.bounds.size.height);
    }
    
    //  Show one row of days for week mode
    if (displayMode == CKCalendarViewModeWeek) {
        rect = [self _rectForCellsForDisplayMode:displayMode];
        rect.size.height += [[self headerView] frame].size.height;
        rect.origin.y -= [[self headerView] frame].size.height;
    }
    
    //  Show enough for all the visible weeks
    else if(displayMode == CKCalendarViewModeMonth)
    {
        rect = [self _rectForCellsForDisplayMode:displayMode];
        rect.size.height += [[self headerView] frame].size.height;
        rect.origin.y -= [[self headerView] frame].size.height;
    }
    
    return rect;
}

- (CGRect)_rectForCellsForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    CGSize cellSize = [self _cellSize];
    
    if (displayMode == CKCalendarViewModeDay) {
        return CGRectZero;
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        NSUInteger daysPerWeek = [[self calendar] daysPerWeekUsingReferenceDate:[self date]];
        return CGRectMake(0, cellSize.height, (CGFloat)daysPerWeek*cellSize.width, cellSize.height);
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        CGFloat width = (CGFloat)[self _columnCountForDisplayMode:CKCalendarViewModeMonth] * cellSize.width;
        CGFloat height = (CGFloat)[self _rowCountForDisplayMode:CKCalendarViewModeMonth] * cellSize.height;
        return CGRectMake(0, [[self headerView] bounds].size.height, width, height);
    }
    return CGRectZero;
}

- (CGSize)_cellSize
{
    CGSize windowSize = UIScreen.mainScreen.bounds.size;
    
    NSCalendar *calendar = self.calendar;
    
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    
    CGFloat numberOfDaysPerWeek = [calendar daysPerWeek];
    
    CGFloat sizeToFitTo = MIN(windowSize.width, windowSize.height);
    
    CGFloat width = windowSize.width/numberOfDaysPerWeek;
    CGFloat height = sizeToFitTo/numberOfDaysPerWeek;
    
    return CGSizeMake(width, height);
}

- (void)updateConstraints
{
    [self updateConstraintsAnimated:NO];
    [super updateConstraints];
}

- (void)updateConstraintsAnimated:(BOOL)animated
{
    [self _updateDimensionsForModeAnimated:animated];
    [self _installWrapper];
    [self _installHeader];
    [self _layoutCellsAnimated:animated];
    [self _installTable];
}

- (CGSize)intrinsicContentSize
{
    CGFloat height = [self _heightForDisplayMode:self.displayMode];
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Updating the Calendar's Height

- (void)_updateDimensionsForModeAnimated:(BOOL)animated
{
    /*  Enforce view dimensions appropriate for given mode */
    
    if(!self.heightConstraint)
    {
        self.heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:0.0];
    }
    
    if (![self.constraints containsObject:self.heightConstraint])
    {
        [self addConstraint:self.heightConstraint];
    }
    
    NSTimeInterval duration = 0.3;
    
    if (!animated)
    {
        duration = 0.0;
    }
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.heightConstraint.constant = [self _rectForDisplayMode:self.displayMode].size.height;
                         [self.superview layoutIfNeeded];
                     }];
}

#pragma mark -

- (void)_installTable
{
    if (!self.superview)
    {
        return;
    }
    
    /* Set up the table */
    [self.superview addSubview:self.table];
    [self.superview bringSubviewToFront:self];
    
    self.table.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.table
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.table
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.superview
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0.0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.table
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.table
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0];
    
    [self.superview addConstraints:@[leading, trailing, top, bottom]];
    
}

#pragma mark -

- (void)_installWrapper
{
    if(!self.wrapper)
    {
        self.wrapper = [CKCalendarAnimationWrapperView new];
        self.wrapper.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeHeight
                                                                 multiplier:1.0
                                                                   constant:0.0];
        
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0];
        
        [self addSubview:self.wrapper];
        [self addConstraints:@[centerX, centerY, height, width]];
        
        [self.wrapper setClipsToBounds:YES];
    }
}

- (void)_installHeader
{
    /* Install the header */
    
    CKCalendarHeaderView *header = [self headerView];
    header.translatesAutoresizingMaskIntoConstraints = NO;
    [header setDelegate:self];
    [header setDataSource:self];
    [header setNeedsLayout];
    
    if (![self.subviews containsObject:self.headerView])
    {
        [self.wrapper addSubview:self.headerView];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.headerView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.wrapper
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:0.0];
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.wrapper
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.wrapper
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0];
        
        [self.wrapper addConstraints:@[top, leading, trailing]];
    }
}

#pragma mark - Lay Out Cells

- (void)_layoutCells
{
    [self _layoutCellsAnimated:YES];
}

- (void)_layoutCellsAnimated:(BOOL)animated
{
    
    if ([self isAnimating]) {
        return;
    }
    
    [self setIsAnimating:YES];
    
    NSMutableArray <CKCalendarCell *> *cellsToRemoveAfterAnimation = [[self usedCells] mutableCopy];
    NSMutableArray <CKCalendarCell *> *cellsBeingAnimatedIntoView = [NSMutableArray new];
    
    /* Calculate the pre-animation offset */
    
    CGFloat yOffset = 0;
    
    BOOL isDifferentMonth = ![[self calendar] date:[self date] isSameMonthAs:[self previousDate]];
    BOOL isNextMonth = isDifferentMonth && ([[self date] timeIntervalSinceDate:[self previousDate]] > 0);
    BOOL isPreviousMonth = isDifferentMonth && (!isNextMonth);
    
    // If the next month is about to be shown, we want to add the new cells at the bottom of the calendar
    if (isNextMonth) {
        yOffset = [self _rectForCellsForDisplayMode:[self displayMode]].size.height - [self _cellSize].height;
    }
    
    //  If we're showing the previous month, add the cells at the top
    else if(isPreviousMonth)
    {
        yOffset = -([self _rectForCellsForDisplayMode:[self displayMode]].size.height) + [self _cellSize].height;
    }
    
    else if ([[self calendar] date:[self previousDate] isSameDayAs:[self date]])
    {
        yOffset = 0;
    }
    
    //  Count the rows and columns that we'll need
    NSUInteger rowCount = [self _rowCountForDisplayMode:[self displayMode]];
    NSUInteger columnCount = [self _columnCountForDisplayMode:[self displayMode]];
    
    //  Cache the start date & header offset
    NSDate *workingDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    
    //  A working index...
    NSUInteger cellIndex = 0;
    
    for (NSUInteger row = 0; row < rowCount; row++) {
        for (NSUInteger column = 0; column < columnCount; column++) {
            
            /* STEP 1: create the cell */
            
            CKCalendarCell *cell = [self _dequeueCell];
            
            /* STEP 2:  We need to know some information about the cells - namely, if they're in
             the same month as the selected date and if any of them represent the system's
             value representing "today".
             */
            
            BOOL cellRepresentsToday = [[self calendar] date:workingDate isSameDayAs:[NSDate date]];
            BOOL isThisMonth = [[self calendar] date:workingDate isSameMonthAs:[self date]];
            BOOL isInRange = [self _dateIsBetweenMinimumAndMaximumDates:workingDate];
            isInRange = isInRange || [[self calendar] date:workingDate isSameDayAs:[self minimumDate]];
            isInRange = isInRange || [[self calendar] date:workingDate isSameDayAs:[self maximumDate]];
            
            /* STEP 3:  Here we style the cells accordingly.
             
             If the cell represents "today" then select it, and set
             the selectedIndex.
             
             If the cell is part of another month, gray it out.
             
             If the cell can't be selected, hide the number entirely.
             */
            
            if (cellRepresentsToday && isThisMonth && isInRange) {
                [cell setState:CKCalendarMonthCellStateTodayDeselected];
            }
            else if(!isInRange)
            {
                [cell setOutOfRange];
            }
            else if (!isThisMonth) {
                [cell setState:CKCalendarMonthCellStateInactive];
            }
            else
            {
                [cell setState:CKCalendarMonthCellStateNormal];
            }
            
            /* STEP 4: Show the day of the month in the cell. */
            
            NSUInteger day = [[self calendar] daysInDate:workingDate];
            [cell setNumber:@(day)];
            
            
            /* STEP 5: Show event dots */
            
            if([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)])
            {
                BOOL showDot = ([[[self dataSource] calendarView:self eventsForDate:workingDate] count] > 0);
                [cell setShowDot:showDot];
            }
            else
            {
                [cell setShowDot:NO];
            }
            
            /* STEP 6: Set the index */
            [cell setIndex:cellIndex];
            
            if (cellIndex == [self selectedIndex]) {
                [cell setSelected];
            }
            
            /* Step 7: Prepare the cell for animation */
            [cellsBeingAnimatedIntoView addObject:cell];
            
            /* STEP 8: Install the cell in the view hierarchy. */
            [self.wrapper addSubview:cell];
            
            /* STEP 9: Position the cell. */
            
            if(!cell.topConstraint)
            {
                cell.topConstraint = [NSLayoutConstraint constraintWithItem:cell
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.headerView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0];
            }
            
            if (!cell.leadingConstraint)
            {
                cell.leadingConstraint = [NSLayoutConstraint constraintWithItem:cell
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.wrapper
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:0.0];
            }
            
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:cell
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.wrapper
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0/columnCount
                                                                      constant:0.0];
            
            
            cell.topConstraint.constant = yOffset + (row * self._cellSize.height);
            cell.leadingConstraint.constant = column * self._cellSize.width;
            
            [self.wrapper addConstraints:@[cell.topConstraint, cell.leadingConstraint, width]];
            
            [self layoutIfNeeded];
            
            /* STEP 9: Move to the next date before we continue iterating. */
            workingDate = [[self calendar] dateByAddingDays:1 toDate:workingDate];
            cellIndex++;
        }
    }
    
    [self.wrapper bringSubviewToFront:self.headerView];
    
    /* Perform the animation */
    
    if (animated) {
        [UIView
         animateWithDuration:0.4
         animations:^{
             
             [self _moveCellsIntoView:cellsBeingAnimatedIntoView andCellsOutOfView:cellsToRemoveAfterAnimation usingOffset:yOffset];
             
         }
         completion:^(BOOL finished) {
             
             [self _cleanupCells:cellsToRemoveAfterAnimation];
             [cellsBeingAnimatedIntoView removeAllObjects];
             [self setIsAnimating:NO];
         }];
    }
    else
    {
        [self _moveCellsIntoView:cellsBeingAnimatedIntoView andCellsOutOfView:cellsToRemoveAfterAnimation usingOffset:yOffset];
        [self _cleanupCells:cellsToRemoveAfterAnimation];
        [cellsBeingAnimatedIntoView removeAllObjects];
        [self setIsAnimating:NO];
    }
    
    
}

#pragma mark - Cell Animation

- (void)_moveCellsIntoView:(NSMutableArray <CKCalendarCell *> *)cellsBeingAnimatedIntoView andCellsOutOfView:(NSMutableArray <CKCalendarCell *> *)cellsToRemoveAfterAnimation usingOffset:(CGFloat)yOffset
{
    for (CKCalendarCell *cell in cellsBeingAnimatedIntoView) {
        cell.topConstraint.constant = cell.topConstraint.constant - yOffset;
    }
    
    for (CKCalendarCell *cell in cellsToRemoveAfterAnimation) {
        cell.topConstraint.constant = cell.topConstraint.constant - yOffset;
    }
    
    [self layoutIfNeeded];
}

- (void)_cleanupCells:(NSMutableArray <CKCalendarCell *> *)cellsToCleanup
{
    for (CKCalendarCell *cell in cellsToCleanup) {
        [self _moveCellFromUsedToSpare:cell];
        
        [self.wrapper removeConstraints:cell.constraints];
        
        [cell removeFromSuperview];
    }
    
    [cellsToCleanup removeAllObjects];
}

#pragma mark - Cell Recycling

- (CKCalendarCell *)_dequeueCell
{
    CKCalendarCell *cell = [[self spareCells] firstObject];
    
    if (!cell) {
        cell = [[CKCalendarCell alloc] initWithSize:[self _cellSize]];
        cell.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *ratio = [NSLayoutConstraint constraintWithItem:cell
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:cell
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:0.0];
        [cell addConstraint:ratio];
    }
    
    [self _moveCellFromSpareToUsed:cell];
    
    [cell prepareForReuse];
    
    return cell;
}

- (void)_moveCellFromSpareToUsed:(CKCalendarCell *)cell
{
    //  Move the used cells to the appropriate set
    [[self usedCells] addObject:cell];
    
    if ([[self spareCells] containsObject:cell]) {
        [[self spareCells] removeObject:cell];
    }
}

- (void)_moveCellFromUsedToSpare:(CKCalendarCell *)cell
{
    //  Move the used cells to the appropriate set
    [[self spareCells] addObject:cell];
    
    if ([[self usedCells] containsObject:cell]) {
        [[self usedCells] removeObject:cell];
    }
}


#pragma mark - Setters

- (void)setCalendar:(NSCalendar *)calendar
{
    [self setCalendar:calendar animated:NO];
}

- (void)setCalendar:(NSCalendar *)calendar animated:(BOOL)animated
{
    if (calendar == nil) {
        calendar = [NSCalendar currentCalendar];
    }
    
    _calendar = calendar;
    [_calendar setLocale:_locale];
    [_calendar setFirstWeekday:_firstWeekDay];
    
    [self layoutSubviews];
}

- (void)setLocale:(NSLocale *)locale
{
    [self setLocale:locale animated:NO];
}

- (void)setLocale:(NSLocale *)locale animated:(BOOL)animated
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
    [self setTimeZone:timeZone animated:NO];
}

- (void)setTimeZone:(NSTimeZone *)timeZone animated:(BOOL)animated
{
    if (!timeZone) {
        timeZone = [NSTimeZone localTimeZone];
    }
    
    [[self calendar] setTimeZone:timeZone];
    
    [self updateConstraintsAnimated:animated];
}

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode
{
    [self setDisplayMode:displayMode animated:NO];
}

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode animated:(BOOL)animated
{
    _displayMode = displayMode;
    _previousDate = _date;
    
    //  Update the index, so that we don't lose selection between mode changes
    NSInteger newIndex = [[self calendar] daysFromDate:[self _firstVisibleDateForDisplayMode:displayMode] toDate:[self date]];
    [self setSelectedIndex:newIndex];
    
    [self updateConstraintsAnimated:animated];
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
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    date = [self.calendar dateFromComponents:components];
    
    BOOL minimumIsBeforeMaximum = [self _minimumDateIsBeforeMaximumDate];
    
    if (minimumIsBeforeMaximum) {
        
        if ([self _dateIsBeforeMinimumDate:date]) {
            date = [self minimumDate];
        }
        else if([self _dateIsAfterMaximumDate:date])
        {
            date = [self maximumDate];
        }
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
        [[self delegate] calendarView:self willSelectDate:date];
    }
    
    _previousDate = _date;
    _date = date;
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:self didSelectDate:date];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        [self setEvents:[[self dataSource] calendarView:self eventsForDate:date]];
        [[self table] reloadData];
    }
    
    //  Update the index
    NSDate *newFirstVisible = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSUInteger index = [[self calendar] daysFromDate:newFirstVisible toDate:date];
    [self setSelectedIndex:index];
    
    [self updateConstraintsAnimated:animated];
    
}


- (void)setMinimumDate:(NSDate *)minimumDate
{
    [self setMinimumDate:minimumDate animated:NO];
}

- (void)setMinimumDate:(NSDate *)minimumDate animated:(BOOL)animated
{
    _minimumDate = minimumDate;
    [self setDate:[self date] animated:animated];
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    [self setMaximumDate:[self date] animated:NO];
}

- (void)setMaximumDate:(NSDate *)maximumDate animated:(BOOL)animated
{
    _maximumDate = maximumDate;
    [self setDate:[self date] animated:animated];
}

- (void)setDataSource:(id<CKCalendarViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self reloadAnimated:NO];
}

#pragma mark - CKCalendarHeaderViewDataSource

- (NSString *)titleForHeader:(CKCalendarHeaderView *)header
{
    CKCalendarDisplayMode mode = [self displayMode];
    
    if(mode == CKCalendarViewModeMonth)
    {
        return [[self date] monthAndYearOnCalendar:[self calendar]];
    }
    
    else if (mode == CKCalendarViewModeWeek)
    {
        NSDate *firstVisibleDay = [self _firstVisibleDateForDisplayMode:mode];
        NSDate *lastVisibleDay = [self _lastVisibleDateForDisplayMode:mode];
        
        NSMutableString *result = [NSMutableString new];
        
        [result appendString:[firstVisibleDay monthAndYearOnCalendar:[self calendar]]];
        
        //  Show the day and year
        if (![[self calendar] date:firstVisibleDay isSameMonthAs:lastVisibleDay]) {
            result = [[firstVisibleDay monthAbbreviationAndYearOnCalendar:[self calendar]] mutableCopy];
            [result appendString:@" - "];
            [result appendString:[lastVisibleDay monthAbbreviationAndYearOnCalendar:[self calendar]]];
        }
        
        
        return result;
    }
    
    //Otherwise, return today's date as a string
    return [[self date] monthAndDayAndYearOnCalendar:[self calendar]];
}

- (NSUInteger)numberOfColumnsForHeader:(CKCalendarHeaderView *)header
{
    return [self _columnCountForDisplayMode:[self displayMode]];
}

- (NSString *)header:(CKCalendarHeaderView *)header titleForColumnAtIndex:(NSInteger)index
{
    NSDate *firstDate = [self _firstVisibleDateForDisplayMode:[self displayMode]];
    NSDate *columnToShow = [[self calendar] dateByAddingDays:index toDate:firstDate];
    
    return [columnToShow dayNameOnCalendar:[self calendar]];
}


- (BOOL)headerShouldHighlightTitle:(CKCalendarHeaderView *)header
{
    CKCalendarDisplayMode mode = [self displayMode];
    
    if (mode == CKCalendarViewModeDay) {
        return [[self calendar] date:[NSDate date] isSameDayAs:[self date]];
    }
    
    return NO;
}

- (BOOL)headerShouldDisableBackwardButton:(CKCalendarHeaderView *)header
{
    
    //  Never disable if there's no minimum date
    if (![self minimumDate]) {
        return NO;
    }
    
    CKCalendarDisplayMode mode = [self displayMode];
    
    if (mode == CKCalendarViewModeMonth)
    {
        return [[self calendar] date:[self date] isSameMonthAs:[self minimumDate]];
    }
    else if(mode == CKCalendarViewModeWeek)
    {
        return [[self calendar] date:[self date] isSameWeekAs:[self minimumDate]];
    }
    
    return [[self calendar] date:[self date] isSameDayAs:[self minimumDate]];
}

- (BOOL)headerShouldDisableForwardButton:(CKCalendarHeaderView *)header
{
    
    //  Never disable if there's no minimum date
    if (![self maximumDate]) {
        return NO;
    }
    
    CKCalendarDisplayMode mode = [self displayMode];
    
    if (mode == CKCalendarViewModeMonth)
    {
        return [[self calendar] date:[self date] isSameMonthAs:[self maximumDate]];
    }
    else if(mode == CKCalendarViewModeWeek)
    {
        return [[self calendar] date:[self date] isSameWeekAs:[self maximumDate]];
    }
    
    return [[self calendar] date:[self date] isSameDayAs:[self maximumDate]];
}

#pragma mark - CKCalendarHeaderViewDelegate

- (void)forwardTapped
{
    NSDate *date = [self date];
    NSDate *today = [NSDate date];
    
    /* If the cells are animating, don't do anything or we'll break the view */
    
    if ([self isAnimating]) {
        return;
    }
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    
    if ([self displayMode] == CKCalendarViewModeMonth) {
        
        NSUInteger maxDays = [[self calendar] daysPerMonthUsingReferenceDate:date];
        NSUInteger todayInMonth =[[self calendar] daysInDate:date];
        
        //  If we're the last day of the month, just roll over a day
        if (maxDays == todayInMonth) {
            date = [[self calendar] dateByAddingDays:1 toDate:date];
        }
        
        //  Otherwise, add a month and then go to the first of the month
        else{
            date = [[self calendar] dateByAddingMonths:1 toDate:date];              //  Add a month
            NSUInteger day = [[self calendar] daysInDate:date];                     //  Only then go to the first of the next month.
            date = [[self calendar] dateBySubtractingDays:day-1 fromDate:date];
        }
        
        //  If today is in the visible month, jump to today
        if([[self calendar] date:date isSameMonthAs:[NSDate date]]){
            NSUInteger distance = [[self calendar] daysFromDate:date toDate:today];
            date = [[self calendar] dateByAddingDays:distance toDate:date];
        }
    }
    
    /*
     
     For week mode, we move ahead by a week, then jump to
     the first day of the week. If the newly visible week
     contains today, we set today as the active date.
     
     */
    
    else if([self displayMode] == CKCalendarViewModeWeek)
    {
        
        date = [[self calendar] dateByAddingWeeks:1 toDate:date];                   //  Add a week
        
        NSUInteger dayOfWeek = [[self calendar] weekdayInDate:date];
        date = [[self calendar] dateBySubtractingDays:dayOfWeek-self.calendar.firstWeekday fromDate:date];   //  Jump to sunday
        
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
    
    /* If the cells are animating, don't do anything or we'll break the view */
    
    if ([self isAnimating]) {
        return;
    }
    
    /*
     
     Moving forward or backwards for month mode
     should select the first day of the month,
     unless the newly visible month contains
     [NSDate date], in which case we want to
     highlight that day instead.
     
     */
    
    if ([self displayMode] == CKCalendarViewModeMonth) {
        
        date = [[self calendar] dateBySubtractingMonths:1 fromDate:date];       //  Subtract a month
        NSUInteger day = [[self calendar] daysInDate:date];
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
    
    else if([self displayMode] == CKCalendarViewModeWeek)
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

- (NSUInteger)_rowCountForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    if (displayMode == CKCalendarViewModeWeek) {
        return 1;
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        return [[self calendar] weeksPerMonthUsingReferenceDate:[self date]];
    }
    
    return 0;
}

- (NSUInteger)_columnCountForDisplayMode:(NSUInteger)displayMode
{
    if (displayMode == CKCalendarViewModeDay) {
        return 0;
    }
    
    return [[self calendar] daysPerWeekUsingReferenceDate:[self date]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [[self events] count];
    
    if (count == 0) {
        count = 2;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger count = [[self events] count];
    
    if (count == 0) {
        UITableViewCell *cell = [[self table] dequeueReusableCellWithIdentifier:@"noDataCell"];
        [[cell textLabel] setTextAlignment:NSTextAlignmentCenter];
        [[cell textLabel] setTextColor:[UIColor colorWithWhite:0.2 alpha:0.8]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([indexPath row] == 1) {
            [[cell textLabel] setText:NSLocalizedString(@"No Events", @"A label for a table with no events.")];
        }
        else
        {
            [[cell textLabel] setText:@""];
        }
        return cell;
    }
    
    CKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CKCalendarEvent *event = [[self events] objectAtIndex:[indexPath row]];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    [[cell textLabel] setText:[event title]];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(3, 6, 20, 20)];
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [[event color] CGColor];
    layer.frame = colorView.frame;
    [colorView.layer insertSublayer:layer atIndex:0];
    
    if(nil != event.image)
    {
        cell.imageView.image = [UIImage imageWithData:event.image];
    }
    else {
        cell.imageView.image = nil;
    }
    
    [cell addSubview:colorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[self events] count] == 0) {
        return;
    }
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [[self delegate] calendarView:self didSelectEvent:[self events][[indexPath row]]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - First Weekday

- (void)setFirstWeekDay:(NSUInteger)firstWeekDay
{
    
    _firstWeekDay = firstWeekDay;
    self.calendar.firstWeekday = firstWeekDay;
    
    [self reload];
}

- (NSUInteger)firstWeekDay
{
    return _firstWeekDay;
}

#pragma mark - Date Calculations

- (NSDate *)firstVisibleDate
{
    return [self _firstVisibleDateForDisplayMode:[self displayMode]];
}

- (NSDate *)_firstVisibleDateForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    // for the day mode, just return today
    if (displayMode == CKCalendarViewModeDay) {
        return [self date];
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        return [[self calendar] firstDayOfTheWeekUsingReferenceDate:[self date] andStartDay:self.calendar.firstWeekday];
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        NSDate *firstOfTheMonth = [[self calendar] firstDayOfTheMonthUsingReferenceDate:[self date]];
        
        NSDate *firstVisible = [[self calendar] firstDayOfTheWeekUsingReferenceDate:firstOfTheMonth andStartDay:self.calendar.firstWeekday];
        
        return firstVisible;
    }
    
    return [self date];
}

- (NSDate *)lastVisibleDate
{
    return [self _lastVisibleDateForDisplayMode:[self displayMode]];
}

- (NSDate *)_lastVisibleDateForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    // for the day mode, just return today
    if (displayMode == CKCalendarViewModeDay) {
        return [self date];
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        return [[self calendar] lastDayOfTheWeekUsingReferenceDate:[self date]];
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        NSDate *lastOfTheMonth = [[self calendar] lastDayOfTheMonthUsingReferenceDate:[self date]];
        return [[self calendar] lastDayOfTheWeekUsingReferenceDate:lastOfTheMonth];
    }
    
    return [self date];
}

- (NSUInteger)_numberOfVisibleDaysforDisplayMode:(CKCalendarDisplayMode)displayMode
{
    //  If we're showing one day, well, we only one
    if (displayMode == CKCalendarViewModeDay) {
        return 1;
    }
    
    //  If we're showing a week, count the days per week
    else if (displayMode == CKCalendarViewModeWeek)
    {
        return [[self calendar] daysPerWeek];
    }
    
    //  If we're showing a month, we need to account for the
    //  days that complete the first and last week of the month
    else if (displayMode == CKCalendarViewModeMonth)
    {
        
        NSDate *firstVisible = [self _firstVisibleDateForDisplayMode:CKCalendarViewModeMonth];
        NSDate *lastVisible = [self _lastVisibleDateForDisplayMode:CKCalendarViewModeMonth];
        return [[self calendar] daysFromDate:firstVisible toDate:lastVisible];
    }
    
    //  Default to 1;
    return 1;
}

#pragma mark - Minimum and Maximum Dates

- (BOOL)_minimumDateIsBeforeMaximumDate
{
    //  If either isn't set, return YES
    if (![self _hasNonNilMinimumAndMaximumDates]) {
        return YES;
    }
    
    return [[self calendar] date:[self minimumDate] isBeforeDate:[self maximumDate]];
}

- (BOOL)_hasNonNilMinimumAndMaximumDates
{
    return [self minimumDate] != nil && [self maximumDate] != nil;
}

- (BOOL)_dateIsBeforeMinimumDate:(NSDate *)date
{
    return [[self calendar] date:date isBeforeDate:[self minimumDate]];
}

- (BOOL)_dateIsAfterMaximumDate:(NSDate *)date
{
    return [[self calendar] date:date isAfterDate:[self maximumDate]];
}

- (BOOL)_dateIsBetweenMinimumAndMaximumDates:(NSDate *)date
{
    //  If there are both the minimum and maximum dates are unset,
    //  behave as if all dates are in range.
    if (![self minimumDate] && ![self maximumDate]) {
        return YES;
    }
    
    //  If there's no minimum, treat all dates that are before
    //  the maximum as valid
    else if(![self minimumDate])
    {
        return [[self calendar]date:date isBeforeDate:[self maximumDate]];
    }
    
    //  If there's no maximum, treat all dates that are before
    //  the minimum as valid
    else if(![self maximumDate])
    {
        return [[self calendar] date:date isAfterDate:[self minimumDate]];
    }
    
    return [[self calendar] date:date isAfterDate:[self minimumDate]] && [[self calendar] date:date isBeforeDate:[self maximumDate]];
}

#pragma mark - Dates & Indices

- (NSInteger)_indexFromDate:(NSDate *)date
{
    NSDate *firstVisible = [self firstVisibleDate];
    return [[self calendar] daysFromDate:firstVisible toDate:date];
}

- (NSDate *)_dateFromIndex:(NSInteger)index
{
    NSDate *firstVisible = [self firstVisibleDate];
    return [[self calendar] dateByAddingDays:index toDate:firstVisible];
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
    
    if(CGRectContainsPoint([self _rectForCellsForDisplayMode:_displayMode], point)){
        /* Highlight and select the appropriate cell */
        
        NSUInteger index = [self selectedIndex];
        
        //  Get the index from the cell we're in
        for (CKCalendarCell *cell in [self usedCells]) {
            CGRect rect = [cell frame];
            if (CGRectContainsPoint(rect, point)) {
                index = [cell index];
                break;
            }
            
        }
        
        //  Clip the index to minimum and maximum dates
        NSDate *date = [self _dateFromIndex:index];
        
        if ([self _dateIsAfterMaximumDate:date]) {
            index = [self _indexFromDate:[self maximumDate]];
        }
        else if([self _dateIsBeforeMinimumDate:date])
        {
            index = [self _indexFromDate:[self minimumDate]];
        }
        
        // Save the new index
        [self setSelectedIndex:index];
        
        //  Update the cell highlighting
        for (CKCalendarCell *cell in [self usedCells]) {
            if ([cell index] == [self selectedIndex]) {
                [cell setSelected];
            }
            else
            {
                [cell setDeselected];
            }
            
        }
    }
    
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
    
    NSDate *dateToSelect = [[self calendar] dateByAddingDays:[self selectedIndex] toDate:firstDate];
    [self setDate:dateToSelect animated:NO];
}

@end
