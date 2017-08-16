//
//  CKCalendarCell.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/16/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarCellBase.h"

@implementation CKCalendarCellBase

// MARK: - Initializers

- (instancetype)init
{
    self = [super initWithFrame:CGRectNull];
    
    if (self)
    {
        // Initialization code
        _state = CKCalendarCellStateDefault;
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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if (self) {
        
    }
    return self;
}

// MARK: - Managing Cell State


/**
 Sets the calendar's contextual state.

 @param state A valid `CKCalendarCellState` enum.
 */
- (void)setState:(CKCalendarCellState)state
{
    if (state > CKCalendarCellStateOutOfRange || state < CKCalendarCellStateTodaySelected) {
        return;
    }
    
    _state = state;
}

/**
 Marks the cell as selected.
 */
- (void)setSelected;
{
    CKCalendarMonthCellState state = self.state;
    
    if (state == CKCalendarCellStateOutOfCurrentScope) {
        self.state = CKCalendarCellStateOutOfCurrentScopeSelected;
    }
    else if(state == CKCalendarCellStateDefault)
    {
        self.state = CKCalendarCellStateSelected;
    }
    else if(state == CKCalendarCellStateToday)
    {
        self.state = CKCalendarCellStateTodaySelected;
    }
}

/**
 Mark the cell as deselected.
 */
- (void)setDeselected;
{
    CKCalendarMonthCellState state = self.state;
    
    if (state == CKCalendarCellStateOutOfCurrentScopeSelected) {
        self.state = CKCalendarCellStateOutOfCurrentScope;
    }
    else if(state == CKCalendarCellStateSelected)
    {
        self.state = CKCalendarCellStateDefault;
    }
    else if(state == CKCalendarCellStateTodaySelected)
    {
        self.state = CKCalendarCellStateToday;
    }
}

/**
 Mark the cell as out of range, useful when the calendar has a minimumDate or maximumDate set.
 */
- (void)setOutOfRange;
{
    self.state = CKCalendarCellStateOutOfRange;
}

@end
