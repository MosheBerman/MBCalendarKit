//
//  NSCalendar+DateManipulation.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (DateManipulation)

// MARK: - Add Units

- (nullable NSDate *)dateByAddingSeconds:(NSUInteger)seconds toDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateByAddingMinutes:(NSUInteger)minutes toDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateByAddingHours:(NSUInteger)hours toDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateByAddingDays:(NSUInteger)days toDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateByAddingWeeks:(NSUInteger)weeks toDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateByAddingMonths:(NSUInteger)months toDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateByAddingYears:(NSUInteger)years toDate:(nonnull NSDate *)date;

// MARK: - Subtract Units

- (nullable NSDate *)dateBySubtractingSeconds:(NSUInteger)seconds fromDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateBySubtractingMinutes:(NSUInteger)minutes fromDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateBySubtractingHours:(NSUInteger)hours fromDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateBySubtractingDays:(NSUInteger)days fromDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateBySubtractingWeeks:(NSUInteger)weeks fromDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateBySubtractingMonths:(NSUInteger)months fromDate:(nonnull NSDate *)date;
- (nullable NSDate *)dateBySubtractingYears:(NSUInteger)years fromDate:(nonnull NSDate *)date;

@end
