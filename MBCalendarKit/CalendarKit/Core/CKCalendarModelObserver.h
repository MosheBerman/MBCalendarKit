//
//  CKCalendarModelObserver.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/11/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

@import Foundation;

@class CKCalendarModel;

/**
 This protocol defines an interface for the calendar view to internally monitor the `CKCalendarModel`.
 */
NS_SWIFT_NAME(CalendarModelObserver)
@protocol CKCalendarModelObserver <NSObject>

// MARK: - Handling Date Changes
/**
 Called before the calendar model will change the its date.

 @param model The model object that will change.
 @param fromDate The old date.
 @param toDate The new date.
 */
- (void)calendarModel:(CKCalendarModel *)model willChangeFromDate:(NSDate *)fromDate toNewDate:(NSDate *)toDate;

/**
 Called after the calendar model will change the its date.
 
 @param model The model object that did change.
 @param fromDate The old date.
 @param toDate The new date.
 */
- (void)calendarModel:(CKCalendarModel *)model didChangeFromDate:(NSDate *)fromDate toNewDate:(NSDate *)toDate;


// MARK: - Handling Display Mode Changes

/**
 Called before the calendar model changes the displayMode.

 @param model The model
 @param oldMode The display mode before the change.
 @param newMode The display mode after the change.
 */
- (void)calendarModel:(CKCalendarModel *)model willChangeFromDisplayMode:(CKCalendarViewDisplayMode)oldMode toDisplayMode:(CKCalendarViewDisplayMode)newMode;

/**
 Called after the calendar model changes the displayMode.
 
 @param model The model
 @param oldMode The display mode before the change.
 @param newMode The display mode after the change.
 */
- (void)calendarModel:(CKCalendarModel *)model didChangeFromDisplayMode:(CKCalendarViewDisplayMode)oldMode toDisplayMode:(CKCalendarViewDisplayMode)newMode;


// MARK: - Handling Other Model Changes

/**
 Called after the calendar model updates its `displayMode`, `calendar` or `locale` properties.
 
 @param model The model that did change.
 */
- (void)calendarModelDidInvalidate:(CKCalendarModel *)model;

@end
