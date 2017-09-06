//
//  CKCalendarCellContext+Private.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarCellContext.h"

@interface CKCalendarCellContext ()

// MARK: - Creating a Context Object

/**
 Create a context object. The `calendarView` is not retained.
 
 @param date The date that we are contextualizing relative to the calendar view's current state.
 @param calendarView The calendar view to use to calculate the context.
 @return The context object based on the current date and the configuration of the calendar view.
 */
- (nonnull instancetype)initWithDate:(nonnull NSDate *)date andCalendarView:(nonnull CKCalendarView *)calendarView NS_DESIGNATED_INITIALIZER;


// MARK: - Getting Context Flags for the Cell

/**
 `YES` if the date represented by the cell represents the same day as `[NSDate date]` on the calendar displayed by the calendar view. Otherwise `NO`.
 */
@property (nonatomic, assign) BOOL isToday;

/**
 *  if the date represented by the cell represents the same day as `calendarView.date` on the calendar displayed by the calendar view. Otherwise `NO`.
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 `YES` if the date represented by the cell represents a date in the same month as `calendarView.date` on the calendar displayed by the calendar view. Otherwise, `NO`.
 */
@property (nonatomic, assign) BOOL isInSameMonthAsToday;

/**
 `YES` if the date represented by the cell represents a date earlier than the date represented by the calendar view's `minimumDate` property.
 */
@property (nonatomic, assign) BOOL isBeforeMinimumDate;

/**
 `YES` if the date represented by the cell represents a date later than the date represented by the calendar view's `maximumDate` property.
 */
@property (nonatomic, assign) BOOL isAfterMaximumDate;

@end
