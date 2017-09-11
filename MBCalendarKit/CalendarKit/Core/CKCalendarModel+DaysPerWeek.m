//
//  CKCalendarModel+DaysPerWeek.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel+DaysPerWeek.h"

@implementation CKCalendarModel (DaysPerWeek)

// MARK: - Getting the Number of Days Per Week

/**
 Returns the number of days per week.

 @return The number of days in a week on the given calendar system.
 */
- (NSUInteger)daysPerWeek
{
    //  Normally I wouldn't do this, but while testing performance, this might actually improve performance significantly,
    //  given how often this is called.
    //
    //  The "right" way to do this is to call
    //  `[self.calendar rangeOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfYear forDate:self.date].length`
    //
    // No calendar supported by iOS has a non-7-day week, so this is safe to do.
    
    return 7;
}

@end
