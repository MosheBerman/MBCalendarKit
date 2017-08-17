//
//  CKCalendarViewDelegate.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarViewDelegate_h
#define MBCalendarKit_CKCalendarViewDelegate_h

@class CKCalendarView;
@class CKCalendarEvent;

NS_SWIFT_NAME(CalendarViewDelegate)
@protocol CKCalendarViewDelegate <NSObject>

@optional

// MARK: - Handling Date Selection

/**
 Called immediately before a date is selected in the calendar's table view.

 @param calendarView The calendar view which the user interacted with.
 @param date The date which the user selected.
 */
- (void)calendarView:(nonnull CKCalendarView *)calendarView willSelectDate:(nonnull NSDate *)date;

/**
 Called immediately after a date is selected in the calendar's table view.
 
 @param calendarView The calendar view which the user interacted with.
 @param date The date which the user selected.
 */
- (void)calendarView:(nonnull CKCalendarView *)calendarView didSelectDate:(nonnull NSDate *)date;

// MARK: - Handling Event Selection

/**
 Called after an event is selected in the calendar's table view.

 @discussion You can use this to respond to the user selecting an event. For example, you may wish to present a detail view controller.
 
 @param calendarView The calendar view who's table view had an event selected.
 @param event The event which was selected.
 */
- (void)calendarView:(nonnull CKCalendarView *)calendarView didSelectEvent:(nonnull CKCalendarEvent *)event;

@end

#endif
