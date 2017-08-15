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
 <#Description#>

 @return <#return value description#>
 */
- (CKCalendarModel *)calendarModel;

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
 @param date The date that the cell represents.
 */
- (void)calendarView:(CKCalendarView *)calendarView willDisplayCell:(UICollectionViewCell *)cell forDate:(NSDate *)date withContext:(nonnull CKCalendarCellContext *)context;
{
    // STEP 1: First, we figure out some state about the calendar.
    BOOL cellRepresentsToday = context.isToday;
    BOOL isThisMonth = context.isInSameMonthAsToday;
    BOOL isInRange = (!context.isAfterMaximumDate) && (!context.isBeforeMinimumDate);
    
    // STEP 2: Now we access the cell. It's safe to cast to whatever class is in `customCellClass`.
    CKCalendarCell *calendarCell = (CKCalendarCell *)cell;
    
    // STEP 3: Configure the cell
    if (cellRepresentsToday && isThisMonth && isInRange)
    {
        calendarCell.state = CKCalendarCellStateTodayDeselected;
    }
    else if(!isInRange)
    {
        [calendarCell setOutOfRange];
    }
    else if (!isThisMonth) {
        calendarCell.state = CKCalendarCellStateOutOfCurrentScope;
    }
    else
    {
        calendarCell.state = CKCalendarCellStateDeselected;
    }
    
    /* If a cell represents today, highlight it. */
    
    if([self.calendarModel.calendar isDate:date equalToDate:self.calendarModel.date toUnitGranularity:NSCalendarUnitDay])
    {
        [calendarCell setSelected];
    }
    
    /* Show the day of the month in the cell. */
    
    NSUInteger day = [self.calendar daysInDate:date];
    calendarCell.number = @(day);
    
    if([self.dataSource respondsToSelector:@selector(calendarView:eventsForDate:)])
    {
        BOOL showDot = ([self.dataSource calendarView:self eventsForDate:date].count > 0);
        calendarCell.showDot = showDot;
    }
    else
    {
        calendarCell.showDot = NO;
    }
}

@end
