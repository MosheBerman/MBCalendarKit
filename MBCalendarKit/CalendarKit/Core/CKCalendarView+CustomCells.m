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

// MARK: Changing the Custom Cell Class at Runtime

/**
 Registers a class as the class to use for the cell.
 
 Calling this method is only required if you wish to inform the calendar view that the custom cell class has changed at runtime.
 
 Change the class by changing the `customCellClass` property of your custom cell provider.
 */

- (void)refreshCustomCellClass;
{
    Class cellClass = self.customCellProvider.customCellClass;
    
    if(![cellClass isSubclassOfClass: [UICollectionViewCell class]])
    {
        @throw [NSException exceptionWithName:@"CKCalendarViewCustomCellException" reason:@"The class you choose to use as a custom cell must subclass UICollectionViewCell." userInfo:@{@"CKCalendarView": self}];
    }
    
    [self.gridView setCellClass:cellClass];
    [self reloadAnimated:NO];
}

@end
