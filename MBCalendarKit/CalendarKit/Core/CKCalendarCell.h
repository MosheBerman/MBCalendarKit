//
//  CKCalendarCalendarCell.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import UIKit;
#import "CKCalendarCellBase.h"

/**
 The `CKCalendarCell` class manages the display of a single date in the calendar.
 It is responsible for handling its visual state, and its contents. Specifically,
 the cell class configures the number representing a date, and the visibility of 
 the event indicator dot.
 */
NS_SWIFT_NAME(CalendarCell)
@interface CKCalendarCell : CKCalendarCellBase

// MARK: - Initializers

- (nonnull instancetype)init NS_DESIGNATED_INITIALIZER;

// MARK: - Controlling Cell Content

/**
 The day of the month that is shown in the cell.
 */
@property (nonatomic, strong, nonnull) NSNumber *number;

/**
 A property which determines if the cell shows a dot for events.
 */
@property (nonatomic, assign) BOOL showDot;

// MARK: - Cell Background Colors

/**
 The background color for the cell.
 */
@property (nonatomic, strong, nonnull) UIColor *normalBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The cell background color for cells displaying a date in the same month as the selected date, when the cell is selected, or when a finger is tracking it.
 */
@property (nonatomic, strong, nonnull) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
The cell background color for a cells representing dates in months outside the current month, when a finger is tracking on them.
 */
@property (nonatomic, strong, nonnull) UIColor *inactiveSelectedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The background color for the cell representing today.
 */
@property (nonatomic, strong, nonnull) UIColor *todayBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The background color for the cell representing today, when the cell is selected.
 */
@property (nonatomic, strong, nonnull) UIColor *todaySelectedBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The label's text color for the cell representing today.
 */
@property (nonatomic, strong, nonnull) UIColor *todayTextColor UI_APPEARANCE_SELECTOR;

/**
 The label's shadow color for the cell representing today.
 */
@property (nonatomic, strong, nonnull) UIColor *todayTextShadowColor UI_APPEARANCE_SELECTOR;


// MARK: - Date Label Colors

/**
 The label's text color.
 */
@property (nonatomic, strong, nonnull) UIColor *textColor UI_APPEARANCE_SELECTOR;

/**
 The label's shadow color.
 */
@property (nonatomic, strong, nonnull) UIColor *textShadowColor UI_APPEARANCE_SELECTOR;

/**
 The label's text color for selected cells.
 */
@property (nonatomic, strong, nonnull) UIColor *textSelectedColor UI_APPEARANCE_SELECTOR;

/**
 The label's shadow color for selected cells.
 */
@property (nonatomic, strong, nonnull) UIColor *textSelectedShadowColor UI_APPEARANCE_SELECTOR;


// MARK: - Event Dot Color

/**
 The color for event indicator dots in the cells.
 */
@property (nonatomic, strong, nonnull) UIColor *dotColor UI_APPEARANCE_SELECTOR;

/**
 The color for event indicator dots in the cell when it is selected.
 */
@property (nonatomic, strong, nonnull) UIColor *selectedDotColor UI_APPEARANCE_SELECTOR;


// MARK: - Cell Border Colors

/**
 The border color for the cell.
 */
@property (nonatomic, strong, nonnull) UIColor *cellBorderColor UI_APPEARANCE_SELECTOR;


/**
 The border color for the cell in its deselected state.
 */
@property (nonatomic, strong, nonnull) UIColor *selectedCellBorderColor UI_APPEARANCE_SELECTOR;

// MARK: - Cell Recycling Behavior

/**
 Called before the cell is dequeued by the calendar view.
 Use this to reset colors and opacities to default values.
 */
-(void)prepareForReuse;


// MARK: - Setting Cell Selection State

/**
 Marks the cell as selected and update on the appearance of the cell.
 */
- (void)setSelected;

/**
 Mark the cell as deselected and update on the appearance of the cell.
 */
- (void)setDeselected;

/**
 Mark the cell as representing a date that's out of range, when the calendar has a minimumDate or maximumDate set.
 */
- (void)setOutOfRange;

@end
