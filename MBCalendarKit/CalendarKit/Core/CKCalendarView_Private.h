//
//  CKCalendarView_Private.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/7/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#ifndef CKCalendarView_Private_h
#define CKCalendarView_Private_h

@class CKCalendarModel;

@interface CKCalendarView (Private)

/**
 A private accessor for the calendar model.

 @return The calendar model.
 */
- (nonnull CKCalendarModel *)calendarModel;

@end

#endif /* CKCalendarView_Private_h */
