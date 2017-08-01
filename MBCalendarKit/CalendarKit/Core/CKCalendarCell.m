//
//  CKCalendarCalendarCell.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarCell.h"
#import "CKCalendarCellColors.h"

#import "UIView+Border.h"

@interface CKCalendarCell (){
    CGSize _size;
}

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *dot;

@end

@implementation CKCalendarCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _state = CKCalendarMonthCellStateNormal;
        
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
    }
    return self;
}

- (id)initWithSize:(CGSize)size
{
    self = [self init];
    if (self) {
        _size = size;
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self configureLabel];
    [self configureDot];
    [self applyColors];
}

#pragma mark - Layout

- (void)updateConstraints
{
    [self _installLabel];
    [self _installDot];
    
    [super updateConstraints];
}

- (void)_installLabel
{
    if(![self.subviews containsObject:self.label])
    {
        [self addSubview:self.label];
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.label
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.label
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.label
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.label
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0.0];
        
        [self addConstraints:@[centerY, centerX, top, leading]];
    }
}

- (void)_installDot
{
    if(![self.subviews containsObject:self.dot])
    {
        [self addSubview:self.dot];
        self.dot.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.dot
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.dot
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self
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
        
        [self addConstraints:@[centerX, bottom, ratio, width]];
    }
}

#pragma mark - Setters

- (void)setState:(CKCalendarMonthCellState)state
{
    if (state > CKCalendarMonthCellStateOutOfRange || state < CKCalendarMonthCellStateTodaySelected) {
        return;
    }
    
    _state = state;
    
    [self applyColorsForState:_state];
}

- (void)setNumber:(NSNumber *)number
{
    _number = number;
    
    //  TODO: Locale support?
    NSString *stringVal = [number stringValue];
    [[self label] setText:stringVal];
}

- (void)setShowDot:(BOOL)showDot
{
    _showDot = showDot;
    [[self dot] setHidden:!showDot];
}

#pragma mark - Recycling Behavior

-(void)prepareForReuse
{
    //  Alpha, by default, is 1.0
    [[self label]setAlpha:1.0];
    
    [self setState:CKCalendarMonthCellStateNormal];
    
    [self applyColors];
}

#pragma mark - Label 

- (void)configureLabel
{
    UILabel *label = self.label;
    
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Dot

- (void)configureDot
{
    CGFloat dotRadius = 3.0;
    UIView *dot = [self dot];
    
    [dot.layer setCornerRadius:dotRadius/2];
}

#pragma mark - UI Coloring

- (void)applyColors
{    
    [self applyColorsForState:[self state]];
    [self showBorder];
}

//  TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:(CKCalendarMonthCellState)state
{
    //  Default colors and shadows
    [[self label] setTextColor:[self textColor]];
    [[self label] setShadowColor:[self textShadowColor]];
    [[self label] setShadowOffset:CGSizeMake(0, 0.5)];
    
    [self setBorderColor:[self cellBorderColor]];
    [self setBorderWidth:0.5];
    [self setBackgroundColor:[self normalBackgroundColor]];
    
    //  Today cell
    if(state == CKCalendarMonthCellStateTodaySelected)
    {
        [self setBackgroundColor:[self todaySelectedBackgroundColor]];
        [[self label] setShadowColor:[self todayTextShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
        [self setBorderColor:[self backgroundColor]];
    }
    
    //  Today cell, selected
    else if(state == CKCalendarMonthCellStateTodayDeselected)
    {
        [self setBackgroundColor:[self todayBackgroundColor]];
        [[self label] setShadowColor:[self todayTextShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
        [self setBorderColor:[self backgroundColor]];
        [self showBorder];
    }
    
    //  Selected cells in the active month have a special background color
    else if(state == CKCalendarMonthCellStateSelected)
    {
        [self setBackgroundColor:[self selectedBackgroundColor]];
        [self setBorderColor:[self selectedCellBorderColor]];
        [[self label] setTextColor:[self textSelectedColor]];
        [[self label] setShadowColor:[self textSelectedShadowColor]];
        [[self label] setShadowOffset:CGSizeMake(0, -0.5)];
    }
    
    if (state == CKCalendarMonthCellStateInactive) {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
    }
    else if (state == CKCalendarMonthCellStateInactiveSelected)
    {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
        [self setBackgroundColor:[self inactiveSelectedBackgroundColor]];
    }
    else if(state == CKCalendarMonthCellStateOutOfRange)
    {
        [[self label] setAlpha:0.01];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
    }
    
    //  Make the dot follow the label's style
    [[self dot] setBackgroundColor:[[self label] textColor]];
    [[self dot] setAlpha:[[self label] alpha]];
}

#pragma mark - Selection State

- (void)setSelected
{
    
    CKCalendarMonthCellState state = [self state];
    
    if (state == CKCalendarMonthCellStateInactive) {
        [self setState:CKCalendarMonthCellStateInactiveSelected];
    }
    else if(state == CKCalendarMonthCellStateNormal)
    {
        [self setState:CKCalendarMonthCellStateSelected];
    }
    else if(state == CKCalendarMonthCellStateTodayDeselected)
    {
        [self setState:CKCalendarMonthCellStateTodaySelected];
    }
}

- (void)setDeselected
{
    CKCalendarMonthCellState state = [self state];
    
    if (state == CKCalendarMonthCellStateInactiveSelected) {
        [self setState:CKCalendarMonthCellStateInactive];
    }
    else if(state == CKCalendarMonthCellStateSelected)
    {
        [self setState:CKCalendarMonthCellStateNormal];
    }
    else if(state == CKCalendarMonthCellStateTodaySelected)
    {
        [self setState:CKCalendarMonthCellStateTodayDeselected];
    }
}

- (void)setOutOfRange
{
    [self setState:CKCalendarMonthCellStateOutOfRange];
}

@end
