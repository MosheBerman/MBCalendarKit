//
//  CKCalendarView+CustomCells.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarView.h"

@interface CKCalendarView (CustomCells)

// MARK: Manually Registering a Custom Cell Class

/**
 Registers a class as the class to use for the cell. 
 You only need to call this if you want to change the custom cell class after setting the `customCellProvider`.
 
 @param cellClass A class. This class must be `UICollectionViewCell` or a subclass of `UICollectionViewCell`.
 */
- (void)registerCellClass:(nullable Class)cellClass;

@end
