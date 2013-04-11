//
//  NSCalendar+Weekend.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Weekend)

- (NSDate *)firstDayOfTheWeek;
- (NSDate *)firstDayOfTheWeekUsingReferenceDate:(NSDate *)date;

- (NSDate *)firstDayOfTheMonth;
- (NSDate *)firstDayOfTheMonthUsingReferenceDate:(NSDate *)date;

@end
