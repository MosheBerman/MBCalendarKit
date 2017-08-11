//
//  CKCalendarView.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import QuartzCore;

#import "CKCalendarView.h"

#import "CKCalendarModel.h"
#import "CKCalendarModel+GridViewSupport.h"
#import "CKCalendarModel+HeaderViewSupport.h"

#import "CKCalendarAnimationWrapperView.h"
#import "CKCalendarGridView.h"

#import "CKCalendarHeaderView.h"
#import "CKCalendarHeaderViewDelegate.h"
#import "CKCalendarHeaderViewDataSource.h"

#import "CKCalendarCell.h"
#import "CKTableViewCell.h"

#import "NSCalendarCategories.h"
#import "NSDate+Description.h"
#import "UIView+AnimatedFrame.h"

@interface CKCalendarView () <UITableViewDataSource, UITableViewDelegate> {
    NSUInteger _firstWeekDay;
}

// MARK: - Internal Views

/**
 The header view which shows the month and weekday names.
 */
@property (nonatomic, strong) CKCalendarHeaderView *headerView;

/**
 A collection view to drive the display of the calendar.
 */
@property (nonatomic, strong) CKCalendarGridView *gridView;

/**
 A wrapper that clips the cells and header so that cells animating in or out don't overflow the calendar view.
 */
@property (nonatomic, strong) CKCalendarAnimationWrapperView *wrapper;

/**
 A table view to show event details in.
 */
@property (nonatomic, strong) UITableView *table;

// MARK: - Calendar State

/**
 A cache for events that are being displayed.
 */
@property (nonatomic, strong) NSArray *events;

/**
 Are the cells animating? Used to prevent animation races.
 */
@property (nonatomic, assign) BOOL isAnimating;

/**
 *  A model, encapsulating the state of a calendar.
 */
@property (nonatomic, strong) CKCalendarModel *calendarModel;

@end

@implementation CKCalendarView

// MARK: - Initializers

/**
 Initializes the calendar with a display mode.

 @param CalendarDisplayMode How much content to display: a month, a week, or a day?
 @return An instance of CKCalendarView.
 */
- (instancetype)initWithMode:(CKCalendarViewMode)mode
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _displayMode = mode;
        [self commonInitializer];
    }
    return self;
}


/**
 Calls `initWithMode:` with a mode of CKCalendarViewModeMonth.

 @param frame The frame. Doesn't matter because we drop this.
 @return An instance of CKCalendarView.
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithMode:CKCalendarViewModeMonth];
    if (self)
    {
        
    }
    return self;
}

/**
 Calls `initWithMode:` with a mode of CKCalendarViewModeMonth.
 
 @param coder An NSCoder. Doesn't matter because we drop this.
 @return An instance of CKCalendarView.
 */

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self initWithMode:CKCalendarViewModeMonth];
    if (self) {
        
    }
    return self;
}

// MARK: - Common Initializer

/**
 This is code that gets run from every initializer.
 */
- (void)commonInitializer
{
    _calendarModel = [[CKCalendarModel alloc] init];
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
    _wrapper = [CKCalendarAnimationWrapperView new];
    _wrapper.clipsToBounds = YES;
    _isAnimating = NO;
    
    [self _installHeader];
    [self _installGridView];
    [self _installWrapper];
    [self _installShadow];
    
}

// MARK: - View Lifecycle

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self _installTable];
    [self reloadAnimated:NO];
    
    [super didMoveToSuperview];
}

- (void)awakeFromNib
{
    
#if TARGET_INTERFACE_BUILDER
    [self invalidateIntrinsicContentSize];
    [self.superview setNeedsLayout];
#else 
    [self reloadAnimated:NO];
#endif
    
    [super awakeFromNib];
}

- (void)removeFromSuperview
{
    self.headerView.delegate = nil;
    self.headerView.dataSource = nil;
    
    [self.superview removeConstraints:self.table.constraints];
    [self.table removeFromSuperview];
    
    [super removeFromSuperview];
}

- (void)prepareForInterfaceBuilder
{
    [super prepareForInterfaceBuilder];
    
    [self reloadAnimated:NO];
}

// MARK: - Reload

- (void)reload
{
    [self reloadAnimated:NO];
}

- (void)reloadAnimated:(BOOL)animated
{
    /**
     *  Sort & cache the events for the current date.
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
     *  TODO: Possibly add a delegate method here, per issue #20.
     */
    
    /**
     *  Reload the calendar view.
     */
    
    [self _layoutCellsAnimated:animated];
    [self.headerView reloadData];
    [self.table reloadData];
}

// MARK: - Size

- (CGFloat)_heightForDisplayMode:(CKCalendarDisplayMode)displayMode
{
    
    
    CGFloat headerHeight = self.headerView.intrinsicContentSize.height;
    
    CGFloat height = headerHeight;
    
    CGFloat columnCount = (CGFloat)self.calendarModel.numberOfColumns;
    CGFloat rowCount = (CGFloat)self.calendarModel.numberOfRows;
    
    if (columnCount > 0) /* Month and Week Mode */
    {
        CGFloat width = CGRectGetWidth(self.superview.bounds);
        CGFloat widthAdjustForEvenDivisionByDaysPerWeek = width - (CGFloat)((NSInteger)width % (NSInteger)columnCount);
        CGFloat cellSideLength = columnCount > 0 ? widthAdjustForEvenDivisionByDaysPerWeek / columnCount : 0.0;
        
        height = headerHeight + (cellSideLength * rowCount);
    }
    
    return height;
}


// MARK: - Layout

- (void)updateConstraints
{
    [self _layoutCellsAnimated:NO];
    [super updateConstraints];
}

- (CGSize)intrinsicContentSize
{
    CGFloat width = UIViewNoIntrinsicMetric;
    
    if(self.superview)
    {
        width = CGRectGetWidth(self.superview.bounds);
        NSInteger daysPerWeek = self.calendarModel.numberOfColumns;
        
        /* Adjust width for more perfect divisibility. */
        CGFloat widthAdjustedForDivisibilityByDaysPerWeek = width - (CGFloat)((NSInteger)width % daysPerWeek);
        
        width = widthAdjustedForDivisibilityByDaysPerWeek;
    }
    
    CGFloat height = [self _heightForDisplayMode:self.displayMode];
    
    return CGSizeMake(width, height);
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (UILayoutPriority)contentCompressionResistancePriorityForAxis:(UILayoutConstraintAxis)axis
{
    return UILayoutPriorityRequired;
}

- (UILayoutPriority)contentHuggingPriorityForAxis:(UILayoutConstraintAxis)axis
{
    if (axis == UILayoutConstraintAxisHorizontal)
    {
        return UILayoutPriorityDefaultLow;
    }
    else
    {
        return UILayoutPriorityRequired;
    }
}

// MARK: - Installing Internal Views

- (void)_installTable
{
    if (!self.superview)
    {
        return;
    }
    
    if (![self.table isDescendantOfView:self.superview])
    {
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
}

- (void)_installWrapper
{
    if(![self.wrapper isDescendantOfView:self])
    {
        [self addSubview:self.wrapper];
        self.wrapper.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:0.0];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0];
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.wrapper
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        
        [self addConstraints:@[trailing, top, bottom, leading]];
    }
}

- (void)_installGridView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _gridView = [[CKCalendarGridView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.gridView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    __weak CKCalendarView *weakSelf = self;
    
    self.gridView.cellConfigurationBlock = ^(UICollectionViewCell * _Nonnull cell, NSDate * _Nonnull date) {
      
        BOOL cellRepresentsToday = [[weakSelf calendar] date:date isSameDayAs:[NSDate date]];
        BOOL isThisMonth = [[weakSelf calendar] date:date isSameMonthAs:[weakSelf date]];
        BOOL isInRange = [weakSelf _dateIsBetweenMinimumAndMaximumDates:date];
        isInRange = isInRange || [[weakSelf calendar] date:date isSameDayAs:[self minimumDate]];
        isInRange = isInRange || [[weakSelf calendar] date:date isSameDayAs:[self maximumDate]];
        
        CKCalendarCell *calendarCell = (CKCalendarCell *)cell;
        
        if (cellRepresentsToday && isThisMonth && isInRange)
        {
            calendarCell.state = CKCalendarMonthCellStateTodayDeselected;
        }
        else if(!isInRange)
        {
            [calendarCell setOutOfRange];
        }
        else if (!isThisMonth) {
            calendarCell.state = CKCalendarMonthCellStateInactive;
        }
        else
        {
            calendarCell.state = CKCalendarMonthCellStateNormal;
        }
        
        /* */
        
//        if([weakSelf.gridView.calendar date:weakSelf.gridView.date isSameDayAs:date])
//        {
//            [calendarCell setSelected];
//        }
        
        /* Show the day of the month in the cell. */
        
        NSUInteger day = [weakSelf.calendar daysInDate:date];
        calendarCell.number = @(day);
        
        if([weakSelf.dataSource respondsToSelector:@selector(calendarView:eventsForDate:)])
        {
            BOOL showDot = ([[weakSelf.dataSource calendarView:self eventsForDate:date] count] > 0);
            calendarCell.showDot = showDot;
        }
        else
        {
            calendarCell.showDot = NO;
        }
    };
    
    if(![self.wrapper.subviews containsObject:self.gridView])
    {
        self.gridView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.wrapper addSubview:self.gridView];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.gridView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.headerView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:0.0];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.gridView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.wrapper
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:0.0];
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.gridView
                                                                   attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.wrapper
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:0.0];
        
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.gridView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.wrapper
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        
        [NSLayoutConstraint activateConstraints:@[trailing, top, bottom, leading]];

    }
}

- (void)_installHeader
{
    CKCalendarHeaderView *header = self.headerView;
    header.translatesAutoresizingMaskIntoConstraints = NO;
    header.delegate = self.calendarModel;
    header.dataSource = self.calendarModel;
    
    if (![self.headerView isDescendantOfView:self.wrapper])
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

- (void)_installShadow
{
    [self.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [self.layer setShadowOffset:CGSizeMake(0, 3)];
    [self.layer setShadowOpacity:1.0];
}

// MARK: - Observe Calendar Size Changes

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([self.gridView isEqual:object] && [keyPath isEqualToString:@"contentSize"])
    {
        [self _layoutCellsAnimated:YES];
    }
}

// MARK: - Lay Out Cells


- (void)_layoutCellsAnimated:(BOOL)animated
{
    NSInteger duration = animated ? 0.3 : 0.0;
    
    [self.superview setNeedsLayout];
    [UIView animateWithDuration:duration animations:^{
        [self invalidateIntrinsicContentSize];
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }];
}


// MARK: - Setters

// TODO: Consider observing the `NSCalendar` instance to catch these changes for animation instead of overriding all these methods.

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
    
    [self reloadAnimated:animated];
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
    
    [self reloadAnimated:animated];
}

- (NSTimeZone *)timeZone
{
    return self.calendar.timeZone;
}

- (void)setTimeZone:(NSTimeZone *)timeZone
{
    [self setTimeZone:timeZone animated:NO];
}

- (void)setTimeZone:(NSTimeZone *)timeZone animated:(BOOL)animated
{
    if (!timeZone)
    {
        timeZone = [NSTimeZone defaultTimeZone];
    }
    
    [[self calendar] setTimeZone:timeZone];
    
    [self reloadAnimated:animated];
}

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode
{
    [self setDisplayMode:displayMode animated:NO];
}

- (void)setDisplayMode:(CKCalendarDisplayMode)displayMode animated:(BOOL)animated
{
    _displayMode = displayMode;
    
    [self reloadAnimated:animated];
}

- (NSDate *)date
{
    return self.calendarModel.date;
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

    
    // TODO: Update previous date here, and set next date.
    
    self.calendarModel.date = date;
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:self didSelectDate:date];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        [self setEvents:[[self dataSource] calendarView:self eventsForDate:date]];
        [[self table] reloadData];
    }
    
    [self reloadAnimated:animated];
}


// MARK: - Minimum Date

// MARK: - Clamping the Minimum Date

/**
 When set, this prevents dates prior to itself from being selected in the calendar or set programmatically.
 By default, this is `nil`.
 */
- (nullable NSDate *)minimumDate;
{
    return self.calendarModel.minimumDate;
}

- (void)setMinimumDate:(NSDate *)minimumDate
{
    [self setMinimumDate:minimumDate animated:NO];
}

- (void)setMinimumDate:(NSDate *)minimumDate animated:(BOOL)animated
{
    self.calendarModel.minimumDate = minimumDate;
}

// MARK: - Maximum Date

/**
 When set, this prevents dates later to itself from being selected in the calendar or set programmatically.
 By default, this is `nil`.
 */
- (nullable NSDate *)maximumDate;
{
    return self.calendarModel.maximumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate
{
    [self setMaximumDate:maximumDate animated:NO];
}

- (void)setMaximumDate:(NSDate *)maximumDate animated:(BOOL)animated
{
    self.calendarModel.maximumDate = maximumDate;
}

// MARK: - Calendar Data Source

- (void)setDataSource:(id<CKCalendarViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self reloadAnimated:NO];
}

// MARK: - UITableViewDataSource

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

// MARK: - First Weekday

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

// MARK: - Minimum and Maximum Dates

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

@end
