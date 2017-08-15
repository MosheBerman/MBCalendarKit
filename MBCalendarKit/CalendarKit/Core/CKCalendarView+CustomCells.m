//
//  CKCalendarView+CustomCells.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarView+CustomCells.h"
#import "CKCalendarGridView.h"

@interface CKCalendarView ()

/**
 A method which exposes the internal grid view to the category.

 @return The grid view.
 */
- (nonnull CKCalendarGridView *)gridView;

@end

@implementation CKCalendarView (CustomCells)

// MARK: Registering a Custom Cell Class

/**
 Registers a class as the class to use for the cell then reloads the calendar.
 
 This class must be `UICollectionViewCell` or a subclass of `UICollectionViewCell`.
 Attempting to register a class that is not a subclass of `UICollectionViewCell` will 
 cause this method to throw an exception.
 
 @param class A class.
 */
- (void)registerCellClass:(nullable Class)cellClass;
{
    if(![cellClass isSubclassOfClass: [UICollectionViewCell class]])
    {
        @throw [NSException exceptionWithName:@"CKCalendarViewCustomCellException" reason:@"The class you choose to use as a custom cell must subclass UICollectionViewCell." userInfo:@{@"CKCalendarView": self}];
    }
    
    [self.gridView setCellClass:cellClass];
    [self reloadAnimated:NO];
}

@end
