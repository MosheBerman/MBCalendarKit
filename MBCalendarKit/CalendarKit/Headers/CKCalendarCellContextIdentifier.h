//
//  CKCalendarMonthCellStates.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarCellContextIdentifier_h
#define MBCalendarKit_CKCalendarCellContextIdentifier_h

/**
 These states represent the possible uses (or "contexts") for a cell in a calendar month or week view. 

 - CKCalendarCellContextIdentifierToday: The cell corresponds to `NSDate.date`.
 - CKCalendarCellContextIdentifierDefault: Any cell not covered by the other context identifiers.
 - CKCalendarCellContextIdentifierOutOfCurrentScope: The cell represents a date outside the current month in month mode, or week in week mode.
 - CKCalendarCellContextIdentifierOutOfRange: The corresponds to a date outside the range of minimumDate and maximumDate.
 - CKCalendarMonthCellStateTodaySelected: Deprecated. Use `CKCalendarCellContextIdentifierToday` instead.
 - CKCalendarMonthCellStateToday: Deprecated. Use `CKCalendarCellContextIdentifierToday` and `UICollectionViewCell.selected` instead.
 - CKCalendarMonthCellStateNormal: Deprecated. Use `CKCalendarCellContextIdentifierDefault` instead.
 - CKCalendarMonthCellStateSelected: Deprecated. Use `CKCalendarCellContextIdentifierDefault` and `UICollectionViewCell.selected` instead.
 - CKCalendarMonthCellStateInactive: Deprecated. Use `CKCalendarCellContextIdentifierOutOfCurrentScope` instead.
 - CKCalendarMonthCellStateInactiveSelected: Deprecated. Use `CKCalendarCellContextIdentifierOutOfCurrentScope` and `UICollectionViewCell.selected` instead.
 - CKCalendarMonthCellStateOutOfRange: Deprecated. Use `CKCalendarCellContextIdentifierOutOfRange` instead.
 */
typedef NS_ENUM(NSUInteger, CKCalendarCellContextIdentifier) {
    CKCalendarCellContextIdentifierToday,
    CKCalendarCellContextIdentifierDefault,
    CKCalendarCellContextIdentifierOutOfCurrentScope,
    CKCalendarCellContextIdentifierOutOfRange,
    
    CKCalendarMonthCellStateTodaySelected __deprecated_enum_msg("Use `CKCalendarCellContextIdentifierToday` with UICollectionViewCell's `highlighted` and `selected` properties instead."),
    CKCalendarMonthCellStateTodayDeselected __deprecated_enum_msg("Use CKCalendarCellContextIdentifierToday instead."),
    CKCalendarMonthCellStateNormal __deprecated_enum_msg("Use CKCalendarCellContextIdentifierDefault instead."),
    CKCalendarMonthCellStateSelected __deprecated_enum_msg("Use `CKCalendarCellContextIdentifierDefault` with UICollectionViewCell's `highlighted` and `selected` properties instead."),
    CKCalendarMonthCellStateInactive __deprecated_enum_msg("Use CKCalendarCellContextIdentifierOutOfCurrentScope instead."),
    CKCalendarMonthCellStateInactiveSelected __deprecated_enum_msg("Use `CKCalendarCellContextIdentifierfOutOfCurrentScope` with UICollectionViewCell's `highlighted` and `selected` properties instead."),
    CKCalendarMonthCellStateOutOfRange __deprecated_enum_msg("Use `CKCalendarCellContextIdentifierOutOfRange` instead.")
    
} NS_SWIFT_NAME(CalendarCellContextIdentifier);

// Maintain backwards compatibility with MBCalendarKit 4.x.x
typedef CKCalendarCellContextIdentifier CKCalendarMonthCellState;

#endif
