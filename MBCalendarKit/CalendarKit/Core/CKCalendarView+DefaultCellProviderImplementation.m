//
//  CKCalendarView+DefaultCellProviderImplementation.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarView+DefaultCellProviderImplementation.h"
#import "CKCalendarModel.h"
#import "CKCalendarCell.h"
#import "CKCalendarCellContext.h"
#import "NSCalendarCategories.h"

@interface CKCalendarView ()

/**
 The model that the calendar uses internally.
 
 This method is necessaery to allow the category to access the property that we know to exist on the base class.

 @return The calendar's model.
 */
- (nonnull CKCalendarModel *)calendarModel;

@end

@implementation CKCalendarView (DefaultCellProviderImplementation)

/**
 Returns a custom cell class to register.

 @return This implementation returns CKCalendarCell.
 */
- (nonnull Class)customCellClass;
{
    return CKCalendarCell.class;
}


/**
 Called on each cell to configure it.

 This implementation makes the assumes that we've registered the `CKCalendarCell` class as our default cell class.
 
 @param calendarView The calendar view about to do display.
 @param cell The cell to configure for display.

 */
- (void)calendarView:(CKCalendarView *)calendarView willDisplayCell:(UICollectionViewCell *)cell inContext:(nonnull CKCalendarCellContext *)context;
{
    // STEP 1: Access the cell. It's safe to cast to whatever class is in `customCellClass`.
    CKCalendarCell *calendarCell = (CKCalendarCell *)cell;

    /* If a cell represents today, highlight it. */
    calendarCell.state = context.identifier;
    
    /* Show the day of the month in the cell. */
    NSInteger day = [self.calendar component:NSCalendarUnitDay fromDate:context.date];
    calendarCell.number = day;
    
    if([self.dataSource respondsToSelector:@selector(calendarView:eventsForDate:)])
    {
        BOOL showDot = ([self.dataSource calendarView:self eventsForDate:context.date].count > 0);
        calendarCell.showDot = showDot;
    }
    else
    {
        calendarCell.showDot = NO;
    }
}

@end
