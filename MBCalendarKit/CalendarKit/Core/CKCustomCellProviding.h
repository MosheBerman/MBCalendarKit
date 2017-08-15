//
//  CKCustomCellProviding.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#ifndef CKCustomCellProviding_h
#define CKCustomCellProviding_h

@import Foundation;

@class CKCalendarView;

/**
 This protocol provides the interface necessary to support custom cells in a calendar.
 */
@protocol CKCustomCellProviding <NSObject>


// MARK: - Providing a Custom Cell

/**
 Returns the class to register with the calendar view as capable of acting as a calendar cell.
 This class must subclass `UICollectionViewCell`. 
 
 The calendar view will call this method when you call reload on it, or when you set the its provider. **Important:** This method does not get called for every cell on every rendering pass.

 @return The class to use for the cell.
 */
- (nonnull Class)customCellClass;


// MARK: - Configuring the Cell Before Display

/**
 Called on the custom cell provider before

 @param calendarView The calendar view instance.
 @param cell The cell that will be used. If you registered a custom subclass, it will be of that class. If not, you will get a `CKCalendarCell` instance.
 @param date The date being used for the calendar cell.
 */
- (void)calendarView:(nonnull CKCalendarView *)calendarView willDisplayCell:(nonnull UICollectionViewCell *)cell forDate:(nonnull NSDate *)date;

@end

#endif /* CKCustomCellProviding_h */
