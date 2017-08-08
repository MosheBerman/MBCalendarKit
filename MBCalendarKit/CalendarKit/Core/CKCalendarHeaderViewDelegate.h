//
//  CKCalendarHeaderViewDelegate.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/8/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#ifndef CKCalendarHeaderViewDelegate_h
#define CKCalendarHeaderViewDelegate_h

@protocol CKCalendarHeaderViewDelegate <NSObject>

- (void)forwardTapped;
- (void)backwardTapped;

@end

#endif /* CKCalendarHeaderViewDelegate_h */
