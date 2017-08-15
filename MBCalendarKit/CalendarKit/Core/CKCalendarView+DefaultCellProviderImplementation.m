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
- (void)calendarView:(CKCalendarView *)calendarView willDisplayCell:(UICollectionViewCell *)cell forDate:(NSDate *)date;
{
    // STEP 1: First, we figure out some state about the calendar.
    BOOL cellRepresentsToday = [self.calendarModel.calendar isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitDay];
    BOOL isThisMonth = [self.calendarModel.calendar isDate:date equalToDate:self.date toUnitGranularity:NSCalendarUnitMonth];
    BOOL isInRange = [self.calendarModel dateIsBetweenMinimumAndMaximumDates:date];
    isInRange = isInRange || [self.calendarModel.calendar isDate:date equalToDate:self.minimumDate toUnitGranularity:NSCalendarUnitDay];
    isInRange = isInRange || [self.calendarModel.calendar isDate:date equalToDate:self.maximumDate toUnitGranularity:NSCalendarUnitDay];
    
    // STEP 2: Now we access the cell. It's safe to cast to whatever class is in `customCellClass`.
    CKCalendarCell *calendarCell = (CKCalendarCell *)cell;
    
    // STEP 3: Configure the cell
    if (cellRepresentsToday && isThisMonth && isInRange)
    {
        calendarCell.state = CKCalendarMonthCellStateTodayDeselected;
    }
    else if(!isInRange)
    {
        [calendarCell setOutOfRange];
    }
    else if (!isThisMonth) {
        calendarCell.state = CKCalendarMonthCellStateInactive;
    }
    else
    {
        calendarCell.state = CKCalendarMonthCellStateNormal;
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
