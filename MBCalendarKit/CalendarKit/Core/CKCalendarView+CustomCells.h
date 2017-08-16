//
//  CKCalendarView+CustomCells.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarView.h"

@interface CKCalendarView (CustomCells)

// MARK: Changing the Custom Cell Class at Runtime

/**
 Registers a class as the class to use for the cell. 
 
 Calling this method is only required if you wish to inform the calendar view that the custom cell class has changed at runtime.
 
 Change the class by changing the `customCellClass` property of your custom cell provider.
 */

- (void)refreshCustomCellClass;

@end
