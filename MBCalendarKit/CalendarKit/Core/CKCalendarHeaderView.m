//
//  CKCalendarHeaderView.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarHeaderView.h"

#import "UIView+Border.h"

#import "CKCalendarHeaderColors.h"

#import "CKCalendarViewModes.h"

#import "MBPolygonView.h"

@interface CKCalendarHeaderView ()
{
    NSUInteger _columnCount;
    CGFloat _columnTitleHeight;
}

@property (nonatomic, strong) UILabel *monthTitle;

@property (nonatomic, strong) NSMutableArray <NSString *> *columnTitles;
@property (nonatomic, strong) NSMutableArray <UILabel *> *columnLabels;

@property (nonatomic, strong) MBPolygonView *forwardButton;
@property (nonatomic, strong) MBPolygonView *backwardButton;

// MARK: - Private Constraints

@property (nullable, weak) NSLayoutConstraint *titleLabelBottomPaddingConstraint;

@end

@implementation CKCalendarHeaderView

// MARK: - Initializer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _headerMonthTextFont = [UIFont boldSystemFontOfSize:22];
        _headerMonthTextColor = kCalendarColorHeaderMonth;
        _headerMonthTextShadow = kCalendarColorHeaderMonthShadow;
        _headerWeekdayTitleFont = [UIFont boldSystemFontOfSize:10];
        _headerWeekdayTitleColor = kCalendarColorHeaderWeekdayTitle;
        _headerWeekdayShadowColor = kCalendarColorHeaderWeekdayShadow;
        _headerGradient = kCalendarColorHeaderGradientDark;
        _headerTitleHighlightedTextColor = kCalendarColorHeaderTitleHighlightedBlue;
        
        _monthTitle = [UILabel new];
        [_monthTitle setTextColor:_headerMonthTextColor];
        [_monthTitle setShadowColor:_headerMonthTextShadow];
        [_monthTitle setShadowOffset:CGSizeMake(0, 1)];
        [_monthTitle setBackgroundColor:[UIColor clearColor]];
        [_monthTitle setTextAlignment:NSTextAlignmentCenter];
        [_monthTitle setFont:_headerMonthTextFont];
        
        _columnTitles = [NSMutableArray new];
        _columnLabels = [NSMutableArray new];
        
        _columnTitleHeight = 10;
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

// MARK: - View Lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self setBackgroundColor:self.headerGradient];
    [self reloadData];
}

// MARK: - Layout

- (void)updateConstraints {
    
    /*  Check for a data source for the header to be installed. */
    if (![self dataSource]) {
        @throw [NSException exceptionWithName:@"CKCalendarViewHeaderException" reason:@"Header can't be installed without a data source" userInfo:@{@"Header": self}];
    }
    
    [self _installMonthLabel];
    [self _adjustMonthLabelForColumnTitles];
    [self _installBackwardAndForwardButtons];
    [self _installColumnTitleLabels];
    
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self _updateMonthLabelDisplay];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 44.0);
}

// MARK: - Display

/**
 Causes the header view to reload the contents
 of the month title label, and the days of the week.
 */
- (void)reloadData;
{
    [self _updateMonthLabelDisplay];
    [self _installColumnTitleLabels];
}

// MARK: - Layout Helpers

- (void)_installColumnTitleLabels
{
    /* Query the data source for the number of columns. */
    NSInteger newColumnCount = [self.dataSource numberOfColumnsForHeader:self];
    
    if(_columnCount != newColumnCount)
    {
        _columnCount = newColumnCount;
        
        [self _removeLabelsInPreparationForLayout];
        [self _reloadColumnTitlesFromDataSource];
        [self _createAndInstallColumnLabels];
    }
    
    [self _populateColumnTitleLabels];
}


/**
 Remove the labels in self.columnLabels and their constraints from the view hierarchy.
 */
- (void)_removeLabelsInPreparationForLayout
{
    /* Remove old labels */
    for (UILabel *label in self.columnLabels)
    {
        [self removeConstraints:label.constraints];
        [label removeFromSuperview];
    }
    
    [self.columnLabels removeAllObjects];
    [self.columnTitles removeAllObjects];
}


/**
 Asks the data source for the column titles and caches them internally.
 */
- (void)_reloadColumnTitlesFromDataSource
{
    for (NSUInteger column = 0; column < _columnCount; column++)
    {
        NSString *title = [self.dataSource header:self titleForColumnAtIndex:column];
        [self.columnTitles addObject:title];
    }
}


/**
 Creates enough column labels for the titles, and installs them.
 */
- (void)_createAndInstallColumnLabels
{
    UIView *previous = self;
    
    for (NSUInteger i = 0; i < self.columnTitles.count; i++)
    {
        NSString *title = self.columnTitles[i];
        UILabel *label = [self _columnLabelWithTitle:title];
        [self.columnLabels addObject:label];
        [self _constrainLabel:label toPrevious:previous];
        
        previous = label;
    }
}


/**
 Populates the column labels.
 */
- (void)_populateColumnTitleLabels
{
    for(NSInteger i = 0; i<self.columnTitles.count; i++)
    {
        UILabel *label = self.columnLabels[i];
        label.text = self.columnTitles[i];
    }
}

- (void)_configureLabel:(UILabel *)label
{
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:self.headerWeekdayTitleColor];
    [label setShadowColor:self.headerWeekdayShadowColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:self.headerWeekdayTitleFont];
    [label setShadowOffset:CGSizeMake(0, 1)];
}

/* Creates and configures a label for a column title */

- (UILabel *)_columnLabelWithTitle:(NSString *)title
{
    UILabel *l = [UILabel new];
    [self _configureLabel:l];
    [l setText:title];
    
    return l;
}

- (void)updateLabelsAppearance
{
    for (UILabel *label in self.columnLabels) {
        [self _configureLabel:label];
    }
}

/**
 Constrains each label to a previous view, to achieve
 the effect of a row of equally sized labels, stretching
 across the width of the header view.

 @param label The label we're installing.
 @param previous The view to constraint to. Either `self` (for the first label) or another label (for the remaining labels.)
 */
- (void)_constrainLabel:(UILabel *)label toPrevious:(UIView *)previous
{
    BOOL first = [previous isEqual:self];
    BOOL last = [self.columnLabels.lastObject.text isEqualToString:self.columnTitles.lastObject];
    
    [self addSubview:label];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    /* Height */
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    /* String together views. */
    NSLayoutAttribute toAttribute = NSLayoutAttributeTrailing;
    
    if ([previous isEqual:self])
    {
        toAttribute = NSLayoutAttributeLeading;
    }
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:label
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:previous
                                                               attribute:toAttribute
                                                              multiplier:1.0
                                                                constant:0.0];
    
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:label
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0];
    
    
    if(!first)
    {
        NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:label
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:previous
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0.0];
        [self addConstraint:equalWidth];
    }
    
    if(last)
    {
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:label
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0];
        [self addConstraint:trailing];
    }
    
    [self addConstraints:@[leading, bottom]];
}


/**
 If the month label isn't in the view hierarchy, set it up.
 */
- (void)_installMonthLabel
{
    if(![self.subviews containsObject:self.monthTitle])
    {
        [self addSubview:self.monthTitle];
        
        self.monthTitle.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.monthTitle
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.monthTitle
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.monthTitle
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.monthTitle
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0 constant:0.0];
        
        bottom.identifier = @"com.mosheberman.constraint-title-bottom";
        self.titleLabelBottomPaddingConstraint = bottom;
        
        [self addConstraints:@[centerX, leading, top, bottom]];
    }
    
}

/**
 Update contents and the highlighting 
 of the month label, as appropriate.
 */
- (void)_updateMonthLabelDisplay
{
    [self _updateMonthLabelText];
    [self _updateMonthLabelHighlighting];
}

/**
 Update the text of the month label.
 */
- (void)_updateMonthLabelText
{
    NSString *title = [self.dataSource titleForHeader:self];
    self.monthTitle.text = title;
}

/**
 Update the highlighting of the month label.
 */
- (void)_updateMonthLabelHighlighting
{
    if ([self shouldHighlightTitle])
    {
        [[self monthTitle] setTextColor:self.headerTitleHighlightedTextColor];
    }
    else
    {
        [[self monthTitle] setTextColor:self.headerMonthTextColor];
    }
}


/**
 Adjusts the constant of the bottom padding constraint
 on the title label to make space for the column titles.
 
 @discussion In "day" mode, use the entire height for the month
 label. In week and month modes, add space for the weekday 
 titles.
 */
- (void)_adjustMonthLabelForColumnTitles
{
    /* Show the forward and back buttons */
    
    if ([self.dataSource numberOfColumnsForHeader:self] == 0)
    {
        self.titleLabelBottomPaddingConstraint.constant = 0.0;
    }
    else
    {
        self.titleLabelBottomPaddingConstraint.constant = -10.0;
    }
    
    [self.forwardButton setNeedsDisplay];
    [self.backwardButton setNeedsDisplay];
}

// MARK: - Back And Forward Buttons

/**
 Create buttons for next and previous months.
 */
- (void)_installBackwardAndForwardButtons
{
    if (!self.forwardButton)
    {
        self.forwardButton = [self createButtonConstrainedTo:NSLayoutAttributeTrailing];
    }
    
    if (!self.backwardButton)
    {
        self.backwardButton = [self createButtonConstrainedTo:NSLayoutAttributeLeading];
    }
    
    if ([self shouldDisableForwardButton]) {
        [self.forwardButton setAlpha:0.5];
    }
    
    if ([self shouldDisableBackwardButton]) {
        [self.backwardButton setAlpha:0.5];
    }
}


/**
 Creates a polygon view to serve as a button.

 @param leadingOrTrailing A layout attribute to use to position the view. Either `NSLayoutAttributeLeading` or `NSLayoutAttributeTrailing`. Other attributes are undefined.
 @return An instance of MBPolygonView, configured and positioned inside `self`.
 */
- (MBPolygonView *)createButtonConstrainedTo:(NSLayoutAttribute)leadingOrTrailing
{
    BOOL isLeading = leadingOrTrailing == NSLayoutAttributeLeading;
    
    CGFloat rotation = isLeading ? 30.0 : 90.0;
    
    MBPolygonView *polygonView = [[MBPolygonView alloc] initWithFrame:CGRectZero numberOfSides:3 andRotation:rotation andScale:10.0];
    
    polygonView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:polygonView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.monthTitle
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0.0];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:polygonView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:polygonView
                                                             attribute:NSLayoutAttributeHeight
                                                            multiplier:1.0 constant:0.0];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:polygonView
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.monthTitle
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *anchor = [NSLayoutConstraint constraintWithItem:polygonView
                                                              attribute:leadingOrTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:leadingOrTrailing
                                                             multiplier:1.0
                                                               constant:0.0];
    
    [self addSubview:polygonView];
    [self addConstraints:@[width, centerY, anchor, height]];
    
    return polygonView;
}

// MARK: - Touch Handling

- (void)tapHandler:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    
    if ([gesture state] != UIGestureRecognizerStateEnded) {
        return;
    }
    
    if (CGRectContainsPoint([[self forwardButton] frame], location) && ![self shouldDisableForwardButton])
    {
        [self forwardButtonTapped];
    }
    
    else if(CGRectContainsPoint([[self backwardButton] frame],location) && ![self shouldDisableBackwardButton])
    {
        [self backwardButtonTapped];
    }
}

#pragma mark - Appearance Handling

- (void)setHeaderMonthTextFont:(UIFont *)headerMonthTextFont {
    _headerMonthTextFont = headerMonthTextFont;
    
    [self.monthTitle setFont:_headerMonthTextFont];
}

- (void)setHeaderMonthTextColor:(UIColor *)headerMonthTextColor {
    _headerMonthTextColor = headerMonthTextColor;
    
    [self.monthTitle setTextColor:headerMonthTextColor];
}

- (void)setHeaderMonthTextShadow:(UIColor *)headerMonthTextShadow {
    _headerMonthTextShadow = headerMonthTextShadow;
    
    [self.monthTitle setShadowColor:headerMonthTextShadow];
}


- (void)setHeaderWeekdayTitleFont:(UIFont *)headerWeekdayTitleFont {
    _headerWeekdayTitleFont = headerWeekdayTitleFont;
    
    [self updateLabelsAppearance];
}

- (void)setHeaderWeekdayTitleColor:(UIColor *)headerWeekdayTitle {
    _headerWeekdayTitleColor = headerWeekdayTitle;
    
    [self updateLabelsAppearance];
}

- (void)setHeaderWeekdayShadowColor:(UIColor *)headerWeekdayShadow {
    _headerWeekdayShadowColor = headerWeekdayShadow;
    
    [self updateLabelsAppearance];
}

- (void)setHeaderGradient:(UIColor *)headerGradient {
    _headerGradient = headerGradient;
    
    [self setBackgroundColor:headerGradient];
}

#pragma mark - Button Handling

- (void)forwardButtonTapped
{
    if ([[self delegate] respondsToSelector:@selector(forwardTapped)]) {
        [[self delegate] forwardTapped];
    }
}

- (void)backwardButtonTapped
{
    if ([[self delegate] respondsToSelector:@selector(backwardTapped)]) {
        [[self delegate] backwardTapped];
    }
}

#pragma mark - Title Highlighting

- (BOOL)shouldHighlightTitle
{
    if ([[self delegate] respondsToSelector:@selector(headerShouldHighlightTitle:)]) {
        return [[self dataSource] headerShouldHighlightTitle:self];
    }
    return NO;  //  Default is no.
}

#pragma mark - Button Disabling

- (BOOL)shouldDisableForwardButton
{
    if ([[self dataSource] respondsToSelector:@selector(headerShouldDisableForwardButton:)]) {
        return [[self dataSource] headerShouldDisableForwardButton:self];
    }
    return NO;  //  Default is no.
}

- (BOOL)shouldDisableBackwardButton
{
    if ([[self dataSource] respondsToSelector:@selector(headerShouldDisableBackwardButton:)]) {
        return [[self dataSource] headerShouldDisableBackwardButton:self];
    }
    return NO;  //  Default is no.
}

@end
