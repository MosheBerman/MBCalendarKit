//
//  CKCalendarGridTransitionDirection.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/11/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#ifndef CKCalendarGridTransitionDirection_h
#define CKCalendarGridTransitionDirection_h


/**
 Defines directions for the calendar to animate the transition.

 - CKCalendarTransitionDirectionBackward: The calendar is moving towards an earlier date.
 - CKCalendarTransitionDirectionForward: The calendar is moving towards a later date.
 */
typedef NS_ENUM(NSUInteger, CKCalendarTransitionDirection) {
    CKCalendarTransitionDirectionBackward,
    CKCalendarTransitionDirectionForward
} NS_SWIFT_NAME(CalendarTransitionDirection);

#endif /* CKCalendarGridTransitionDirection_h */
