//
//  CKCalendarModel.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;

#import "CKCalendarViewDisplayMode.h"
#import "CKCalendarModelObserver.h"

/**
 This class abstracts the data our from behind `CKCalendarView`, to seperate rendering from calculations.
 */
NS_SWIFT_NAME(CalendarModel)
@interface CKCalendarModel : NSObject

// MARK: - Observing Changes to the Model

@property (nonatomic, weak, nullable) id<CKCalendarModelObserver> observer;

// MARK: - The Calendar System

/**
 The calendar system used to display the view.
 */
@property (nonatomic, strong, nonnull) NSCalendar *calendar;

// MARK: - Date Selection

/**
 The date being displayed by the calendar view.
 */
@property (nonatomic, strong, nonnull) NSDate *date;

// MARK: - Clamping Date with Minimum and Maximum

/**
 When set, this prevents dates prior to itself from being selected in the calendar or set programmatically.
 By default, this is `nil`.
 */
@property (nonatomic, strong, nullable) NSDate *minimumDate;

/**
 When set, this prevents dates later to itself from being selected in the calendar or set programmatically.
 By default, this is `nil`.
 */
@property (nonatomic, strong, nullable) NSDate *maximumDate;

/**
 Determines if the supplied date is within range of the minimum and maximum dates.
 
 @param date The date to check.
 @return `YES` as long as the `date` is not before `minimum` or after `maximum`.
 */
- (BOOL)dateIsBetweenMinimumAndMaximumDates:(nonnull NSDate *)date;


// MARK: - Display Mode

/**
 The display mode determines how much information the calendar shows at once.
 */
@property (nonatomic, assign) CKCalendarViewDisplayMode displayMode;


// MARK: - Getting the First Visible Date

/**
 The first visible date in the calendar grid view,
 based on the value of displayMode.
 */
@property (nonnull, nonatomic, readonly) NSDate *firstVisibleDate;

/**
 The last visible date in the calendar grid view,
 based on the value of displayMode.
 */
@property (nonnull, nonatomic, readonly) NSDate *lastVisibleDate;

@end
