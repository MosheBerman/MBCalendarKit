//
//  CKCakeMonthCellStates.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#ifndef MBChocolateCake_CKCakeMonthCellStates_h
#define MBChocolateCake_CKCakeMonthCellStates_h

typedef enum {
    CKCakeMonthCellStateTodaySelected = 0,      //  Today's cell, selected
    CKCakeMonthCellStateTodayDeselected = 1,    //  Today's cell, unselected
    CKCakeMonthCellStateNormal,                 //  Cells that are part of this month, unselected
    CKCakeMonthCellStateSelected,               //  Cells that are part of this month, selected
    CKCakeMonthCellStateInactive,               //  Cells that are not part of this month
    CKCakeMonthCellStateInactiveSelected        //  Transient state for out of month cells 
    
} CKCakeMonthCellState;

#endif
