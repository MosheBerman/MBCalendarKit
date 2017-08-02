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


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self setNeedsLayout];
    [self setBackgroundColor:self.headerGradient];
}

#pragma mark - Layout


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


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self _updateMonthLabelDisplay];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UIViewNoIntrinsicMetric, 44.0);
}

#pragma mark - Layout Helpers

- (void)_installColumnTitleLabels {
    /* Query the data source for the number of columns. */
    NSInteger newColumnCount = [self.dataSource numberOfColumnsForHeader:self];
    
    if(_columnCount != newColumnCount)
    {
        _columnCount = newColumnCount;
        
        /* Remove old labels */
        for (UILabel *label in self.columnLabels)
        {
            [self removeConstraints:label.constraints];
            [label removeFromSuperview];
        }
        
        [self.columnLabels removeAllObjects];
        [self.columnTitles removeAllObjects];
        
        for (NSUInteger column = 0; column < _columnCount; column++) {
            
            NSString *title = [self.dataSource header:self titleForColumnAtIndex:column];
            [self.columnTitles addObject:title];
        }
        
        /* Convert title strings into labels and lay them out */
        if(_columnCount > 0)
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
    }
    
}

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

- (void)_installMonthLabel
{
    if([self.subviews containsObject:self.monthTitle])
    {
        return;
    }
    
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

- (void)_updateMonthLabelDisplay
{
    NSString *title = [[self dataSource] titleForHeader:self];
    [[self monthTitle] setText:title];
    
    /* Highlight the title color as appropriate */
    
    if ([self shouldHighlightTitle])
    {
        [[self monthTitle] setTextColor:self.headerTitleHighlightedTextColor];
    }
    else
    {
        [[self monthTitle] setTextColor:self.headerMonthTextColor];
    }
}

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

- (void)_installBackwardAndForwardButtons
{
    if (!self.forwardButton)
    {
        self.forwardButton = [self createButtonConstrainedTo:NSLayoutAttributeTrailing withArrowRotation:90.0];
    }
    
    if (!self.backwardButton)
    {
        self.backwardButton = [self createButtonConstrainedTo:NSLayoutAttributeLeading withArrowRotation:30.0];
    }
    
    if ([self shouldDisableForwardButton]) {
        [self.forwardButton setAlpha:0.5];
    }
    
    if ([self shouldDisableBackwardButton]) {
        [self.backwardButton setAlpha:0.5];
    }
}

- (MBPolygonView *)createButtonConstrainedTo:(NSLayoutAttribute)leadingOrTrailing withArrowRotation:(CGFloat)rotation
{
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


#pragma mark - Convenience Methods

- (void)configureLabel:(UILabel *)label {
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
    [self configureLabel:l];
    [l setText:title];
    
    return l;
}

- (void)updateLabelsAppearance {
    for (UILabel *label in self.columnLabels) {
        [self configureLabel:label];
    }
}

#pragma mark - Touch Handling

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
