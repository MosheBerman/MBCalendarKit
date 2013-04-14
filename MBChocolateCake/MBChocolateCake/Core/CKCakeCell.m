//
//  CKCakeCalendarCell.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCakeCell.h"
#import "CKCakeCellColors.h"

#import "UIView+Border.h"

@interface CKCakeCell (){
    CGSize _size;
}

@property (nonatomic, strong) UILabel *label;

@end

@implementation CKCakeCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _state = CKCakeMonthCellStateNormal;
        
        //  Normal Cell Colors
        _normalBackgroundColor = kCakeColorLightGray;
        _selectedBackgroundColor = kCakeColorBlue;
        _inactiveSelectedBackgroundColor = kCakeColorDarkGray;
        
        //  Today Cell Colors
        _todayBackgroundColor = kCakeColorBluishGray;
        _todaySelectedBackgroundColor = kCakeColorBlue;
        _todayShadowColor = kCakeColorTodayShadowBlue;
        _todayTextColor = [UIColor whiteColor];
        
        //  Text Colors
        _textColor = kCakeColorDarkTextGradient;
        _textShadowColor = [UIColor whiteColor];
        _textSelectedColor = [UIColor whiteColor];
        _textSelectedShadowColor = kCakeColorSelectedShadowBlue;
        
        _dotColor = kCakeColorDarkTextGradient;
        _selectedDotColor = [UIColor whiteColor];
        
        _cellBorderColor = kCakeColorCellBorder;
        _selectedCellBorderColor = kCakeColorSelectedCellBorder;
        
        // Label
        _label = [UILabel new];
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
    CGPoint origin = [self frame].origin;
    [self setFrame:CGRectMake(origin.x, origin.y, _size.width, _size.height)];
    [self layoutSubviews];
    [self applyColors];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self configureLabel];
    [self addSubview:[self label]];
}

#pragma mark - Setters

- (void)setState:(CKCakeMonthCellState)state
{
    if (state > CKCakeMonthCellStateInactiveSelected || state < CKCakeMonthCellStateTodaySelected) {
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

#pragma mark - Recycling Behavior

-(void)prepareForReuse
{
    [self applyColors];
}

#pragma mark - Label 

- (void)configureLabel
{
    UILabel *label = [self label];
    
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
}

#pragma mark - UI Coloring

- (void)applyColors
{
    //  Alpha, by default, is 1.o
    [[self label]setAlpha:1.0];
    
    [self applyColorsForState:[self state]];
    [self showBorder];
}

//  TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:(CKCakeMonthCellState)state
{
    //  Default colors and shadows
    [[self label] setTextColor:[self textColor]];
    [[self label] setShadowColor:[self textShadowColor]];
    [[self label] setShadowOffset:CGSizeMake(0, 0.5)];
    
    [self setBorderColor:[self cellBorderColor]];
    [self setBorderWidth:0.5];
    [self setBackgroundColor:[self normalBackgroundColor]];
    
    //  Today cell
    if(state == CKCakeMonthCellStateTodaySelected)
    {
        [self setBackgroundColor:[self todaySelectedBackgroundColor]];
        [[self label] setShadowColor:[self todayShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
        [self setBorderColor:[self backgroundColor]];
    }
    
    //  Today cell, selected
    else if(state == CKCakeMonthCellStateTodayDeselected)
    {
        [self setBackgroundColor:[self todayBackgroundColor]];
        [[self label] setShadowColor:[self todayShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
        [self setBorderColor:[self backgroundColor]];
        [self showBorder];
    }
    
    //  Selected cells in the active month have a special background color
    else if(state == CKCakeMonthCellStateSelected)
    {
        [self setBackgroundColor:[self selectedBackgroundColor]];
        [self setBorderColor:[self selectedCellBorderColor]];
        [[self label] setTextColor:[self textSelectedColor]];
        [[self label] setShadowColor:[self textSelectedShadowColor]];
        [[self label] setShadowOffset:CGSizeMake(0, -0.5)];
    }
    
    if (state == CKCakeMonthCellStateInactive) {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
    }
    else if (state == CKCakeMonthCellStateInactiveSelected)
    {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
        [self setBackgroundColor:[self inactiveSelectedBackgroundColor]];
    }
}

#pragma mark - Selection State

- (void)setSelected
{
    
    CKCakeMonthCellState state = [self state];
    
    if (state == CKCakeMonthCellStateInactive) {
        [self setState:CKCakeMonthCellStateInactiveSelected];
    }
    else if(state == CKCakeMonthCellStateNormal)
    {
        [self setState:CKCakeMonthCellStateSelected];
    }
    else if(state == CKCakeMonthCellStateTodayDeselected)
    {
        [self setState:CKCakeMonthCellStateTodaySelected];
    }
}

- (void)setDeselected
{
    CKCakeMonthCellState state = [self state];
    
    if (state == CKCakeMonthCellStateInactiveSelected) {
        [self setState:CKCakeMonthCellStateInactive];
    }
    else if(state == CKCakeMonthCellStateSelected)
    {
        [self setState:CKCakeMonthCellStateNormal];
    }
    else if(state == CKCakeMonthCellStateTodaySelected)
    {
        [self setState:CKCakeMonthCellStateTodayDeselected];
    }
}

@end
