//
//  NSCalendar+DateManipulation.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (DateManipulation)

#pragma mark - Add Units

- (NSDate *)dateByAddingSeconds:(NSUInteger)seconds toDate:(NSDate *)date;
- (NSDate *)dateByAddingMinutes:(NSUInteger)minutes toDate:(NSDate *)date;
- (NSDate *)dateByAddingHours:(NSUInteger)hours toDate:(NSDate *)date;
- (NSDate *)dateByAddingDays:(NSUInteger)days toDate:(NSDate *)date;
- (NSDate *)dateByAddingWeeks:(NSUInteger)weeks toDate:(NSDate *)date;
- (NSDate *)dateByAddingMonths:(NSUInteger)months toDate:(NSDate *)date;
- (NSDate *)dateByAddingYears:(NSUInteger)years toDate:(NSDate *)date;

#pragma mark - Subtract Units

- (NSDate *)dateBySubtractingSeconds:(NSUInteger)seconds fromDate:(NSDate *)date;
- (NSDate *)dateBySubtractingMinutes:(NSUInteger)minutes fromDate:(NSDate *)date;
- (NSDate *)dateBySubtractingHours:(NSUInteger)hours fromDate:(NSDate *)date;
- (NSDate *)dateBySubtractingDays:(NSUInteger)days fromDate:(NSDate *)date;
- (NSDate *)dateBySubtractingWeeks:(NSUInteger)weeks fromDate:(NSDate *)date;
- (NSDate *)dateBySubtractingMonths:(NSUInteger)months fromDate:(NSDate *)date;
- (NSDate *)dateBySubtractingYears:(NSUInteger)years fromDate:(NSDate *)date;

@end
