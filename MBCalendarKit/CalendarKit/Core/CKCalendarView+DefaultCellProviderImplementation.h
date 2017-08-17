//
//  CKCalendarView+DefaultCellProviderImplementation.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarView.h"

/**
 
 The implementation of the default cell.
 
 1. Inform the calendar what class you want to use to display the cell by overriding `customCellClass`. The class which you return must be a subclass of `UICollectionViewCell`.
 2. Implement your UI in that class, using autolayout and code. (Interface Builder won't work here.)
 3. Implement `calendarView:willDisplayCell:inContext:`. In that method, cast the `UICollectionViewCell` to your custom class type and populate your UI.
 
 If you do not adopt `CKCustomCellProviding` somewhere in your app, the default implementation will use `CKCalendarCell` and its own configuration logic to display a user interface.
 
 While it is not necessary to declare the customCellClass property or the method signature here (becase we are adopting CKCustomCellProviding) it is here for clarity, and as an example.
 
 */
@interface CKCalendarView (DefaultCellProviderImplementation) <CKCustomCellProviding>



// MARK: - Providing a Custom Cell

/**
 Returns the class to register with the calendar view as capable of acting as a calendar cell.
 This class must subclass `UICollectionViewCell`.
 
 The calendar view will call this method when you call reload on it, or when you set the its provider.
 **Important:** This method does not get called for every cell on every rendering pass. It is called when you assign the calendar view's
 `customCellProvider` property, or when you call the calendar view's register
 
 @return The class to use for the cell.
 */

@property (nonatomic, nonnull, readonly) Class customCellClass;

/**
 Called on each cell to configure it.
 
 This implementation makes the assumes that we've registered the `CKCalendarCell` class as our default cell class.
 
 @param calendarView The calendar view about to do display.
 @param cell The cell to configure for display.
 
 */
- (void)calendarView:(nonnull CKCalendarView *)calendarView willDisplayCell:(nonnull UICollectionViewCell *)cell inContext:(nonnull CKCalendarCellContext *)context;

@end
