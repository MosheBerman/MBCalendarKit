//
//  CKCalendarModel.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;


/**
 New in MBCalendarKit 5.0.0, this class abstracts the data related aspects of `CKCalendarView`.
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

// MARK: - 

@end
