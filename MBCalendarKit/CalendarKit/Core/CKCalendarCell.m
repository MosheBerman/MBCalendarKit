//
//  CKCalendarCalendarCell.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarCell.h"
#import "CKCalendarCellState.h"
#import "CKCalendarCellColors.h"

#import "UIView+Border.h"

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
    self = [super initWithFrame:CGRectZero];
    if (self) {
    
        _state = CKCalendarCellStateDefault;
        
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
        _label = [UILabel new];
        
        //  Dot
        _dot = [UIView new];
        [_dot setHidden:YES];
        _showDot = NO;
        
        [self buildViewHierarchy];
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

// MARK: -

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self configureLabel];
    [self configureDot];
    [self applyColorsForState:self.state];
    [self showBorder];
}

// MARK: - Layout

- (void)buildViewHierarchy
{
    if (![self.subviews containsObject:self.label])
    {
        [self.contentView addSubview:self.label];
        [self _constrainLabel];
    }
    
    if(![self.subviews containsObject:self.dot])
    {
        [self.contentView addSubview:self.dot];
        [self _constrainDot];
    }
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
    
    [self.contentView addConstraints:@[centerY, centerX, top, leading]];
    
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
    
    [self.contentView addConstraints:@[centerX, bottom, ratio, width]];
    
}

// MARK: - Setters

- (void)setNumber:(NSNumber *)number
{
    _number = number;
    
    //  TODO: Locale support?
    NSString *stringVal = number.stringValue;
    self.label.text = stringVal;
}

- (void)setShowDot:(BOOL)showDot
{
    _showDot = showDot;
    self.dot.hidden = !showDot;
}

// MARK: - Cell Recycling

/**
 Called before the cell is dequeued by the calendar view.
 Use this to reset colors and opacities to their default values.
 */
-(void)prepareForReuse;
{
    [super prepareForReuse];
    
    //  Alpha, by default, is 1.0
    self.label.alpha = 1.0;
    
    self.state = CKCalendarCellStateDefault;
    
    [self applyColorsForState:self.state];
    [self showBorder];
}

// MARK: - Label

- (void)configureLabel
{
    UILabel *label = self.label;
    
    label.font = [UIFont boldSystemFontOfSize:13];
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
    self.label.textColor = self.textColor;
    self.label.shadowColor = self.textShadowColor;
    self.label.shadowOffset = CGSizeMake(0, 0.5);
    
    [self setBorderColor:self.cellBorderColor];
    [self setBorderWidth:0.5];
    [self showBorder];
    self.backgroundColor = self.normalBackgroundColor;
    
    //  Today cell, selected
    if(state == CKCalendarCellStateToday && self.selected)
    {
        self.backgroundColor = self.todaySelectedBackgroundColor;
        self.label.shadowColor = self.todayTextShadowColor;
        self.label.textColor = self.todayTextColor;
        [self setBorderColor:self.backgroundColor];
    }
    
    //  Today cell
    else if(state == CKCalendarCellStateToday)
    {
        self.backgroundColor = self.todayBackgroundColor;
        self.label.shadowColor = self.todayTextShadowColor;
        self.label.textColor = self.todayTextColor;
        [self setBorderColor:self.backgroundColor];
        [self showBorder];
    }
    
    //  Selected cells in the active month have a special background color
    else if(state == CKCalendarCellStateDefault && self.highlighted)
    {
        self.backgroundColor = self.selectedBackgroundColor;
        [self setBorderColor:self.selectedCellBorderColor];
        self.label.textColor = self.textSelectedColor;
        self.label.shadowColor = self.textSelectedShadowColor;
        self.label.shadowOffset = CGSizeMake(0, -0.5);
    }
    //  Selected cells in the active month have a special background color
    else if(state == CKCalendarCellStateDefault && (self.highlighted || self.selected))
    {
        self.backgroundColor = self.selectedBackgroundColor;
        [self setBorderColor:self.selectedCellBorderColor];
        self.label.textColor = self.textSelectedColor;
        self.label.shadowColor = self.textSelectedShadowColor;
        self.label.shadowOffset = CGSizeMake(0, -0.5);
    }
    else if (state == CKCalendarCellStateOutOfCurrentScope && self.highlighted)
    {
        self.label.alpha = 0.5;    //  Label alpha needs to be lowered
        self.label.shadowOffset = CGSizeZero;
        self.backgroundColor = self.inactiveSelectedBackgroundColor;
    }
    else if(state == CKCalendarCellStateOutOfRange && self.highlighted)
    {
        self.label.alpha = 0.01;    //  Label alpha needs to be lowered
        self.label.shadowOffset = CGSizeZero;
        self.backgroundColor = self.inactiveSelectedBackgroundColor;
    }
    else if (state == CKCalendarCellStateOutOfRange)
    {
        self.label.alpha = 0.01;    //  Label alpha needs to be lowered
        self.label.shadowOffset = CGSizeZero;
        self.backgroundColor = self.inactiveSelectedBackgroundColor;
    }
    else if (state == CKCalendarCellStateOutOfCurrentScope)
    {
        self.label.alpha = 0.5;    //  Label alpha needs to be lowered
        self.label.shadowOffset = CGSizeZero;
    }
    
    //  Make the dot follow the label's style
    self.dot.backgroundColor = self.label.textColor;
    self.dot.alpha = self.label.alpha;
}

// MARK: - Collection View Cell Highlighting

- (void)setSelected:(BOOL)selected
{
    super.selected = selected;
    
    [self applyColorsForState:self.state];
}

- (void)setHighlighted:(BOOL)highlighted
{
    super.highlighted = highlighted;
    
    [self applyColorsForState:self.state];
}

/**
 Sets the calendar's contextual state.
 
 @param state A valid `CKCalendarCellState` enum.
 */
- (void)setState:(CKCalendarCellState)state
{
    if (state > CKCalendarCellStateOutOfRange || state < CKCalendarCellStateToday) {
        return;
    }
    
    _state = state;
    
    [self applyColorsForState:state];
}

///**
// Marks the cell as selected.
// */
//- (void)setSelected;
//{
//    self.selected = YES;
//    [self applyColorsForState:self.state];
//}

/**
 Mark the cell as deselected.
 */
- (void)setDeselected;
{
    self.selected = NO;
    [self applyColorsForState:self.state];
}

/**
 Mark the cell as out of range, useful when the calendar has a minimumDate or maximumDate set.
 */
- (void)setOutOfRange;
{
    self.state = CKCalendarCellStateOutOfRange;
}

@end
