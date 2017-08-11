//
//  CKCalendarModel+GridViewSupport.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel+GridViewSupport.h"

@import UIKit;

@implementation CKCalendarModel (GridViewSupport)

// MARK: - Mapping Dates and Index Paths

/**
 Returns an NSDate representing the day being displayed by the index path.
 
 @discussion If the index path isn't visible, returns `nil`.
 @param indexPath An index path to convert to a date.
 @return An NSDate represented by the index path.
 */
- (nullable NSDate *)dateForIndexPath:(nonnull NSIndexPath *)indexPath;
{
    NSDate *correspondingDate = nil;
    
    NSDate *firstVisible = [self firstVisibleDate];
    NSInteger daysToAdd = (indexPath.section * [self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self.date].length) + indexPath.item;
    
    correspondingDate = [self.calendar dateByAddingUnit:NSCalendarUnitDay value:daysToAdd toDate:firstVisible options:0];
    
    return correspondingDate;
}

/**
 Converts a date into an index path.
 
 @discussion If the date isn't visible, returns `nil`.
 @param date Returns a date corresponding to the index path.
 @return An index path for the cell displaying the date.
 */
- (nullable NSIndexPath *)indexPathForDate:(NSDate *)date;
{
    NSIndexPath *indexPath = nil;
    
    NSDate *firstDate = [self firstVisibleDate];
    NSInteger weeks = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:firstDate toDate:date options:0].weekOfYear;
    NSInteger days = [self.calendar components:NSCalendarUnitDay fromDate:firstDate toDate:date options:0].day;
    NSInteger daysPerWeek = [self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:date].length;
    
    indexPath = [NSIndexPath indexPathForRow:days % daysPerWeek inSection:weeks];
    
    return indexPath;
}

// MARK: - CKCalendarGridViewDataSource

/**
 The number of columns that the grid view should display.
 */
- (NSUInteger)numberOfColumns;
{
    return [self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self.date].length;
}

/**
 The number of rows that the grid view should display.
 */
- (NSUInteger)numberOfRows;
{
    NSInteger numberOfRows = 0;
    
    if (self.displayMode == CKCalendarViewModeMonth)
    {
        numberOfRows = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:self.date].length;
    }
    else if (self.displayMode == CKCalendarViewModeWeek)
    {
        numberOfRows = 1;
    }
    
    return numberOfRows;
}




@end
