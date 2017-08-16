//
//  CKCalendarView+DefaultCellProviderImplementation.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarView+DefaultCellProviderImplementation.h"
#import "CKCalendarModel.h"

@interface CKCalendarView ()


/**
 The model that the calendar uses internally.

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
    return CKCalendarCellDefault.class;
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
    CKCalendarCellDefault *calendarCell = (CKCalendarCellDefault *)cell;
    
    calendarCell.state = context.state;
    
    /* If a cell represents today, highlight it. */
    
    if([self.calendarModel.calendar isDate:context.date equalToDate:self.calendarModel.date toUnitGranularity:NSCalendarUnitDay])
    {
        [calendarCell setSelected];
    }
    
    /* Show the day of the month in the cell. */
    
    NSUInteger day = [self.calendar daysInDate:context.date];
    calendarCell.number = @(day);
    
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
