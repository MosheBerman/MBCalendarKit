//
//  CKCalendarCalendarCell.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarCell.h"
#import "CKCalendarCellContextIdentifier.h"
#import "CKCalendarCellColors.h"
#import "CKCache.h"

@interface CKCalendarCell ()

/**
 The label that shows a number for the label.
 */
@property (nonatomic, strong) UILabel *label;

/**
 The event indicator view.
 */
@property (nonatomic, strong) UIView *dot;


@end

@implementation CKCalendarCell

- (instancetype)init
{
    CGRect frame = CGRectZero;
    self = [super initWithFrame:frame];
    if (self) {
    
        _state = CKCalendarCellContextIdentifierDefault;
        
        //  Normal Cell Colors
        _normalBackgroundColor = kCalendarColorLightGray;
        _selectedBackgroundColor = kCalendarColorBlue;
        _inactiveSelectedBackgroundColor = kCalendarColorDarkGray;
        
        //  Today Cell Colors
        _todayBackgroundColor = kCalendarColorBluishGray;
        _todaySelectedBackgroundColor = kCalendarColorBlue;
        _todayTextShadowColor = kCalendarColorTodayShadowBlue;
        _todayTextColor = [UIColor whiteColor];
        
        //  Text Colors
        _textColor = kCalendarColorDarkTextGradient;
        _textShadowColor = [UIColor whiteColor];
        _textSelectedColor = [UIColor whiteColor];
        _textSelectedShadowColor = kCalendarColorSelectedShadowBlue;
        
        _dotColor = kCalendarColorDarkTextGradient;
        _selectedDotColor = [UIColor whiteColor];
        
        _cellBorderColor = kCalendarColorCellBorder;
        _selectedCellBorderColor = kCalendarColorSelectedCellBorder;
        
        // Label
        _label = [[UILabel alloc] initWithFrame:frame];
        
        //  Dot
        _dot = [[UIView alloc] initWithFrame:frame];
        [_dot setHidden:YES];
        _showDot = NO;
        
        [self buildViewHierarchy];
        
        _label.layer.shouldRasterize = YES;
        _label.layer.rasterizationScale = UIScreen.mainScreen.scale;
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [self init];
    if (self) {
        
    }
    return self;
}

// MARK: - Layout

- (void)buildViewHierarchy
{
    if (![self.contentView.subviews containsObject:self.label])
    {
        [self.contentView addSubview:self.label];
        [self _constrainLabel];
        [self configureLabel];
    }
    
    if(![self.contentView.subviews containsObject:self.dot])
    {
        [self.contentView addSubview:self.dot];
        [self _constrainDot];
        [self configureDot];
    }
    
    [self applyColorsForState:self.state];
}

// MARK: - Autolayout

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)_constrainLabel
{
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.label
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.label
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.label
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.contentView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0.0];
    
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.label
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0.0];
    
    [NSLayoutConstraint activateConstraints:@[centerY, centerX, top, leading]];
    
}

- (void)_constrainDot
{
    self.dot.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.dot
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.contentView
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.dot
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.contentView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:0.8
                                                               constant:0.0];
    
    NSLayoutConstraint *ratio = [NSLayoutConstraint constraintWithItem:self.dot
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.dot
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0.0];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.dot
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1.0
                                                              constant:3.0];
    
    [NSLayoutConstraint activateConstraints:@[centerX, bottom, ratio, width]];
    
}

// MARK: - Setters

- (void)setNumber:(NSInteger)number
{
    _number = number;
    
    // Using a buffer is slightly faster than stringWithFormat,
    // although we get variable time, based on the size of the integer.
    char *buffer;
    asprintf(&buffer, "%li", (long)number);
    self.label.text = [NSString stringWithUTF8String:buffer];
    free(buffer);
}

- (void)setShowDot:(BOOL)showDot
{
    _showDot = showDot;
    self.dot.hidden = !showDot;
}

// MARK: - Label

- (void)configureLabel
{
    UILabel *label = self.label;
    
    label.font = CKCache.sharedCache.cellFont;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor clearColor];
}

// MARK: - Dot

- (void)configureDot
{
    CGFloat dotRadius = 3.0;
    UIView *dot = self.dot;
    
    (dot.layer).cornerRadius = dotRadius/2;
}

// MARK: - Coloring the Cell

//  TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:(CKCalendarMonthCellState)state
{
    //  Default colors and shadows
    UIColor *textColor = self.textColor;
    UIColor *backgroundColor = self.normalBackgroundColor;
    UIColor *borderColor = self.cellBorderColor;
    
    UIColor *shadowColor = self.textShadowColor;
    CGSize shadowOffset = CGSizeMake(0, 0.5);
    
    CGFloat alpha = 1.0;
    BOOL highlighted = self.highlighted;
    BOOL selectedOrHighlighted = highlighted || self.selected;
    
    //  Today cell, selected
    if(state == CKCalendarCellContextIdentifierToday && selectedOrHighlighted)
    {
        backgroundColor = self.todaySelectedBackgroundColor;
        shadowColor = self.todayTextShadowColor;
        textColor = self.todayTextColor;
        borderColor = self.backgroundColor;
    }
    
    //  Today cell
    else if(state == CKCalendarCellContextIdentifierToday)
    {
        backgroundColor = self.todayBackgroundColor;
        shadowColor = self.todayTextShadowColor;
        textColor = self.todayTextColor;
        borderColor = self.backgroundColor;
    }
    
    //  Selected cells in the active month have a special background color
    else if(state == CKCalendarCellContextIdentifierDefault && highlighted)
    {
        backgroundColor = self.selectedBackgroundColor;
        borderColor = self.selectedCellBorderColor;
        textColor = self.textSelectedColor;
        shadowColor = self.textSelectedShadowColor;
        shadowOffset = CGSizeMake(0, -0.5);
    }
    //  Selected cells in the active month have a special background color
    else if(state == CKCalendarCellContextIdentifierDefault && selectedOrHighlighted)
    {
        backgroundColor = self.selectedBackgroundColor;
        borderColor = self.selectedCellBorderColor;
        textColor = self.textSelectedColor;
        shadowColor = self.textSelectedShadowColor;
        shadowOffset = CGSizeMake(0, -0.5);
    }
    else if (state == CKCalendarCellContextIdentifierOutOfCurrentScope && highlighted)
    {
        alpha = 0.5;    //  Label alpha needs to be lowered
        shadowOffset = CGSizeZero;
        backgroundColor = self.inactiveSelectedBackgroundColor;
    }
    else if(state == CKCalendarCellContextIdentifierOutOfRange && self.highlighted)
    {
        alpha = 0.01;    //  Label alpha needs to be lowered
        shadowOffset = CGSizeZero;
        backgroundColor = self.inactiveSelectedBackgroundColor;
    }
    else if (state == CKCalendarCellContextIdentifierOutOfRange)
    {
        alpha = 0.01;    //  Label alpha needs to be lowered
        shadowOffset = CGSizeZero;
        backgroundColor = self.inactiveSelectedBackgroundColor;
    }
    else if (state == CKCalendarCellContextIdentifierOutOfCurrentScope)
    {
        alpha = 0.5;    //  Label alpha needs to be lowered
        shadowOffset = CGSizeZero;
    }
    
    _label.textColor = textColor;
    _label.shadowColor = shadowColor;
    _label.shadowOffset = shadowOffset;
    _label.alpha = alpha;
    
    self.backgroundColor = backgroundColor;
    
    //  Make the dot follow the label's style
    _dot.backgroundColor = textColor;
    _dot.alpha = alpha;
    
    
    //  Set the border color
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 0.5;
}

// MARK: - Collection View Cell Highlighting

- (void)setSelected:(BOOL)selected
{
    if (selected == self.selected)
    {
        return;
    }
    
    super.selected = selected;
    
    [self applyColorsForState:self.state];
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted == self.highlighted)
    {
        return;
    }
    
    super.highlighted = highlighted;
    
    [self applyColorsForState:self.state];
}

/**
 Sets the calendar's contextual state.
 
 @param state A valid `CKCalendarCellContextIdentifier` enum.
 */
- (void)setState:(CKCalendarCellContextIdentifier)state
{
    if (_state == state)
    {
        return;
    }
    
    if (state > CKCalendarCellContextIdentifierOutOfRange || state < CKCalendarCellContextIdentifierToday) {
        return;
    }
    
    _state = state;
    
    [self applyColorsForState:state];
}

/**
 Marks the cell as selected.
 */
- (void)setSelected;
{
    if (self.selected)
    {
        return;
    }
    
    self.selected = YES;
}

/**
 Mark the cell as deselected.
 */
- (void)setDeselected;
{
    if(!self.selected)
    {
        return;
    }
    
    self.selected = NO;
}

/**
 Mark the cell as out of range, useful when the calendar has a minimumDate or maximumDate set.
 */
- (void)setOutOfRange;
{
    self.state = CKCalendarCellContextIdentifierOutOfRange;
}

@end
