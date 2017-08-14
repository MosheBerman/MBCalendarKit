//
//  CKCalendarView.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import QuartzCore;

#import "CKCalendarView.h"

#import "CKCalendarAnimationWrapperView.h"

#import "CKCalendarModel.h"
#import "CKCalendarModel+GridViewSupport.h"
#import "CKCalendarModel+GridViewAnimationSupport.h"
#import "CKCalendarModel+HeaderViewSupport.h"


#import "CKCalendarGridView.h"
#import "CKCalendarGridTransitionCollectionViewFlowLayout.h"

#import "CKCalendarHeaderView.h"
#import "CKCalendarHeaderViewDelegate.h"
#import "CKCalendarHeaderViewDataSource.h"

#import "CKCalendarCell.h"
#import "CKCalendarCellColors.h"

#import "CKTableViewCell.h"

#import "NSCalendarCategories.h"
#import "NSDate+Description.h"

@interface CKCalendarView () <UITableViewDataSource, UITableViewDelegate, CKCalendarGridViewDelegate, CKCalendarModelObserver> {
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
 *  A weak reference to the grid layout to ease animating.
 */
@property (nonatomic, weak, nullable) CKCalendarGridTransitionCollectionViewFlowLayout *layout;

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

/**
 This date is set at the beginning of a scrub operation, and used to reset the model in the event of a cancelled scrub.
 It may be `nil`, or stale.
 */
@property (nonatomic, strong, nullable) NSDate *temporaryDate;

@end

@implementation CKCalendarView

// MARK: - Initializers

/**
 Initializes the calendar with a display mode.

 @param CalendarDisplayMode How much content to display: a month, a week, or a day?
 @return An instance of CKCalendarView.
 */
- (instancetype)initWithMode:(CKCalendarViewDisplayMode)mode
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

    
    CKCalendarGridTransitionCollectionViewFlowLayout *layout = [[CKCalendarGridTransitionCollectionViewFlowLayout alloc] init];
    _layout = layout;
    
    _gridView = [[CKCalendarGridView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _gridView.userInteractionEnabled = NO;
    
    
    //  Accessory Table
    _table = [UITableView new];
    _table.delegate = self;
    _table.dataSource = self;
    
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"noDataCell"];
    
    //  Events for selected date
    _events = [NSMutableArray new];
    
    //  Used for animation
    _wrapper = [CKCalendarAnimationWrapperView new];
    _wrapper.clipsToBounds = YES;
    _isAnimating = NO;
    
    _calendarModel.observer = self;
    
    [self _installHeader];
    [self _installGridView];
    [self _installWrapper];
    [self reload];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
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
    [self reloadAnimated:animated transitioningFromDate:self.date toDate:self.date];
}

- (void)reloadAnimated:(BOOL)animated transitioningFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    /**
     *  Sort & cache the events for the current date.
     */
    
    if ([self.dataSource respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        NSArray *sortedArray = [[self.dataSource calendarView:self eventsForDate:self.date] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *d1 = [obj1 date];
            NSDate *d2 = [obj2 date];
            
            return [d1 compare:d2];
        }];
        
        self.events = sortedArray;
    }
    
    /**
     *  TODO: Possibly add a delegate method here, per issue #20.
     */
    
    /**
     *  Reload the calendar view.
     */
    
    [self _layoutCellsAnimated:animated transitioningFrom:fromDate toDate:toDate];
    [self.headerView reloadData];
    [self.wrapper bringSubviewToFront:self.headerView];
    [self.table reloadData];
}

// MARK: - Size

- (CGFloat)_heightForDisplayMode:(CKCalendarViewDisplayMode)mode
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

// MARK: - Calendar Scrubbing

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.temporaryDate = self.calendarModel.date;

    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UICollectionViewCell *cellFromTouch = [self cellFromTouches:touches];
    
    for (UICollectionViewCell *cell in self.gridView.visibleCells)
    {
        BOOL highlighted = [cell isEqual:cellFromTouch];
        [cell setHighlighted:highlighted];
    }
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    BOOL isInGrid = CGRectContainsPoint(self.gridView.frame, point);
    
    if(isInGrid)
    {
        NSDate *dateFromTouches = [self dateFromTouches:touches];
        UICollectionViewCell *cell = [self cellFromTouches:touches];
        
        cell.selected = YES;
        self.calendarModel.date = dateFromTouches;
    }
    else
    {
        [self restoreDateFromBeforeInteraction];
    }
    [super touchesEnded:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    BOOL touchIsInHeader = [self touch:touches.anyObject isInView:self.headerView];
    if(!touchIsInHeader)
    {
        [self restoreDateFromBeforeInteraction];
    }
    
    [super touchesCancelled:touches withEvent:event];
}

// MARK: - Cancelling Date Scrubbing

/**
 Handle cancellations of a scrub interaction.
 */
- (void)restoreDateFromBeforeInteraction
{
    if(self.temporaryDate)
    {
        self.calendarModel.date = self.temporaryDate;
        self.temporaryDate = nil;
    }
}

// MARK: - Hit Testing Touches

/**
 Determines if a touch is inside the bounds of another view.

 @param touch The touch to evaluate.
 @param view The view to evaluate against.
 @return The value of CGRectContainsPoint(view.frame, ...) returns for the location of the touch in `self`.
 */
- (BOOL)touch:(UITouch *)touch isInView:(UIView *)view
{
    CGPoint point = [touch locationInView:self];
    BOOL isInView = CGRectContainsPoint(view.frame, point);
    
    return isInView;
}

// MARK: - Correlating Touches with Cells and Dates

/**
 Finds the grid cell beneath the user's touch.

 @param touches The touches to use to find the cell.
 @return A cell beneath the finger.
 */
- (nullable UICollectionViewCell *)cellFromTouches:(NSSet<UITouch *> *)touches
{
    UITouch *touch = touches.anyObject;
    CGPoint locationInView = [touch locationInView:self.gridView];
    NSIndexPath *indexPath = [self.gridView indexPathForItemAtPoint:locationInView];
    UICollectionViewCell *cell = [self.gridView cellForItemAtIndexPath:indexPath];
    
    return cell;
}


/**
 Finds the date who's cell is beneath the user's touch.

 @param touches The touches to use to find the cell.
 @return A date, represented by the cell beneath the finger.
 */
- (nullable NSDate *)dateFromTouches:(NSSet<UITouch *> *)touches
{
    UITouch *touch = touches.anyObject;
    CGPoint locationInView = [touch locationInView:self.gridView];
    NSIndexPath *indexPath = [self.gridView indexPathForItemAtPoint:locationInView];
    NSDate *date = [self.calendarModel dateForIndexPath:indexPath];
    
    return date;
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
        self.wrapper.clipsToBounds = NO;
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
    self.gridView.gridDataSource = self.calendarModel;
    self.gridView.gridAppearanceDelegate = self;
    self.gridView.backgroundColor = kCalendarColorLightGray;
    
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

// MARK: - Observe Model Changes

- (void)calendarModel:(CKCalendarModel *)model willChangeFromDate:(NSDate *)fromDate toNewDate:(NSDate *)toDate
{
    if ([[self delegate] respondsToSelector:@selector(calendarView:willSelectDate:)]) {
        [[self delegate] calendarView:self willSelectDate:toDate];
    }
}

- (void)calendarModel:(CKCalendarModel *)model didChangeFromDate:(NSDate *)fromDate toNewDate:(NSDate *)toDate
{
    
    // TODO: Cache a `wantsAnimation` on `self` before using one of the animated setters.
    [self reloadAnimated:YES transitioningFromDate:fromDate toDate:toDate];
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:self didSelectDate:toDate];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        [self setEvents:[[self dataSource] calendarView:self eventsForDate:toDate]];
        [[self table] reloadData];
    }
}

/**
 Called after the calendar model updates its `displayMode`, `calendar` or `locale` properties.
 
 @param model The model that did change.
 */
- (void)calendarModelDidInvalidate:(CKCalendarModel *)model;
{
    [self _adjustToFitCells:YES];
}

// MARK: - Lay Out Cells


/**
 Reloads the cells, taking into account the change in dates.

 @param fromDate The date before reload.
 @param toDate The date after reload.
 */
- (void)_layoutCellsAnimated:(BOOL)animated transitioningFrom:(NSDate *)fromDate toDate:(NSDate *)toDate;
{
    // This property allows the model to check for animation based on display mode and avoid animating
    // between dates within the same scope. (scope = month/week)
    BOOL modelSaysWeCanAnimate = [self.calendarModel shouldAnimateTransitionFromDate:fromDate toDate:toDate];
    
    if(animated && modelSaysWeCanAnimate)
    {
        NSInteger numberOfSectionsBefore = [self.calendarModel numberOfRowsForDate:fromDate];
        NSInteger numberOfSectionsAfter = [self.calendarModel numberOfRowsForDate:toDate];
        
        if ([self.calendarModel.calendar date:toDate isAfterDate:fromDate])
        {
            self.layout.transitionDirection = CKCalendarTransitionDirectionForward;
        }
        else
        {
            self.layout.transitionDirection = CKCalendarTransitionDirectionBackward;
        }
        
        self.layout.transitionAxis = self.calendarModel.transitionAxis;
        
        NSIndexSet *indexSetBefore = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfSectionsBefore)];
        NSIndexSet *indexSetAfter = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfSectionsAfter)];
        
        
        CKCalendarGridView *gridView = self.gridView;
        
        [gridView performBatchUpdates:^{
            
            if (numberOfSectionsBefore > 0)
            {
                [gridView deleteSections:indexSetBefore];
            }
            if (numberOfSectionsAfter > 0)
            {
                [gridView insertSections:indexSetAfter];
            }
            
        } completion:^(BOOL finished) {
            [self _adjustToFitCells:animated];
        }];
    }
    else
    {
        [self.gridView reloadData];
        [self _adjustToFitCells:NO];
    }
}


/**
 Invalidates the intrinsic content size to allow display of all cells.

 @param animated Should we animate the change.
 */
- (void)_adjustToFitCells:(BOOL)animated
{
    NSInteger duration = 0.0;
    
    if(animated)
    {
        duration = 0.3;
    }
    
    [self invalidateIntrinsicContentSize];
    [self.wrapper invalidateIntrinsicContentSize];
    
    [UIView animateWithDuration:duration animations:^{
        
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }];
}

// MARK: - CKCalendarGridDelegate

- (UICollectionViewCell *)calendarGrid:(CKCalendarGridView *)gridView willDisplayCell:(UICollectionViewCell *)cell forDate:(NSDate *)date
{
    BOOL cellRepresentsToday = [self.calendar date:date isSameDayAs:[NSDate date]];
    BOOL isThisMonth = [self.calendar date:date isSameMonthAs:self.date];
    BOOL isInRange = [self.calendarModel dateIsBetweenMinimumAndMaximumDates:date];
    isInRange = isInRange || [self.calendarModel.calendar date:date isSameDayAs:self.calendarModel.minimumDate];
    isInRange = isInRange || [self.calendarModel.calendar date:date isSameDayAs:self.calendarModel.maximumDate];
    
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
    
    /* - */
    
    if([self.calendarModel.calendar date:self.calendarModel.date isSameDayAs:date])
    {
        [calendarCell setSelected];
    }
    
    /* Show the day of the month in the cell. */
    
    NSUInteger day = [self.calendar daysInDate:date];
    calendarCell.number = @(day);
    
    if([self.dataSource respondsToSelector:@selector(calendarView:eventsForDate:)])
    {
        BOOL showDot = ([self.dataSource calendarView:self eventsForDate:date].count > 0);
        calendarCell.showDot = showDot;
    }
    else
    {
        calendarCell.showDot = NO;
    }
    
    return calendarCell;
}


// MARK: - Calendar

- (NSCalendar *)calendar
{
    return self.calendarModel.calendar;
}

// TODO: Consider observing the `NSCalendar` instance to catch these changes for animation instead of overriding all these methods.

- (void)setCalendar:(NSCalendar *)calendar
{
    [self setCalendar:calendar animated:NO];
}

- (void)setCalendar:(NSCalendar *)calendar animated:(BOOL)animated
{
    if (calendar == nil) {
        calendar = [NSCalendar autoupdatingCurrentCalendar];
    }
    
    NSLocale *locale = self.calendarModel.calendar.locale;
    NSUInteger firstWeekday = self.calendarModel.calendar.firstWeekday;
    
    self.calendarModel.calendar = calendar;
    self.calendarModel.calendar.locale = locale;
    self.calendarModel.calendar.firstWeekday = firstWeekday;
    
    [self reloadAnimated:animated];
}

// MARK: - Locale

- (void)setLocale:(NSLocale *)locale
{
    [self setLocale:locale animated:NO];
}

- (void)setLocale:(NSLocale *)locale animated:(BOOL)animated
{
    if (locale == nil) {
        locale = [NSLocale currentLocale];
    }
    
    self.calendarModel.calendar.locale = locale;
    
    [self reloadAnimated:animated];
}

// MARK: - Time Zone

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
    self.calendarModel.calendar.timeZone = timeZone;
    
    [self reloadAnimated:animated];
}

// MARK: - Display Mode

- (void)setDisplayMode:(CKCalendarViewDisplayMode)mode
{
    [self setDisplayMode:mode animated:NO];
}

- (void)setDisplayMode:(CKCalendarViewDisplayMode)mode animated:(BOOL)animated
{
    self.calendarModel.displayMode = mode;
    
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
    self.calendarModel.date = date;
}


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

// MARK: - First Weekday

- (void)setFirstWeekDay:(NSUInteger)firstWeekDay
{
    self.calendarModel.calendar.firstWeekday = firstWeekDay;
    
    [self reload];
}

- (NSUInteger)firstWeekDay
{
    return self.calendarModel.calendar.firstWeekday;
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
    NSInteger count = self.events.count;
    
    if (count == 0) {
        count = 2;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger count = self.events.count;
    
    if (count == 0) {
        UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:@"noDataCell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 1) {
            [cell.textLabel setText:NSLocalizedString(@"No Events", @"A label for a table with no events.")];
        }
        else
        {
            cell.textLabel.text = @"";
        }
        return cell;
    }
    
    CKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CKCalendarEvent *event = self.events[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = event.title;
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(3, 6, 20, 20)];
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = event.color.CGColor;
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
    
    if (self.events.count == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [self.delegate calendarView:self didSelectEvent:self.events[indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
