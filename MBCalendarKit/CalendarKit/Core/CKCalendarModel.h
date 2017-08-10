//
//  CKCalendarModel.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;

/**
 This class abstracts the data our from behind `CKCalendarView`, to seperate rendering from calculations.
 */
@interface CKCalendarModel : NSObject

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

// MARK: - Getting the First Visible Date

/**
 Returns the first visible date in the calendar grid view.
 
 @return A date representing the first day of the week, respecting the calendar's start date.
 */
@property (nonnull, nonatomic, readonly) NSDate *firstVisibleDate;

@end
