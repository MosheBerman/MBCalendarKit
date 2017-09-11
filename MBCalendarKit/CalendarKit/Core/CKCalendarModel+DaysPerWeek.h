//
//  CKCalendarModel+DaysPerWeek.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/6/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel.h"

@interface CKCalendarModel (DaysPerWeek)

// MARK: - Getting the Number of Days Per Week

/**
 Returns the number of days per week.
 
 @return The number of days in a week on the given calendar system.
 */
@property (nonatomic, assign, readonly) NSUInteger daysPerWeek;

@end
