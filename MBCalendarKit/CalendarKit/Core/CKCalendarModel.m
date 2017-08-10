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


// MARK: - Getting the First Visible Date

/**
 Returns the first visible date in the calendar grid view.
 
 @return A date representing the first day of the week, respecting the calendar's start date.
 */
- (NSDate *)firstVisibleDate
{
    NSDate *firstOfTheMonth = [self.calendar firstDayOfTheMonthUsingReferenceDate:self.date];
    NSDate *firstVisible = [self.calendar firstDayOfTheWeekUsingReferenceDate:firstOfTheMonth andStartDay:self.calendar.firstWeekday];
    
    return firstVisible;
}


@end
