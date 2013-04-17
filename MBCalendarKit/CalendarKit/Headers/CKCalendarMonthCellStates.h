//
//  CKCalendarMonthCellStates.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBCalendarKit_CKCalendarMonthCellStates_h
#define MBCalendarKit_CKCalendarMonthCellStates_h

typedef enum {
    CKCalendarMonthCellStateTodaySelected = 0,      //  Today's cell, selected
    CKCalendarMonthCellStateTodayDeselected = 1,    //  Today's cell, unselected
    CKCalendarMonthCellStateNormal,                 //  Cells that are part of this month, unselected
    CKCalendarMonthCellStateSelected,               //  Cells that are part of this month, selected
    CKCalendarMonthCellStateInactive,               //  Cells that are not part of this month
    CKCalendarMonthCellStateInactiveSelected        //  Transient state for out of month cells 
    
} CKCalendarMonthCellState;

#endif
