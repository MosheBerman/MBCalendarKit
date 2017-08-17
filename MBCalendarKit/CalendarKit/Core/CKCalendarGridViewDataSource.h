//
//  CKCalendarGridViewDataSource.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;

/**
 The `CKCalendarGridViewDataSource` defines an interface for the calendar grid to obtain information about how many cells it needs to show.
 */
NS_SWIFT_NAME(CalendarGridViewDataSource)
@protocol CKCalendarGridViewDataSource <NSObject>

// MARK: - Mapping Dates and Index Paths

/**
 Returns an NSDate representing the day being displayed by the index path.
 
 @discussion If the index path isn't visible, returns `nil`.
 @param indexPath An index path to convert to a date.
 @return An NSDate represented by the index path.
 */
- (nullable NSDate *)dateForIndexPath:(nonnull NSIndexPath *)indexPath;

/**
 Converts a date into an index path.
 
 @discussion If the date isn't visible, returns `nil`.
 @param date Returns a date corresponding to the index path.
 @return An index path for the cell displaying the date.
 */
- (nullable NSIndexPath *)indexPathForDate:(nonnull NSDate *)date;

// MARK: - Defining Rows and Columns

/**
 The number of columns that the grid view should display.
 */
@property (readonly, nonatomic, assign) NSUInteger numberOfColumns;

/**
 The number of rows that the grid view should display.
 */
@property (readonly, nonatomic, assign) NSUInteger numberOfRows;

@end
