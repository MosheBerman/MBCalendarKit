//
//  CKCalendarCellContext_Private.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarCellContext.h"

@interface CKCalendarCellContext ()

/**
 `YES` if the date represented by the cell represents the same day as `[NSDate date]` on the calendar displayed by the calendar view. Otherwise `NO`.
 */
@property (nonatomic, assign, readwrite) BOOL isToday;

/**
 *  if the date represented by the cell represents the same day as `calendarView.date` on the calendar displayed by the calendar view. Otherwise `NO`.
 */
@property (nonatomic, assign, readwrite) BOOL isSelected;

/**
 `YES` if the date represented by the cell represents a date in the same month as `calendarView.date` on the calendar displayed by the calendar view. Otherwise, `NO`.
 */
@property (nonatomic, assign, readwrite) BOOL isInSameMonthAsToday;

/**
 `YES` if the date represented by the cell represents a date earlier than the date represented by the calendar view's `minimumDate` property.
 */
@property (nonatomic, assign, readwrite) BOOL isBeforeMinimumDate;

/**
 `YES` if the date represented by the cell represents a date later than the date represented by the calendar view's `maximumDate` property.
 */
@property (nonatomic, assign, readwrite) BOOL isAfterMaximumDate;

@end
