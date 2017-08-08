//
//  CKCalendarHeaderViewDelegate.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#ifndef CKCalendarHeaderViewDelegate_h
#define CKCalendarHeaderViewDelegate_h

/**
 The delegate responds to touches in the header view and changes the date appropriately.
 */
@protocol CKCalendarHeaderViewDelegate <NSObject>

/**
 Called when the forward button is tapped.
 */
- (void)forwardTapped;

/**
 Called when the backward button is tapped.
 */
- (void)backwardTapped;

@end

#endif /* CKCalendarHeaderViewDelegate_h */
