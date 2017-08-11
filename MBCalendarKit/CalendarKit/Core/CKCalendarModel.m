//
//  CKCalendarModel.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel.h"
#import "NSCalendar+Juncture.h"

@implementation CKCalendarModel

// MARK: - Initializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _calendar = [NSCalendar currentCalendar];
        _displayMode = CKCalendarViewModeMonth;
        _date = [NSDate date];
    }
    return self;
}

// MARK: - Getting the First Visible Date

/**
 Returns the first visible date in the calendar grid view.
 
 @return A date representing the first day of the week, respecting the calendar's start date.
 */
- (nonnull NSDate *)firstVisibleDate;
{
    CKCalendarDisplayMode displayMode = self.displayMode;
    NSDate *firstVisibleDate = self.date; /* Default to self.date */
    
    // for the day mode, just return today
    if (displayMode == CKCalendarViewModeDay)
    {
        // The default suits this case well
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        firstVisibleDate = [self.calendar firstDayOfTheWeekUsingReferenceDate:self.date andStartDay:self.calendar.firstWeekday];
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        NSDate *firstOfTheMonth = [self.calendar firstDayOfTheMonthUsingReferenceDate:self.date];
        
        firstVisibleDate = [self.calendar firstDayOfTheWeekUsingReferenceDate:firstOfTheMonth andStartDay:self.calendar.firstWeekday];
    }
    
    return firstVisibleDate;
}

/**
 Returns the first visible date in the calendar grid view.
 
 @return A date representing the first day of the week, respecting the calendar's start date.
 */
- (nonnull NSDate *)lastVisibleDate;
{
    CKCalendarDisplayMode displayMode = self.displayMode;
    NSDate *lastVisibleDate = self.date; /* Default to self.date */
    
    // for the day mode, just return today
    if (displayMode == CKCalendarViewModeDay) {
        // The default is fine.
    }
    else if(displayMode == CKCalendarViewModeWeek)
    {
        lastVisibleDate = [self.calendar lastDayOfTheWeekUsingReferenceDate:self.date];
    }
    else if(displayMode == CKCalendarViewModeMonth)
    {
        NSDate *lastOfTheMonth = [self.calendar lastDayOfTheMonthUsingReferenceDate:self.date];
        lastVisibleDate = [self.calendar lastDayOfTheWeekUsingReferenceDate:lastOfTheMonth];
    }
    
    return lastVisibleDate;

}

@end
