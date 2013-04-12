//
//  CKCakeCalendarCell.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCakeMonthCell.h"
#import "CKCakeCellColors.h"

@interface CKCakeMonthCell (){
    CGSize _size;
}

@property (nonatomic, strong) UILabel *label;

@end

@implementation CKCakeMonthCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _state = CKCakeMonthCellStateNormal;
        
        //  Normal Cell Colors
        _normalBackgroundColor = kCakeColorLightGray;
        _selectedBackgroundColor = kCakeColorBlue;
        
        //  Today Cell Colors
        _todayBackgroundColor = kCakeColorBluishGray;
        _todaySelectedBackgroundColor = kCakeColorBlue;
        _todayShadowColor = kCakeColorTodayShadowBlue;
        
        //  Text Colors
        _textColor = kCakeColorDarkTextGradient;
        _textShadowColor = [UIColor whiteColor];
        _textSelectedColor = [UIColor whiteColor];
        _textSelectedShadowColor = kCakeColorSelectedShadowBlue;
        
        _dotColor = kCakeColorDarkTextGradient;
        _selectedDotColor = [UIColor whiteColor];
        
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

#pragma mark - Layout

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGPoint origin = [self frame].origin;
    [self setFrame:CGRectMake(origin.x, origin.y, _size.width, _size.height)];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [self configureLabel];
    [self addSubview:[self label]];
}

#pragma mark - Setters

- (void)setState:(CKCakeMonthCellState)state
{
    if (state < CKCakeMonthCellStateInactiveSelected || state < CKCakeMonthCellStateTodaySelected) {
        return;
    }
    
    _state = state;
    [self applyColors];
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
}

//  TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:(CKCakeMonthCellState)state
{
    //  Default colors and shadows
    [[self label] setTextColor:[self textColor]];
    [[self label] setShadowColor:[self textShadowColor]];
    [[self label] setShadowOffset:CGSizeMake(0, 0.5)];
    
    [self setBackgroundColor:[self normalBackgroundColor]];
    
    //  Today cell
    if(state == CKCakeMonthCellStateTodaySelected)
    {
        [self setBackgroundColor:[self todaySelectedBackgroundColor]];
        [[self label] setShadowColor:[self todayShadowColor]];
    }
    
    //  Today cell, selected
    else if(state == CKCakeMonthCellStateTodayDeselected)
    {
        [self setBackgroundColor:[self todayBackgroundColor]];
        
        [[self label] setShadowColor:[self todayShadowColor]];
    }
    
    //  Selected cells in the active month have a special background color
    else if(state == CKCakeMonthCellStateSelected)
    {
        [self setBackgroundColor:[self selectedBackgroundColor]];
        [[self label] setShadowOffset:CGSizeMake(0, -1)];
    }
    
    if (state == CKCakeMonthCellStateInactive || state == CKCakeMonthCellStateInactiveSelected) {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        [[self label] setShadowOffset:CGSizeZero];
    }
}

@end
