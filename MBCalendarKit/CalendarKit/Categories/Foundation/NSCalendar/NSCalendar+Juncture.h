//
//  NSCalendar+Juncture.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Juncture)

#pragma mark - First/Last of Week

- (NSDate *)firstDayOfTheWeek;
- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date;

- (NSDate *)lastDayOfTheWeek;
- (NSDate *)lastDayOfTheWeekUsingReferenceDate:(NSDate *)date;

#pragma mark - First/Last of Month

- (NSDate *)firstDayOfTheMonth;
- (NSDate *)firstDayOfTheMonthUsingReferenceDate:(NSDate *)date;

- (NSDate *)lastDayOfTheMonth;
- (NSDate *)lastDayOfTheMonthUsingReferenceDate:(NSDate *)date;

@end
