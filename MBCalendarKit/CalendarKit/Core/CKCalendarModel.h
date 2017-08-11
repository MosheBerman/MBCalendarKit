//
//  CKCalendarModel.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;

#import "CKCalendarGridViewDataSource.h"
#import "CKCalendarViewMode.h"

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

// MARK: - Display Mode

/**
 The display mode determines how much information the calendar shows at once.
 */
@property (nonatomic, assign) CKCalendarDisplayMode displayMode;

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
