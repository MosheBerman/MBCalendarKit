//
//  CKCalendarViewMode.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarViewMode_h
#define MBCalendarKit_CKCalendarViewMode_h

/**
 The supported display modes of the calendar view.

 - CKCalendarViewModeMonth: The month view displays a grid of days, with each row containing one week.
 - CKCalendarViewModeWeek: Displays a single week of days at once.
 - CKCalendarViewModeDay: Displays no grid below the header. Instead just shows the header, date traversal buttons, and a list of events for that day.
 */
typedef NS_ENUM(NSUInteger, CKCalendarViewMode) {
    CKCalendarViewModeMonth = 0,
    CKCalendarViewModeWeek = 1,
    CKCalendarViewModeDay = 2
};

// Maintain backwards compatibility with MBCalendarKit 4.x.x
typedef CKCalendarViewMode CKCalendarDisplayMode;

#endif
