//
//  CKCalendarDataSource.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarDataSource_h
#define MBCalendarKit_CKCalendarDataSource_h

@class CKCalendarView;
@class CKCalendarEvent;

NS_SWIFT_NAME(CalendarViewDataSource)
@protocol CKCalendarViewDataSource <NSObject>

// MARK: - Supplying Display Data

/**
 Allows the data source to supply events to display on the calendar.
 
 @param calendarView The calendar view instance that will display the data.
 @param date The date for which the calendar view wants events.
 @return An array of events objects. If there are no events for a given date, return an empty array.
 */
- (nonnull NSArray <CKCalendarEvent *> *)calendarView:(nonnull CKCalendarView *)calendarView eventsForDate:(nonnull NSDate *)date;

@end

#endif
