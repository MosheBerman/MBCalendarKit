//
//  CKCalendarView.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import QuartzCore;

#import "CKCalendarView.h"
#import "CKCalendarView+DefaultCellProviderImplementation.h"

#import "CKCalendarCellContext.h"

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

#import "NSCalendarCategories.h"
#import "NSDate+Description.h"

#import "CKCache.h"

@interface CKCalendarView () <CKCalendarGridViewDelegate, CKCalendarModelObserver> {
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

// MARK: - Calendar State

/**
 A cache for events that are being displayed.
 */
@property (nonatomic, strong) NSArray *events;

/**
 *  A model, encapsulating the state of a calendar.
 */
@property (nonatomic, strong, nonnull) CKCalendarModel *calendarModel;

// MARK: - Caching Highlight State for Scrubbing

/**
 This date is set at the beginning of a scrub operation, and used to reset the model in the event of a cancelled scrub.
 It may be `nil`, or stale.
 */
@property (nonatomic, strong, nullable) NSDate *temporaryDate;


/**
 Keep a reference to the most recently highlighted cell.
 */
@property (nonatomic, strong, nullable) UICollectionViewCell *mostRecentlyHighlightedCell;

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
    self = [self initWithMode:CKCalendarViewDisplayModeMonth];
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
    self = [self initWithMode:CKCalendarViewDisplayModeMonth];
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
    
    
    //  Events for selected date
    _events = [NSMutableArray new];
    
    _calendarModel.observer = self;
    
    self.customCellProvider = self;
    
    [self _installHeader];
    [self _installGridView];
    
    //    https://stackoverflow.com/a/45467694/224988
#if !TARGET_INTERFACE_BUILDER
    self.translatesAutoresizingMaskIntoConstraints = NO;
#endif
    
}

// MARK: - View Lifecycle

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self reload];
}

- (void)removeFromSuperview
{
    self.headerView.delegate = nil;
    self.headerView.dataSource = nil;
    
    [super removeFromSuperview];
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
    if(!self.window)
    {
        return;
    }
    
    /**
     *  TODO: Possibly add a delegate method here, per issue #20.
     */
    
    /**
     *  Reload the calendar view.
     */
    [self _adjustToFitCells:animated];
    [self _layoutCellsAnimated:animated transitioningFrom:fromDate toDate:toDate];
    [self.headerView reloadData];
}

// MARK: - Intrinsic Layout

/**
 Calculates the length of a side of a single cell.
 
 @return The size of a square cell, based on the superview, adjusting for divisibility by the number of columns.
 */
- (CGFloat)_lengthOfTheSideOfACell
{
    CGFloat sideOfACell = UIViewNoIntrinsicMetric;
    
    if (self.superview)
    {
        CGFloat parentBounds = CGRectGetWidth(self.superview.bounds);
        
        // We need this as a `CGFloat` for floating point division
        // This is very likely always 7.0
        CGFloat numberOfColumns = (CGFloat)self.calendarModel.numberOfColumns;
        CGFloat pixelsThatMakePerfectDivisionImpossible = (CGFloat)((NSInteger)parentBounds % (NSInteger)numberOfColumns);
        
        CGFloat widthAdjustForEvenDivisionByColumnCount = parentBounds - pixelsThatMakePerfectDivisionImpossible;
        sideOfACell = numberOfColumns > 0 ? widthAdjustForEvenDivisionByColumnCount / numberOfColumns : 0.0;
    }
    
    return sideOfACell;
}


// MARK: - Layout

- (CGSize)intrinsicContentSize
{
    CGFloat width = UIViewNoIntrinsicMetric;
    CGFloat height = UIViewNoIntrinsicMetric;
    
    if(self.superview)
    {
        CGFloat cellLength = [self _lengthOfTheSideOfACell];
        height = self.headerView.intrinsicContentSize.height + (cellLength * (CGFloat)self.calendarModel.numberOfRows);
        width = CGRectGetWidth(self.superview.bounds);
    }
    
    return CGSizeMake(width, height);
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// MARK: - Calendar Scrubbing

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.temporaryDate = self.calendarModel.date;
    
    [self highlightCellBeneathTouches:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self highlightCellBeneathTouches:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    BOOL isInGrid = CGRectContainsPoint(self.gridView.frame, point);
    
    if(isInGrid)
    {
        [self highlightCellBeneathTouches:touches];
        NSDate *dateFromTouches = [self dateFromTouches:touches];
        
        self.calendarModel.date = dateFromTouches;
    }
    else
    {
        [self restoreDateFromBeforeInteraction];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    BOOL touchIsInHeader = [self touch:touches.anyObject isInView:self.headerView];
    if(!touchIsInHeader)
    {
        [self restoreDateFromBeforeInteraction];
    }
}

// MARK: -

- (void)highlightCellBeneathTouches:(NSSet <UITouch *> *)touches
{
    UICollectionViewCell *cellFromTouch = [self cellFromTouches:touches];
    
    if(cellFromTouch)
    {
        self.mostRecentlyHighlightedCell.highlighted = NO;
        cellFromTouch.highlighted = YES;
        self.mostRecentlyHighlightedCell = cellFromTouch;
    }
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

/**
 Finds the grid cell beneath the user's touch.
 
 @param date The date to use to find the cell.
 @return A cell beneath the finger.
 */
- (nullable UICollectionViewCell *)cellFromDate:(NSDate *)date
{
    NSIndexPath *indexPath = [self.calendarModel indexPathForDate:date];
    UICollectionViewCell *cell = [self.gridView cellForItemAtIndexPath:indexPath];
    
    return cell;
}

// MARK: - Installing Internal Views

- (void)_installGridView
{
    self.gridView.gridDataSource = self.calendarModel;
    self.gridView.gridAppearanceDelegate = self;
    self.gridView.backgroundColor = kCalendarColorLightGray;
    
    if(![self.subviews containsObject:self.gridView])
    {
        self.gridView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.gridView];
        
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
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0];
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.gridView
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.gridView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
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
    [header setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [header setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    if (![self.subviews containsObject:self.headerView])
    {
        [self addSubview:self.headerView];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.headerView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0
                                                                constant:0.0];
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0];
        
        [NSLayoutConstraint activateConstraints:@[top, leading, trailing]];
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
    [self reloadAnimated:YES transitioningFromDate:fromDate toDate:toDate];
    
    if ([[self delegate] respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [[self delegate] calendarView:self didSelectDate:toDate];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        [self setEvents:[[self dataSource] calendarView:self eventsForDate:toDate]];
    }
}

// MARK: - Handling Display Mode Changes

- (void)calendarModel:(CKCalendarModel *)model willChangeFromDisplayMode:(CKCalendarViewDisplayMode)oldMode toDisplayMode:(CKCalendarViewDisplayMode)newMode;
{
    
}

- (void)calendarModel:(CKCalendarModel *)model didChangeFromDisplayMode:(CKCalendarViewDisplayMode)oldMode toDisplayMode:(CKCalendarViewDisplayMode)newMode;
{
    [self reloadAnimated:YES];
}

/**
 Called after the calendar model updates its `displayMode`, `calendar` or `locale` properties.
 
 @param model The model that did change.
 */
- (void)calendarModelDidInvalidate:(CKCalendarModel *)model;
{
    [self reload];
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
        
        CKCalendarTransitionDirection direction = CKCalendarTransitionDirectionForward;
        
        if ([self.calendarModel.calendar date:fromDate isAfterDate:toDate])
        {
            direction = CKCalendarTransitionDirectionBackward;
        }
        
        CGPoint offset = [self.calendarModel initialOffsetForTargetDate:toDate forDirection:direction inContentSize:self.gridView.contentSize];
        
        self.layout.transitionAxis = self.calendarModel.transitionAxis;
        self.layout.transitionDirection = direction;
        self.layout.initialOffset = offset;
        
        __weak CKCalendarGridView *gridView = self.gridView;
        
        id updateBlock = [self updateBlockForGridView:gridView WithBefore:numberOfSectionsBefore andAfter:numberOfSectionsAfter];
        
        [self.gridView performBatchUpdates:updateBlock completion:nil];
    }
    else
    {
        [self.gridView reloadData];
    }
}


/**
 Returns an update block

 @param gridView The calendar grid view.
 @param before The number of sections in the grid view before updating.
 @param after The number of sections in the grid view after updating.
 */
- (nonnull void(^)(void))updateBlockForGridView:(CKCalendarGridView *)gridView WithBefore:(NSInteger)before andAfter:(NSInteger)after
{
    
    id updateBlock = ^{ };
    
    if (before > 0 && after == 0)
    {
        updateBlock = ^ {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, before)];
            [gridView deleteSections:indexSet];
        };
    }
    else if (after > 0 && before == 0)
    {
        updateBlock = ^{
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, after)];
            [gridView insertSections:indexSet];
        };
    }
    else
    {
        updateBlock = ^{
            NSIndexSet *beforeSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, before)];
            [gridView deleteSections:beforeSet];
            
            NSIndexSet *afterSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, after)];
            [gridView insertSections:afterSet];
        };
    }
    return updateBlock;
}


/**
 Invalidates the intrinsic content size to allow display of all cells. 
 
 This method calls `_adjustToFitCells:completion:`, passing `nil` for the completion block.

 @param animated Determines if the change is animated.
 */
- (void)_adjustToFitCells:(BOOL)animated
{
    [self _adjustToFitCells:animated completion:nil];
}

/**
 Invalidates the intrinsic content size to allow display of all cells.
 
 @param animated Determines if the change is animated.
 @param completion A completion block passed to UIView for execution at the end of the animation. Not executed if animated is `NO`
*/
- (void)_adjustToFitCells:(BOOL)animated completion:(void(^ _Nullable)(BOOL finished))completion
{
    __weak CKCalendarView *weakSelf = self;
    __weak UIView *superview = self.superview;
    
    id block = ^{
        [weakSelf invalidateIntrinsicContentSize];
        [superview setNeedsLayout];
        [superview layoutIfNeeded];
    };
    
    if(animated)
    {
        [self.superview setNeedsLayout];
        [UIView animateWithDuration:0.3 animations:block completion:completion];
    }
    else
    {
        [UIView performWithoutAnimation:block];
    }
}

// MARK: - CKCalendarGridDelegate

/**
 This implementation ensures that the cell that we're about to display has the appropriate selection, and then call the custom cell provider if one exists.
 */
- (void)calendarGrid:(CKCalendarGridView *)gridView willDisplayCell:(UICollectionViewCell *)cell forDate:(NSDate *)date
{
    CKCalendarCellContext *calendarContext = [[CKCalendarCellContext alloc] initWithDate:date andCalendarView:self];
    
    if(calendarContext.isSelected)
    {
        self.mostRecentlyHighlightedCell = cell;
        cell.selected = YES;
    }
    else
    {
        cell.selected = NO;
    }
    
    [self.customCellProvider calendarView:self willDisplayCell:cell inContext:calendarContext];
}


// MARK: - Calendar

- (NSCalendar *)calendar
{
    return self.calendarModel.calendar;
}

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
}

// MARK: - Changing the Date

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

// MARK: - Settings the First Weekday to Control Weekends

- (void)setFirstWeekDay:(NSUInteger)firstWeekDay
{
    self.calendarModel.firstWeekday = firstWeekDay;
}

- (NSUInteger)firstWeekDay
{
    return self.calendarModel.calendar.firstWeekday;
}

// MARK: - Support Manually Overriding RTL

- (void)setSemanticContentAttribute:(UISemanticContentAttribute)semanticContentAttribute
{
    [super setSemanticContentAttribute:semanticContentAttribute];
    
    [self.headerView setSemanticContentAttribute:semanticContentAttribute];
    [self.gridView setSemanticContentAttribute:semanticContentAttribute];
    
    [self reload];
}

// MARK: - Controlling Week Mode Transitions

- (void)setAnimatesWeekTransitions:(BOOL)animatesWeekTransitions
{
    self.calendarModel.animatesWeekTransitions = animatesWeekTransitions;
}

- (BOOL)animatesWeekTransitions
{
    return self.calendarModel.animatesWeekTransitions;
}

// MARK: - Calendar Data Source

- (void)setDataSource:(id<CKCalendarViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    [self reload];
}

// MARK: - Custom Cell Provider

- (void)setCustomCellProvider:(id<CKCustomCellProviding>)customCellProvider
{
    _customCellProvider = customCellProvider;
    if ([customCellProvider respondsToSelector:@selector(customCellClass)])
    {
        [self.gridView setCellClass:customCellProvider.customCellClass];
    }
    else
    {
        NSLog(@"(%@) : Your implementation of CKCustomCellProviding doesn't register a custom cell. You will receive the default CKCalendarCell in your implementation of calendarView:willDisplayCell:forDate:withContext:", self.description);
    }
    [self reload];
}

@end
