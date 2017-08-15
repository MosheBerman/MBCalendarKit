//
//  CKCalendarView+DefaultCellProviderImplementation.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import <MBCalendarKit/MBCalendarKit.h>

@interface CKCalendarView (DefaultCellProviderImplementation) <CKCustomCellProviding>

/**
 
 See the implementation for an example of the default cell.
 
 1. Inform the calendar what class you want to use to display the cell by overriding `customCellClass`. The class which you return must be a subclass of `UICollectionViewCell`.
 2. Implement your UI in that class, using autolayout and code. (Interface Builder won't work here.)
 3. Implement `calendarView:willDisplayCell:forDate:`. In that method, cast the `UICollectionViewCell` to your custom class type and populate your UI.
 
 If you do not adopt `CKCustomCellProviding` somewhere in your app, the default implementation will use `CKCalendarCell` and its own configuration logic to display a user interface.
 
 */

@end
