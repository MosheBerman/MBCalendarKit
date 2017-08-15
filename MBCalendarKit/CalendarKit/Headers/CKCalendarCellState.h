//
//  CKCalendarMonthCellStates.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarMonthCellStates_h
#define MBCalendarKit_CKCalendarMonthCellStates_h

/**
 These states represent the possible uses for a cell in a calendar month or week view. To be "selected" means that according to the calendar view's `NSCalendar` the date represented by the cell and the calendar view's `date` property are equal for all calendar units larger than and including `NSCalendarUnitDay`. The current "scope" refers to the calendar unit being displayed, either a month or a week.

 - CKCalendarCellStateTodaySelected: A cell representing today, when the calendar view's selected date is also today.
 - CKCalendarCellStateToday:  A cell representing today, when the calendar view's selected date is not today.
 - CKCalendarCellStateDefault:  A cell representing any date in the current scope besides for today, when the date is not selected.
 - CKCalendarCellStateSelected:  A cell representing any date in the current scope besides for today, when the date is not selected.
 - CKCalendarCellStateOutOfCurrentScope: A cell representing any other date outside the current scope, when the date is not selected.
 - CKCalendarCellStateOutOfCurrentScopeSelected: A cell representing any other date outside the current scope, when the date is selected. This is used for transiet changes while scrubbing.
 - CKCalendarCellStateOutOfRange: A cell representing a date that occurs earlier than the calendar's minimumDate or later than the calendar view's maximumDate.
 - CKCalendarMonthCellStateTodaySelected: Deprecated. Use `CKCalendarCellStateTodaySelected` instead.
 - CKCalendarMonthCellStateToday: Deprecated. Use `CKCalendarCellStateToday` instead.
 - CKCalendarMonthCellStateNormal: Deprecated. Use `CKCalendarCellStateDefault` instead.
 - CKCalendarMonthCellStateSelected: Deprecated. Use `CKCalendarCellStateSelected` instead.
 - CKCalendarMonthCellStateInactive: Deprecated. Use `CKCalendarCellStateOutOfCurrentScope` instead.
 - CKCalendarMonthCellStateInactiveSelected: Deprecated. Use `CKCalendarCellStateOutOfCurrentScopeSelected` instead.
 - CKCalendarMonthCellStateOutOfRange: Deprecated. Use `CKCalendarCellStateOutOfRange` instead.
 */
typedef NS_ENUM(NSUInteger, CKCalendarCellState) {
    CKCalendarCellStateTodaySelected,
    CKCalendarCellStateToday,
    CKCalendarCellStateDefault,
    CKCalendarCellStateSelected,
    CKCalendarCellStateOutOfCurrentScope,
    CKCalendarCellStateOutOfCurrentScopeSelected,
    CKCalendarCellStateOutOfRange,
    
    CKCalendarMonthCellStateTodaySelected __deprecated_enum_msg("Use CKCalendarCellStateTodaySelected instead."),
    CKCalendarMonthCellStateTodayDeselected __deprecated_enum_msg("Use CKCalendarCellStateToday instead."),
    CKCalendarMonthCellStateNormal __deprecated_enum_msg("Use CKCalendarCellStateDefault instead."),
    CKCalendarMonthCellStateSelected __deprecated_enum_msg("Use CKCalendarCellStateSelected instead."),
    CKCalendarMonthCellStateInactive __deprecated_enum_msg("Use CKCalendarCellStateOutOfCurrentScope instead."),
    CKCalendarMonthCellStateInactiveSelected __deprecated_enum_msg("Use CKCalendarCellStatefOutOfCurrentScopeSelected instead."),
    CKCalendarMonthCellStateOutOfRange __deprecated_enum_msg("Use CKCalendarCellStateOutOfRange instead.")
    
} NS_SWIFT_NAME(CalendarCellState);

// Maintain backwards compatibility with MBCalendarKit 4.x.x
typedef CKCalendarCellState CKCalendarMonthCellState;

#endif
