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
typedef NS_ENUM(NSUInteger, CKCalendarViewDisplayMode) {
    CKCalendarViewDisplayModeMonth = 0,
    CKCalendarViewDisplayModeWeek = 1,
    CKCalendarViewDisplayModeDay = 2,
    CKCalendarViewModeMonth __deprecated_enum_msg("Use CKCalendarViewDisplayModeMonth instead.") = 0,
    CKCalendarViewModeWeek __deprecated_enum_msg("Use CKCalendarViewDisplayModeWeek instead.") = 1,
    CKCalendarViewModeDay __deprecated_enum_msg("Use CKCalendarViewDisplayModeDay instead.") = 2
    
};

// Maintain backwards compatibility with MBCalendarKit 4.x.x
typedef CKCalendarViewDisplayMode CKCalendarDisplayMode;

#endif
