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
@class CKCalendarCellContext;

/**
 This protocol provides the interface necessary to support custom cells in a calendar.
 */
NS_SWIFT_NAME(CustomCellProviding)
@protocol CKCustomCellProviding <NSObject>

@optional
// MARK: - Providing a Custom Cell

/**
 Returns the class to register with the calendar view as capable of acting as a calendar cell.
 This class must subclass `UICollectionViewCell`. It is considered a runtime exception to register a class that does not subclass UICollectionViewCell.
 
 The calendar view will call this method when you call reload on it, or when you set the its provider. 
 **Node:** This method does not get called for every cell on every rendering pass. It is called when you assign the calendar view's
 `customCellProvider` property, or when you call the calendar view's `refreshCustomCellClass` method.

 @return The class to use for the cell.
 */

@property (nonatomic, nonnull, readonly) Class customCellClass;

@required
// MARK: - Configuring the Cell Before Display

/**
 Called on the custom cell provider before

 @param calendarView The calendar view instance.
 @param cell The cell that will be used. If you registered a custom subclass, it will be of that class. If not, you will get a `CKCalendarCell` instance.
 @param context Some contextual information about the date represented by the cell.

 */
- (void)calendarView:(nonnull CKCalendarView *)calendarView willDisplayCell:(nonnull UICollectionViewCell *)cell inContext:(nonnull CKCalendarCellContext *)context;

@end

#endif /* CKCustomCellProviding_h */
