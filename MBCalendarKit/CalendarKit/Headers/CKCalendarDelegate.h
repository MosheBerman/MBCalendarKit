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

@protocol CKCalendarViewDelegate <NSObject>

@optional

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date;
- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date;

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event;

@end


#endif
