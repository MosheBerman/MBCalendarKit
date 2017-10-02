//
//  CKCalendarCellContext.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;
@class CKCalendarView;

#import "CKCalendarCellContextIdentifier.h"

NS_SWIFT_NAME(CalendarCellContext)
/**
 This class provides a wrapper around the context a cell is being displayed in.
 */
@interface CKCalendarCellContext : NSObject

// MARK: - The Date The Cell Represents

/**
 The date that the context represents.
 */
@property (nonatomic, strong, nonnull, readonly) NSDate *date;

// MARK: - The State that the Cell Is In

/**
 The kind of context, calculated with on the flags below.
 */
@property (nonatomic, assign, readonly) CKCalendarCellContextIdentifier identifier;

// MARK: - Getting Context Flags for the Cell

/**
 `YES` if the date represented by the cell represents the same day as `[NSDate date]` on the calendar displayed by the calendar view. Otherwise `NO`.
 */
@property (nonatomic, assign, readonly) BOOL isToday;

/**
 *  if the date represented by the cell represents the same day as `calendarView.date` on the calendar displayed by the calendar view. Otherwise `NO`.
 */
@property (nonatomic, assign, readonly) BOOL isSelected;

/**
 `YES` if the date represented by the cell represents a date in the same month as `calendarView.date` on the calendar displayed by the calendar view. Otherwise, `NO`.
 */
@property (nonatomic, assign, readonly) BOOL isInSameMonthAsToday;

/**
 `YES` if the date represented by the cell represents a date earlier than the date represented by the calendar view's `minimumDate` property.
 */
@property (nonatomic, assign, readonly) BOOL isBeforeMinimumDate;

/**
 `YES` if the date represented by the cell represents a date later than the date represented by the calendar view's `maximumDate` property.
 */
@property (nonatomic, assign, readonly) BOOL isAfterMaximumDate;


// MARK: - Creating a Context Object

/**
 Create a context object. The `calendarView` is not retained.
 
 @param date The date that we are contextualizing relative to the calendar view's current state.
 @param calendarView The calendar view to calculate the context for.
 @return The context object based on the current date and the configuration of the calendar view.
 */
- (nonnull instancetype)initWithDate:(nonnull NSDate *)date andCalendarView:(nonnull CKCalendarView *)calendarView;

// Mark `init` as unavailable.
- (nonnull instancetype)init NS_UNAVAILABLE;

@end
